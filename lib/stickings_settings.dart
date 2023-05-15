import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'limb_settings.dart';
import 'styles.dart';
import 'rhythmic_constraint.dart';

class StickingsSettings {
  bool shuffle = false;
  Limbs limbs = Limbs();

  int stickingLength = 4;
  bool avoidNecessaryAlternation = true;
  int maxNumberOfStickings = -1;
  bool get generateRandomStickings => maxNumberOfStickings >= 0;
  bool get generateAllStickings => !generateRandomStickings;

  late RhythmicConstraint rhythmicConstraint =
      RhythmicConstraint(rhythmLength: stickingLength);
}

class StickingsSettingsWidget extends StatefulWidget {
  final Function(StickingsSettings) onChanged;
  final StickingsSettings settings;

  const StickingsSettingsWidget(
      {super.key, required this.onChanged, required this.settings});

  @override
  StickingsSettingsWidgetState createState() => StickingsSettingsWidgetState();
}

class StickingsSettingsWidgetState extends State<StickingsSettingsWidget> {
  late StickingsSettings settings = widget.settings;

  @override
  void setState(Function fn) {
    fn();
    widget.onChanged(settings);
  }

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
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("stickings"),
        NumberStepper(
            initialValue: settings.maxNumberOfStickings,
            min: -1,
            max: 20,
            step: 1,
            onChanged: (val) => setState(() {
                  settings.maxNumberOfStickings = val;
                })),
        const Text("length"),
        NumberStepper(
            initialValue: settings.stickingLength,
            min: 2,
            max: 12,
            step: 1,
            onChanged: stickingLengthChanged),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("avoid alternation"),
        Switch(
            activeColor: trimColor,
            inactiveTrackColor: darkGrey,
            value: settings.avoidNecessaryAlternation,
            onChanged: (val) => setState(() {
                  settings.avoidNecessaryAlternation = val;
                })),
        const Text('shuffle'),
        Switch(
            activeColor: trimColor,
            inactiveTrackColor: darkGrey,
            value: settings.shuffle || settings.generateRandomStickings,
            onChanged: (val) => setState(() {
                  settings.shuffle = val;
                }))
      ]),
      LimbsSettingsWidget(
        limbs: settings.limbs,
        onLimbsChanged: (l) => setState(() => settings.limbs = l),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
      RhythmicConstraintWidget(
          constraint: settings.rhythmicConstraint,
          onChanged: (constraint) =>
              setState(() => {settings.rhythmicConstraint = constraint})),
    ]);
  }
}
