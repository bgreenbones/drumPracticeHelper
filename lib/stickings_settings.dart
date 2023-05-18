import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'limb_settings.dart';
import 'styles.dart';
import 'rhythmic_constraint.dart';

class StickingsSettings {
  Limbs limbs = Limbs();

  int stickingLength = 4;
  bool avoidNecessaryAlternation = true;
  bool generateAllStickings = true;
  bool get generateRandomStickings => !generateAllStickings;
  int maxNumberOfStickings = 10;

  late RhythmicConstraint rhythmicConstraint =
      RhythmicConstraint(rhythmLength: stickingLength);
}

class StickingsSettingsRepository extends SettingsObject<StickingsSettings> {
  StickingsSettingsRepository(
      {required super.settings, required super.key, required super.parentKey});

  @override
  void save() async {
    prefsFuture.then((prefs) {
      prefs.setInt('$key/stickingLength', settings.stickingLength);
      prefs.setInt('$key/maxNumberOfStickings', settings.maxNumberOfStickings);
      prefs.setBool(
          '$key/avoidNecessaryAlternation', settings.avoidNecessaryAlternation);
      prefs.setBool('$key/generateAllStickings', settings.generateAllStickings);
      return prefs;
    }); //.then((bool success) {});
  }

  @override
  Future<StickingsSettings> load() async {
    return prefsFuture.then((SharedPreferences prefs) {
      // settings.limbs = ;
      settings.stickingLength =
          prefs.getInt('$key/stickingLength') ?? settings.stickingLength;
      settings.avoidNecessaryAlternation =
          prefs.getBool('$key/avoidNecessaryAlternation') ??
              settings.avoidNecessaryAlternation;
      settings.generateAllStickings =
          prefs.getBool('$key/generateAllStickings') ??
              settings.generateAllStickings;
      settings.maxNumberOfStickings =
          prefs.getInt('$key/maxNumberOfStickings') ??
              settings.maxNumberOfStickings;
      // settings.rhythmicConstraint =
      //     RhythmicConstraint(rhythmLength: stickingLength);
      return settings;
    });
  }
}

class StickingsSettingsWidget extends SettingsWidget<StickingsSettings> {
  const StickingsSettingsWidget(
      {super.key,
      required super.onChanged,
      required super.settings,
      super.settingsKey = 'stickings',
      super.parentKey});

  @override
  StickingsSettingsWidgetState createState() => StickingsSettingsWidgetState();
}

class StickingsSettingsWidgetState extends SettingsWidgetState<
    StickingsSettings, StickingsSettingsRepository> {
  @override
  void initState() {
    super.initState();
    settingsRepository = StickingsSettingsRepository(
        settings: widget.settings,
        key: widget.settingsKey,
        parentKey: widget.parentKey);
  }

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
              parentKey: widget.settingsKey),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
          RhythmicConstraintWidget(
              settings: s.rhythmicConstraint,
              onChanged: (constraint) =>
                  setState(() => {s.rhythmicConstraint = constraint}),
              parentKey: settingsRepository.key),
        ])));
  }
}
