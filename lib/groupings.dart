import 'package:flutter/material.dart';
import 'styles.dart';

class Groupings extends StatefulWidget {
  const Groupings({super.key});

  @override
  _GroupingsState createState() => _GroupingsState();
}

class _GroupingsState extends State<Groupings> {
  final List<TextEditingController> _partControllers = [
    TextEditingController(text: 'x..x'),
    TextEditingController(text: 'x.xx.'),
  ];
  late Function() _partControllerListener;
  int divisionsPerBeat = 4;
  int beatsPerBar = 4;

  @override
  void initState() {
    super.initState();
    _partControllerListener = () {
      setState(() {});
    };
    for (var controller in _partControllers) {
      controller.addListener(_partControllerListener);
    }
  }

  void moreParts() {
    setState(() {
      _partControllers.add(TextEditingController(text: ''));
      _partControllers[_partControllers.length - 1]
          .addListener(_partControllerListener);
    });
  }

  void lessParts() {
    setState(() {
      _partControllers[_partControllers.length - 1].dispose();
      _partControllers.removeLast();
    });
  }

  // void setPart(int i, String part) {
  //   setState(() {
  //     _partControllers[i].text = part;
  //   });
  // }

  int phraseLength() {
    var lengths = <int>[];
    var lcm = 1;
    for (var part in _partControllers) {
      if (!lengths.contains(part.text.length)) {
        if (part.text != '') {
          lengths.add(part.text.length);
          lcm *= part.text.length;
        }
      }
    }
    return lcm;
  }

  String addBarLines(String tab) {
    var numBars = (tab.length / (divisionsPerBeat * beatsPerBar)).floor();
    while (numBars >= 0) {
      var position = numBars * (divisionsPerBeat * beatsPerBar);
      tab = '${tab.substring(0, position)}|${tab.substring(position)}';
      numBars--;
    }
    return tab;
  }

  List<String> getTabs() {
    var length = phraseLength();
    return _partControllers.map((part) {
      var repetitions = part.text == '' ? 1 : length ~/ part.text.length;
      var tab = '';
      while (repetitions > 0) {
        tab = tab + part.text;
        repetitions--;
      }
      return tab;
    }).toList();
  }

  List<Widget> getBeatsAndBarlines(String tab) {
    return tab.split('').asMap().entries.map((entry) {
      var i = entry.key;
      var c = entry.value;
      return i % (divisionsPerBeat * beatsPerBar) == 0
          ? Text(c, style: barMarker)
          : i % divisionsPerBeat == 0
              ? Text(c, style: beatMarker)
              : Text(c);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
            "enter phasing rhythms that are frustrating to play that you need to visualize"),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: moreParts,
              style: buttonStyle,
              child: const Text("more parts"),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: lessParts,
              style: buttonStyle,
              child: const Text("less parts"),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < _partControllers.length; i++)
                  TextField(
                      decoration: InputDecoration(
                          hintText: "Part ${i + 1}",
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white70),
                      controller: _partControllers[i]),
                const SizedBox(height: 16.0),
                const Text("tabs:"),
                const SizedBox(height: 8.0),
                ...getTabs().map((tab) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: getBeatsAndBarlines(tab),
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
