import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'styles.dart';

class PossibleStickings extends StatefulWidget {
  const PossibleStickings({super.key});

  @override
  _PossibleStickingsState createState() => _PossibleStickingsState();
}

class Stick {
  Stick({required this.symbol, this.maxBounces = 2, this.minBounces = 1});
  String symbol;
  int maxBounces;
  int minBounces;
}

class _PossibleStickingsState extends State<PossibleStickings> {
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

  Map<String, Stick> sticks = {
    for (String s in ['R', 'L']) s: Stick(symbol: s)
  };

  int stickingLength = 6;
  bool avoidNecessaryAlternation = true;

  List<String> generateStickings([String partialSticking = '']) {
    List<String> possibleStickings = [];

    if (partialSticking.length == stickingLength) {
      if (avoidNecessaryAlternation &&
          partialSticking[0] == partialSticking[partialSticking.length - 1]) {
        int beginningBounceLength = 1;
        int endingBounceLength = 1;

        while (beginningBounceLength < partialSticking.length &&
            partialSticking[beginningBounceLength] == partialSticking[0]) {
          beginningBounceLength++;
        }
        while (endingBounceLength < partialSticking.length &&
            partialSticking[partialSticking.length - 1 - endingBounceLength] ==
                partialSticking[partialSticking.length - 1]) {
          endingBounceLength++;
        }

        if (beginningBounceLength + endingBounceLength >
            sticks[partialSticking[0]]!.maxBounces) {
          return [];
        }
      }
      return [partialSticking];
    }
    if (partialSticking.length > stickingLength) {
      return [];
    }

    List<Stick> potentialSticks = partialSticking.isEmpty
        ? sticks.values.toList()
        : sticks.values
            .toList()
            .where((stick) =>
                stick.symbol != partialSticking[partialSticking.length - 1])
            .toList();
    for (Stick stick in potentialSticks) {
      for (int bounces = stick.minBounces;
          bounces <= stick.maxBounces;
          bounces++) {
        String sticking = partialSticking + stick.symbol * bounces;
        possibleStickings += generateStickings(sticking);
      }
    }

    return possibleStickings;
  }

  void minimumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.minBounces = val <= stick.maxBounces ? val : stick.minBounces);
  }

  void maximumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.maxBounces = val >= stick.minBounces ? val : stick.maxBounces);
  }

  // @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("stickings"),
          backgroundColor: trimColor,
        ),
        body: DefaultTextStyle(
          style: defaultText,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    const Text(
                        "visualize all possible stickings, with some constraints"),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("sticking length:"),
                      NumberStepper(
                          initialValue: stickingLength,
                          min: 2,
                          max: 12,
                          step: 1,
                          onChanged: (val) => {
                                setState(() => {stickingLength = val})
                              })
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("number of limbs: "),
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
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("avoid necessary alternation:"),
                      Switch(
                          activeColor: trimColor,
                          value: avoidNecessaryAlternation,
                          onChanged: (val) => setState(() {
                                avoidNecessaryAlternation = val;
                              }))
                    ]),
                    const SizedBox(height: 16.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () => setState(() => parts.add("")),
                    //       style: buttonStyle,
                    //       child: const Text("more parts"),
                    //     ),
                    //     const SizedBox(width: 16.0),
                    //     ElevatedButton(
                    //       onPressed: () => setState(() => parts.removeLast()),
                    //       style: buttonStyle,
                    //       child: const Text("less parts"),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // for (var i = 0; i < parts.length; i++)
                            //   TextField(
                            //     decoration: InputDecoration(
                            //         hintText: "Part ${i + 1}",
                            //         border: const OutlineInputBorder(),
                            //         filled: true,
                            //         fillColor: Colors.white70),
                            //     onChanged: (value) => setPart(i, value),
                            //     controller: TextEditingController(
                            //       text: parts[i],
                            //     ),
                            //   ),
                            // const SizedBox(height: 16.0),
                            const Text("stickings:"),
                            const SizedBox(height: 8.0),
                            ...generateStickings().map((sticking) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [Text(sticking)],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
            ),
          ),
        ));
  }
}
