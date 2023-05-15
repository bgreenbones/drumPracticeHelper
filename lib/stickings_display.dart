import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/stickings_settings.dart';
import 'styles.dart';
import 'stickings_generate.dart';

class StickingsDisplay extends StatefulWidget {
  const StickingsDisplay({super.key});

  @override
  StickingsDisplayState createState() => StickingsDisplayState();
}

class StickingsDisplayState extends State<StickingsDisplay> {
  bool editingSettings = false;
  StickingsSettings settings = StickingsSettings();

  void editSettings() {
    setState(() {
      editingSettings = !editingSettings;
    });
  }

  Column get mainComponent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: editingSettings
                  ? StickingsSettingsWidget(
                      settings: settings,
                      onChanged: (newSettings) =>
                          setState(() => settings = newSettings))
                  : Column(
                      children: [
                        ...generateStickings(settings).map((sticking) {
                          return Container(
                            padding: elementPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [Text(sticking)],
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ),
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
