import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'limb_settings.dart';
import 'styles.dart';
import 'rhythmic_constraint.dart';
import 'package:expandable/expandable.dart';
import 'stickings.dart';

class PossibleStickings extends StatefulWidget {
  const PossibleStickings({super.key});

  @override
  PossibleStickingsState createState() => PossibleStickingsState();
}

class PossibleStickingsState extends State<PossibleStickings> {
  bool shuffle = false;
  Limbs limbs = Limbs();

  int stickingLength = 6;
  bool avoidNecessaryAlternation = true;
  int maxNumberOfStickings = -1;
  bool generateRandomStickings() {
    return maxNumberOfStickings >= 0;
  }

  bool generateAllStickings() {
    return !generateRandomStickings();
  }

  late RhythmicConstraint rhythmicConstraint = RhythmicConstraint(
      rhythm: List<bool>.generate(stickingLength, (index) => false));
  bool applyRhythmicConstraint = false;

  List<DropdownMenuItem<String>> unusedSticks(String currentValue) {
    return [
          DropdownMenuItem(
              value: currentValue,
              child: Text(currentValue, style: defaultText))
        ] +
        limbs.unusedSticks
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
          stickingLength = val,
          rhythmicConstraint.rhythmLength = stickingLength
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("sticking constraints")),
            collapsed: Column(),
            expanded: Column(
                children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("length"),
                            NumberStepper(
                                initialValue: stickingLength,
                                min: 2,
                                max: 12,
                                step: 1,
                                onChanged: stickingLengthChanged),
                            const Text("limbs"),
                            NumberStepper(
                                initialValue: limbs.usingSticks.length,
                                min: 2,
                                max: limbs.availableSticks.length,
                                step: 1,
                                onChanged: (val) => setState(() => limbs
                                    .usingSticks = limbs.getSomeSticks(val))),
                          ]),
                    ] +
                    limbs.usingSticks
                        .map((stick) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton(
                                      items: unusedSticks(stick.symbol),
                                      value: stick.symbol,
                                      dropdownColor: backgroundColor,
                                      onChanged: (val) => setState(() {
                                            limbs.usingSticks.remove(stick);
                                            Stick replacement =
                                                limbs.stickMap[val] ?? stick;
                                            replacement.maxBounces =
                                                stick.maxBounces;
                                            replacement.minBounces =
                                                stick.minBounces;
                                            limbs.usingSticks.add(replacement);
                                          })),
                                  // const Text("min"),
                                  // NumberStepper(
                                  //     initialValue: stick.minBounces,
                                  //     min: 1,
                                  //     max: 4,
                                  //     step: 1,
                                  //     onChanged: (val) =>
                                  //         minimumBouncesChanged(val, stick)),
                                  // const Text("max"),
                                  // NumberStepper(
                                  //     initialValue: stick.maxBounces,
                                  //     min: 1,
                                  //     max: 4,
                                  //     step: 1,
                                  //     onChanged: (val) =>
                                  //         maximumBouncesChanged(val, stick))
                                  // Text("${stick.minBounces}"),
                                  RangeSlider(
                                      min: 1,
                                      max: 4,
                                      divisions: 4 - 1,
                                      labels: RangeLabels("${stick.minBounces}",
                                          "${stick.maxBounces}"),
                                      activeColor: trimColor,
                                      values: RangeValues(
                                          stick.minBounces.toDouble(),
                                          stick.maxBounces.toDouble()),
                                      onChanged: (rangeValue) => {
                                            if (rangeValue.start !=
                                                stick.minBounces)
                                              {
                                                minimumBouncesChanged(
                                                    rangeValue.start.toInt(),
                                                    stick)
                                              },
                                            if (rangeValue.end !=
                                                stick.maxBounces)
                                              {
                                                maximumBouncesChanged(
                                                    rangeValue.end.toInt(),
                                                    stick)
                                              }
                                          }),
                                  // Text("${stick.maxBounces}"),
                                ]))
                        .toList() +
                    <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("avoid alternation"),
                            Switch(
                                activeColor: trimColor,
                                inactiveTrackColor: darkGrey,
                                value: avoidNecessaryAlternation,
                                onChanged: (val) => setState(() {
                                      avoidNecessaryAlternation = val;
                                    })),
                            const Text('shuffle'),
                            Switch(
                                activeColor: trimColor,
                                inactiveTrackColor: darkGrey,
                                value: shuffle || generateRandomStickings(),
                                onChanged: (val) => setState(() {
                                      shuffle = val;
                                    }))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("stickings"),
                            NumberStepper(
                                initialValue: maxNumberOfStickings,
                                min: -1,
                                max: 20,
                                step: 1,
                                onChanged: (val) => setState(() {
                                      maxNumberOfStickings = val;
                                    })),
                          ]),
                      RhythmicConstraintWidget(
                          activated: applyRhythmicConstraint,
                          onActivation: (activated) => setState(
                              () => {applyRhythmicConstraint = activated}),
                          constraint: rhythmicConstraint,
                          onSticksChanged: (stick, useOrNot) =>
                              setState(() => {stick.inUse = useOrNot}),
                          onRhythmChanged: (i, hitOrNot) => setState(
                              () => {rhythmicConstraint.rhythm[i] = hitOrNot})),
                    ])),
        const SizedBox(height: 16.0),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...generateStickings(this).map((sticking) {
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
  }
}
