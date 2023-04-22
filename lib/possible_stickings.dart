import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'styles.dart';

class PossibleStickings extends StatefulWidget {
  const PossibleStickings({super.key});

  @override
  _PossibleStickingsState createState() => _PossibleStickingsState();
}

class _PossibleStickingsState extends State<PossibleStickings> {
  // TODO: options per stick
  // class Stick {
  //   Char symbol;
  //   int maxBounces;
  //   int minBounces;
  // }
  int maxBounces = 2;
  int minBounces = 1;

  List<String> sticks = ['R', 'L'];

  int stickingLength = 6;

  List<String> generateStickings([String partialSticking = '']) {
    List<String> possibleStickings = [];

    if (partialSticking.length == stickingLength) {
      return [partialSticking];
    }
    if (partialSticking.length > stickingLength) {
      return [];
    }

    List<String> potentialSticks = partialSticking.isEmpty
        ? sticks
        : sticks
            .where((stick) =>
                stick[0] != partialSticking[partialSticking.length - 1])
            .toList();
    for (String stick in potentialSticks) {
      for (int bounces = minBounces; bounces <= maxBounces; bounces++) {
        String sticking = partialSticking + stick * bounces;
        possibleStickings += generateStickings(sticking);
      }
    }

    return possibleStickings;
  }

  void minimumBouncesChanged(int val) {
    setState(() => minBounces = val <= maxBounces ? val : minBounces);
  }

  void maximumBouncesChanged(int val) {
    setState(() => maxBounces = val >= minBounces ? val : maxBounces);
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
                      onChanged: (val) => setState(() => stickingLength = val)),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("min: "),
                  NumberStepper(
                      initialValue: minBounces,
                      min: 1,
                      max: 4,
                      step: 1,
                      onChanged: minimumBouncesChanged),
                  const Text("max: "),
                  NumberStepper(
                      initialValue: maxBounces,
                      min: 1,
                      max: 4,
                      step: 1,
                      onChanged: maximumBouncesChanged)
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
            ),
          ),
        ));
  }
}
