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
  Map<String, Stick> sticks = {
    for (String s in ['R', 'L']) s: Stick(symbol: s)
  };

  int stickingLength = 6;
  bool avoidNecessaryAlternation = true;
  int maxNumberOfStickings = -1;
  bool generateRandomStickings() {
    return maxNumberOfStickings >= 0;
  }

  bool generateAllStickings() {
    return !generateRandomStickings();
  }

  late RhythmicConstraint rhythmicConstraint;
  bool applyRhythmicConstraint = false;

  List<String> stickOptions = ['R', 'L', 'K', 'H'];
  List<DropdownMenuItem<String>> unusedSticks(String currentValue) {
    List<String> usedSticks = sticks.keys.toList();
    return [
          DropdownMenuItem(
              value: currentValue,
              child: Text(currentValue, style: defaultText))
        ] +
        stickOptions
            .where((s) => !usedSticks.contains(s))
            .map((s) =>
                DropdownMenuItem(value: s, child: Text(s, style: defaultText)))
            .toList();
  }

  Map<String, Stick> getSticks(int numberOfSticks) {
    return {
      for (String s in stickOptions.sublist(0, numberOfSticks))
        s: Stick(symbol: s)
    };
  }

  void minimumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.minBounces = val <= stick.maxBounces ? val : stick.minBounces);
  }

  void maximumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.maxBounces = val >= stick.minBounces ? val : stick.maxBounces);
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
                children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("length:"),
                            NumberStepper(
                                initialValue: stickingLength,
                                min: 2,
                                max: 12,
                                step: 1,
                                onChanged: (val) => {
                                      setState(() => {stickingLength = val})
                                    }),
                            const Text("limbs: "),
                            NumberStepper(
                                initialValue: sticks.length,
                                min: 2,
                                max: stickOptions.length,
                                step: 1,
                                onChanged: (val) =>
                                    setState(() => sticks = getSticks(val))),
                          ]),
                    ] +
                    sticks.values
                        .map((stick) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton(
                                      items: unusedSticks(stick.symbol),
                                      value: stick.symbol,
                                      dropdownColor: backgroundColor,
                                      onChanged: (val) => setState(() {
                                            sticks.remove(stick.symbol);
                                            stick.symbol = val ?? stick.symbol;
                                            sticks.putIfAbsent(
                                                stick.symbol, () => stick);
                                          })),
                                  const Text("min: "),
                                  NumberStepper(
                                      initialValue: stick.minBounces,
                                      min: 1,
                                      max: 4,
                                      step: 1,
                                      onChanged: (val) =>
                                          minimumBouncesChanged(val, stick)),
                                  const Text("max: "),
                                  NumberStepper(
                                      initialValue: stick.maxBounces,
                                      min: 1,
                                      max: 4,
                                      step: 1,
                                      onChanged: (val) =>
                                          maximumBouncesChanged(val, stick))
                                ]))
                        .toList() +
                    [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("avoid alternation:"),
                            Switch(
                                activeColor: trimColor,
                                value: avoidNecessaryAlternation,
                                onChanged: (val) => setState(() {
                                      avoidNecessaryAlternation = val;
                                    })),
                            const Text('shuffle:'),
                            Switch(
                                activeColor: trimColor,
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
