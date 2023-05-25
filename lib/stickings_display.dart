import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:rhythm_practice_helper/stickings_settings.dart';
import 'package:rhythm_practice_helper/timer_widget.dart';
import 'styles.dart';
import 'stickings_generate.dart';

class StickingsDisplay extends StatefulWidget {
  const StickingsDisplay({super.key});

  @override
  StickingsDisplayState createState() => StickingsDisplayState();
}

class StickingsDisplayState extends State<StickingsDisplay> {
  int stickingIndex = 0;
  bool editingSettings = false;

  bool showTimer = false;

  SettingsRepository<StickingsSettings> settingsRepository =
      SettingsRepository<StickingsSettings>(
          settings: StickingsSettings(), parentKey: "");
  late List<String> stickings = generateStickings(settingsRepository.settings);
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
      stickings = generateStickings(settingsRepository.settings);
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
                  child: SingleChildScrollView(
                child: editingSettings
                    ? StickingsSettingsWidget(
                        settings: settings,
                        repository: settingsRepository,
                        onChanged: (newSettings) => setState(
                            () => settingsRepository.settings = newSettings))
                    : Column(
                        children: [
                          showTimer
                              ? TimerWidget(
                                  onTimerReset: () => setState(() {
                                        stickingIndex = (stickingIndex + 1) %
                                            stickings.length;
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
                          const SizedBox(height: 16.0),
                          ...stickings.map((sticking) {
                            return Container(
                              padding: elementPadding,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(sticking,
                                      maxLines: 1,
                                      textScaleFactor: textSize,
                                      style:
                                          stickings[stickingIndex] == sticking
                                              ? const TextStyle(
                                                  color: Colors.orange)
                                              : null)
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
              ))),
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
