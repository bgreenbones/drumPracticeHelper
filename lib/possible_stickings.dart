import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
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
  List<Stick> availableSticks = [
    for (String s in ['R', 'L', 'K', 'H']) Stick(symbol: s)
  ];
  late List<Stick> usingSticks = availableSticks
      .where((stick) => ['R', 'L'].contains(stick.symbol))
      .toList();
  Map<String, Stick> get stickMap =>
      {for (Stick s in availableSticks) s.symbol: s};

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
      availableSticks: availableSticks,
      rhythm: List<bool>.generate(stickingLength, (index) => false));
  bool applyRhythmicConstraint = false;

  List<DropdownMenuItem<String>> unusedSticks(String currentValue) {
    return [
          DropdownMenuItem(
              value: currentValue,
              child: Text(currentValue, style: defaultText))
        ] +
        availableSticks
            .where((s) => !usingSticks.contains(s))
            .map((s) => DropdownMenuItem(
                value: s.symbol, child: Text(s.symbol, style: defaultText)))
            .toList();
  }

  List<Stick> getSticks(int numberOfSticks) {
    return availableSticks.sublist(0, numberOfSticks);
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
                                initialValue: usingSticks.length,
                                min: 2,
                                max: availableSticks.length,
                                step: 1,
                                onChanged: (val) => setState(
                                    () => usingSticks = getSticks(val))),
                          ]),
                    ] +
                    usingSticks
                        .map((stick) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton(
                                      items: unusedSticks(stick.symbol),
                                      value: stick.symbol,
                                      dropdownColor: backgroundColor,
                                      onChanged: (val) => setState(() {
                                            usingSticks.remove(stick);
                                            Stick replacement =
                                                stickMap[val] ?? stick;
                                            replacement.maxBounces =
                                                stick.maxBounces;
                                            replacement.minBounces =
                                                stick.minBounces;
                                            usingSticks.add(replacement);
                                          })),
                                  const Text("min"),
                                  NumberStepper(
                                      initialValue: stick.minBounces,
                                      min: 1,
                                      max: 4,
                                      step: 1,
                                      onChanged: (val) =>
                                          minimumBouncesChanged(val, stick)),
                                  const Text("max"),
                                  NumberStepper(
                                      initialValue: stick.maxBounces,
                                      min: 1,
                                      max: 4,
                                      step: 1,
                                      onChanged: (val) =>
                                          maximumBouncesChanged(val, stick))
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
                            const Text("stickings:"),
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
                          availableSticks: availableSticks,
                          constraint: rhythmicConstraint,
                          onSticksChanged: (stick, useOrNot) => setState(() =>
                              {rhythmicConstraint.sticks[stick] = useOrNot}),
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
