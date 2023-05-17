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
  late StickingsSettings settings = StickingsSettings();
  late List<String> stickings = generateStickings(settings);
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
      stickings = generateStickings(settings);
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
                      stickings.shuffle();
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
          Expanded(
            child: settings.getFutureBuilder((s) => SingleChildScrollView(
                  child: editingSettings
                      ? StickingsSettingsWidget(
                          settings: (s as StickingsSettings),
                          onChanged: (newSettings) =>
                              setState(() => settings = newSettings))
                      : Column(
                          children: [
                            ...stickings.map((sticking) {
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
                )),
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
