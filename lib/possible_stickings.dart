import 'dart:math';

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
  final String symbol;
  int maxBounces;
  int minBounces;
}

class _PossibleStickingsState extends State<PossibleStickings> {
  // TODO: options per stick
  // int maxBounces = 2;
  // int minBounces = 1;
  // List<String> sticks = ['R', 'L'];
  // List<String> stickSymbols = ;
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
            color: Colors.black87,
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
                          onChanged: (val) =>
                              setState(() => stickingLength = val)),
                    ])
                  ] +
                  sticks.values
                      .map((stick) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${stick.symbol}: "),
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
