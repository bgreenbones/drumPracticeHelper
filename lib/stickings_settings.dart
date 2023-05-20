import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'limb_settings.dart';
import 'styles.dart';
import 'rhythmic_constraint.dart';

class StickingsSettings implements Settings {
  Limbs limbs = Limbs();

  int stickingLength = 4;
  bool avoidNecessaryAlternation = true;
  bool generateAllStickings = true;
  bool get generateRandomStickings => !generateAllStickings;
  int maxNumberOfStickings = 10;

  late RhythmicConstraint rhythmicConstraint =
      RhythmicConstraint(rhythmLength: stickingLength);

  @override
  Future<void> save(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    limbs.save(key, prefsFuture);
    await rhythmicConstraint.save(absKey, prefsFuture);
    await prefsFuture.then((prefs) {
      prefs.setInt('$absKey/stickingLength', stickingLength);
      prefs.setInt('$absKey/maxNumberOfStickings', maxNumberOfStickings);
      prefs.setBool(
          '$absKey/avoidNecessaryAlternation', avoidNecessaryAlternation);
      prefs.setBool('$absKey/generateAllStickings', generateAllStickings);
      return prefs;
    }); //.then((bool success) {});
  }

  @override
  Future<void> load(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    await limbs.load(absKey, prefsFuture);
    await rhythmicConstraint.load(absKey, prefsFuture);
    await prefsFuture.then((SharedPreferences prefs) {
      stickingLength = prefs.getInt('$absKey/stickingLength') ?? stickingLength;
      rhythmicConstraint.rhythmLength = stickingLength;
      avoidNecessaryAlternation =
          prefs.getBool('$absKey/avoidNecessaryAlternation') ??
              avoidNecessaryAlternation;
      generateAllStickings =
          prefs.getBool('$absKey/generateAllStickings') ?? generateAllStickings;
      maxNumberOfStickings =
          prefs.getInt('$absKey/maxNumberOfStickings') ?? maxNumberOfStickings;
    });
  }

  @override
  String key = 'stickings';
}

class StickingsSettingsWidget extends SettingsWidget<StickingsSettings> {
  const StickingsSettingsWidget(
      {super.key,
      required super.onChanged,
      required super.settings,
      super.repository,
      // super.settingsKey = 'stickings',
      super.parentKey});

  @override
  StickingsSettingsWidgetState createState() => StickingsSettingsWidgetState();
}

class StickingsSettingsWidgetState
    extends SettingsWidgetState<StickingsSettings> {
  void stickingLengthChanged(val) {
    setState(() => {
          settings.stickingLength = val,
          settings.rhythmicConstraint.rhythmLength = settings.stickingLength
        });
  }

  @override
  Widget build(BuildContext context) {
    return settingsRepository.getWidget((s) => Padding(
        padding: morePadding,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("generate all possible stickings"),
            Switch(
                activeColor: trimColor,
                inactiveTrackColor: darkGrey,
                value: s.generateAllStickings,
                onChanged: (val) => setState(() {
                      s.generateAllStickings = val;
                    })),
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: s.generateRandomStickings
                  ? [
                      const Text("number of stickings"),
                      NumberStepper(
                          initialValue: s.maxNumberOfStickings,
                          min: 1,
                          max: 20,
                          step: 1,
                          onChanged: (val) => setState(() {
                                s.maxNumberOfStickings = val;
                              })),
                    ]
                  : []),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("sticking length"),
            NumberStepper(
                initialValue: s.stickingLength,
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
                value: !s.avoidNecessaryAlternation,
                onChanged: (val) => setState(() {
                      s.avoidNecessaryAlternation = !val;
                    })),
          ]),
          LimbsSettingsWidget(
              settings: s.limbs,
              onChanged: (l) => setState(() => s.limbs = l),
              parentKey: s.key),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
          RhythmicConstraintWidget(
              settings: s.rhythmicConstraint,
              onChanged: (constraint) =>
                  setState(() => {s.rhythmicConstraint = constraint}),
              parentKey: s.key),
        ])));
  }
}
