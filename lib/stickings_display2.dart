import 'dart:ffi';

import 'package:trotter/trotter.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:rhythm_practice_helper/stickings_settings.dart';
import 'package:rhythm_practice_helper/timer_widget.dart';
import 'styles.dart';
import 'stickings_generate.dart';

class StickingsDisplay2 extends StatefulWidget {
  const StickingsDisplay2({super.key});

  @override
  StickingsDisplay2State createState() => StickingsDisplay2State();
}

class StickingsDisplay2State extends State<StickingsDisplay2> {
  BigInt stickingIndex = BigInt.from(0);
  bool editingSettings = false;

  bool showTimer = false;

  SettingsRepository<StickingsSettings> settingsRepository =
      SettingsRepository<StickingsSettings>(
          settings: StickingsSettings(), parentKey: "");
  // late List<String> stickings = generateStickings(settingsRepository.settings);
  late Amalgams<String> stickingsAmalgams = Amalgams(
      settingsRepository.settings.stickingLength,
      settingsRepository.settings.limbs.usingSticks
          .map((e) => e.symbol)
          .toList());
  late var stickings = stickingsAmalgams
      .range(0, 10)
      .map((e) => e.reduce((value, element) => value + element))
      .toList()
      .asMap()
      .entries
      .toList();

  double textSize = 1.5;

  void editSettings() {
    setState(() {
      editingSettings = !editingSettings;
    });
    if (!editingSettings) {
      regenerate();
    }
  }

  void regenerate() {
    setState(() {
      stickingsAmalgams = Amalgams(
          settingsRepository.settings.stickingLength,
          settingsRepository.settings.limbs.usingSticks
              .map((e) => e.symbol)
              .toList());
      stickings = stickingsAmalgams
          .range(0, 100)
          .map((e) => e.reduce((value, element) => value + element))
          .toList()
          .asMap()
          .entries
          .toList();
    });
  }

  void toggleTimer() {
    setState(() {
      showTimer = !showTimer;
    });
  }

  Column get mainComponent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          settingsRepository.getWidget((settings) => Expanded(
              child: editingSettings
                  ? StickingsSettingsWidget(
                      settings: settings,
                      repository: settingsRepository,
                      onChanged: (newSettings) => setState(
                          () => settingsRepository.settings = newSettings))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          showTimer
                              ? TimerWidget(
                                  onTimerReset: () => setState(() {
                                        stickingIndex =
                                            (stickingIndex + BigInt.one) %
                                                stickingsAmalgams.length;
                                      }),
                                  onTimerStop: toggleTimer)
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                      TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(trimColor)),
                                          onPressed: () => setState(() {
                                                stickings.shuffle();
                                              }),
                                          child: const Text('shuffle',
                                              style: defaultText)),
                                      TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(trimColor)),
                                          onPressed: regenerate,
                                          child: const Text('regen',
                                              style: defaultText)),
                                      TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(trimColor)),
                                          onPressed: toggleTimer,
                                          child: const Text('timer',
                                              style: defaultText))
                                    ]),
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Column(children: [
                            const SizedBox(height: 16.0),
                            // ...stickings.asMap().entries.map((stickingEntry) {
                            ...stickings.map((stickingEntry) {
                              var sticking = stickingEntry.value;
                              var index = BigInt.from(stickingEntry.key);
                              return
                                  // Container(
                                  //     padding: elementPadding,
                                  TextButton(
                                      onPressed: () =>
                                          setState(() => stickingIndex = index),
                                      child: Text(sticking,
                                          maxLines: 1,
                                          textScaleFactor: textSize,
                                          style: stickingIndex == index
                                              ? const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: defaultTextSize)
                                              : defaultText));
                            })
                          ])))
                        ]))),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("stickings"),
            backgroundColor: trimColor,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    editSettings();
                  },
                ),
              )
            ]),
        body: DefaultTextStyle(
            style: defaultText,
            child: Container(
                padding: elementPadding,
                color: backgroundColor,
                child: mainComponent)));
  }
}
