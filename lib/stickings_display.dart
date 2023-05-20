import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
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
  SettingsRepository<StickingsSettings> settingsRepository =
      SettingsRepository<StickingsSettings>(
          settings: StickingsSettings(), parentKey: "");
  // late StickingsSettings settings = StickingsSettings();
  // late Future<StickingsSettings> settingsFuture = StickingsSettings().load();
  // late List<String> stickings = generateStickings(settings);
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
      // stickings = generateStickings(settings);
    });
  }

  Column get mainComponent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(trimColor)),
                onPressed: () => setState(() {
                      // stickings.shuffle();
                    }),
                child: const Text('shuffle', style: defaultText)),
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(trimColor)),
                onPressed: regenerate,
                child: const Text('regen', style: defaultText))
          ]),
          const SizedBox(height: 16.0),
          settingsRepository.getWidget((settings) => Expanded(
                  child: SingleChildScrollView(
                child: editingSettings
                    ? StickingsSettingsWidget(
                        settings: settings,
                        repository: settingsRepository,
                        onChanged: (newSettings) =>
                            setState(() => settings = newSettings))
                    : Column(
                        children: [
                          ...generateStickings(settings).map((sticking) {
                            return Container(
                              padding: elementPadding,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(sticking,
                                      maxLines: 1, textScaleFactor: textSize)
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
