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
  StickingsSettingsRepository({required super.settings});

  @override
  void save() async {
    prefsFuture.then((prefs) {
      prefs.setInt('stickingLength', settings.stickingLength);
      prefs.setInt('maxNumberOfStickings', settings.maxNumberOfStickings);
      prefs.setBool(
          'avoidNecessaryAlternation', settings.avoidNecessaryAlternation);
      prefs.setBool('generateAllStickings', settings.generateAllStickings);
      return prefs;
    }); //.then((bool success) {});
  }

  @override
  Future<StickingsSettings> load() async {
    return prefsFuture.then((SharedPreferences prefs) {
      // settings.limbs = ;
      settings.stickingLength = prefs.getInt('stickingLength') ?? 4;
      settings.avoidNecessaryAlternation =
          prefs.getBool('avoidNecessaryAlternation') ?? true;
      settings.generateAllStickings =
          prefs.getBool('generateAllStickings') ?? true;
      settings.maxNumberOfStickings =
          prefs.getInt('maxNumberOfStickings') ?? 10;
      // settings.rhythmicConstraint =
      //     RhythmicConstraint(rhythmLength: stickingLength);
      return settings;
    });
  }
}

class StickingsSettingsWidget extends SettingsWidget<StickingsSettings> {
  const StickingsSettingsWidget(
      {super.key, required onChanged, required settings})
      : super(onChanged: onChanged, settings: settings);

  @override
  StickingsSettingsWidgetState createState() => StickingsSettingsWidgetState();
}

class StickingsSettingsWidgetState extends SettingsWidgetState<
    StickingsSettings, StickingsSettingsRepository> {
  @override
  void initState() {
    super.initState();
    settingsRepository = StickingsSettingsRepository(settings: widget.settings);
  }

  // List<DropdownMenuItem<String>> unusedSticks(String currentValue) {
  //   return [
  //         DropdownMenuItem(
  //             value: currentValue,
  //             child: Text(currentValue, style: defaultText))
  //       ] +
  //       settings.limbs.unusedSticks
  //           .map((s) => DropdownMenuItem(
  //               value: s.symbol, child: Text(s.symbol, style: defaultText)))
  //           .toList();
  // }

  // void minimumBouncesChanged(int val, Stick stick) {
  //   setState(() =>
  //       stick.minBounces = val <= stick.maxBounces ? val : stick.minBounces);
  // }

  //  void maximumBouncesChanged(int val, Stick stick) {
  //   setState(() =>
  //       stick.maxBounces = val >= stick.minBounces ? val : stick.maxBounces);
  // }

  void stickingLengthChanged(val) {
    setState(() => {
          settings.stickingLength = val,
          settings.rhythmicConstraint.rhythmLength = settings.stickingLength
        });
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    return settingsRepository.getWidget(
        // return getFutureBuilder(
        //     settingsRepository.load(),
        (s) => Padding(
            padding: morePadding,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("generate all possible stickings"),
                Switch(
                    activeColor: trimColor,
                    inactiveTrackColor: darkGrey,
                    value: s.generateAllStickings,
                    // value: (s as StickingsSettings).generateAllStickings,
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
                limbs: s.limbs,
                onLimbsChanged: (l) => setState(() => s.limbs = l),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
              RhythmicConstraintWidget(
                  settings: s.rhythmicConstraint,
                  onChanged: (constraint) =>
                      setState(() => {s.rhythmicConstraint = constraint})),
            ])));
  }
}
