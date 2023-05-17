import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'limb_settings.dart';
import 'styles.dart';
import 'rhythmic_constraint.dart';

class StickingsSettings extends SettingsObject {
  Limbs limbs = Limbs();

  int stickingLength = 4;
  bool avoidNecessaryAlternation = true;
  bool generateAllStickings = true;
  bool get generateRandomStickings => !generateAllStickings;
  int maxNumberOfStickings = 10;

  late RhythmicConstraint rhythmicConstraint =
      RhythmicConstraint(rhythmLength: stickingLength);
  @override
  void save() async {
    prefsFuture.then((prefs) =>
        prefs.setInt('stickingLength', stickingLength).then((bool success) {}));
  }

  @override
  Future<SettingsObject> load() async {
    await prefsFuture.then((SharedPreferences prefs) {
      return prefs.getInt('stickingLength') ?? 4;
    }).then((int val) {
      stickingLength = val;
    });
    return this;
  }
}

class StickingsSettingsWidget extends SettingsWidget<StickingsSettings> {
  const StickingsSettingsWidget(
      {super.key, required onChanged, required settings})
      : super(onChanged: onChanged, settings: settings);

  @override
  StickingsSettingsWidgetState createState() => StickingsSettingsWidgetState();
}

class StickingsSettingsWidgetState
    extends SettingsWidgetState<StickingsSettings> {
  List<DropdownMenuItem<String>> unusedSticks(String currentValue) {
    return [
          DropdownMenuItem(
              value: currentValue,
              child: Text(currentValue, style: defaultText))
        ] +
        settings.limbs.unusedSticks
            .map((s) => DropdownMenuItem(
                value: s.symbol, child: Text(s.symbol, style: defaultText)))
            .toList();
  }

  void minimumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.minBounces = val <= stick.maxBounces ? val : stick.minBounces);
  }

  void maximumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.maxBounces = val >= stick.minBounces ? val : stick.maxBounces);
  }

  void stickingLengthChanged(val) {
    setState(() => {
          settings.stickingLength = val,
          settings.rhythmicConstraint.rhythmLength = settings.stickingLength
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        // return settings.getFutureBuilder((s) => Padding(
        padding: morePadding,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("generate all possible stickings"),
            Switch(
                activeColor: trimColor,
                inactiveTrackColor: darkGrey,
                value: settings.generateAllStickings,
                // value: (s as StickingsSettings).generateAllStickings,
                onChanged: (val) => setState(() {
                      settings.generateAllStickings = val;
                    })),
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: settings.generateRandomStickings
                  ? [
                      const Text("number of stickings"),
                      NumberStepper(
                          initialValue: settings.maxNumberOfStickings,
                          min: 1,
                          max: 20,
                          step: 1,
                          onChanged: (val) => setState(() {
                                settings.maxNumberOfStickings = val;
                              })),
                    ]
                  : []),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("sticking length"),
            NumberStepper(
                initialValue: settings.stickingLength,
                min: 2,
                max: 12,
                step: 1,
                onChanged: stickingLengthChanged),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("include alternating stickings"),
            Switch(
                activeColor: trimColor,
                inactiveTrackColor: darkGrey,
                value: !settings.avoidNecessaryAlternation,
                onChanged: (val) => setState(() {
                      settings.avoidNecessaryAlternation = !val;
                    })),
          ]),
          LimbsSettingsWidget(
            limbs: settings.limbs,
            onLimbsChanged: (l) => setState(() => settings.limbs = l),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
          RhythmicConstraintWidget(
              settings: settings.rhythmicConstraint,
              onChanged: (constraint) =>
                  setState(() => {settings.rhythmicConstraint = constraint})),
        ]));
  }
}
