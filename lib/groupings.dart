import 'package:flutter/material.dart';
import 'styles.dart';

class Groupings extends StatefulWidget {
  const Groupings({super.key});

  @override
  _GroupingsState createState() => _GroupingsState();
}

class _GroupingsState extends State<Groupings> {
  List<String> parts = ['x..x', 'x.xx.'];
  int divisionsPerBeat = 4;
  int beatsPerBar = 4;

  void moreParts() {
    setState(() {
      parts.add('');
    });
  }

  void lessParts() {
    setState(() {
      parts.removeLast();
    });
  }

  void setPart(int i, String part) {
    setState(() {
      parts[i] = part;
    });
  }

  int phraseLength() {
    var lengths = <int>[];
    var lcm = 1;
    for (var part in parts) {
      if (!lengths.contains(part.length)) {
        if (part != '') {
          lengths.add(part.length);
          lcm *= part.length;
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
    return parts.map((part) {
      var repetitions = part == '' ? 1 : length ~/ part.length;
      var tab = '';
      while (repetitions > 0) {
        tab = tab + part;
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("groupings tabber"),
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
                    "enter phasing rhythms that are frustrating to play that you need to visualize"),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => parts.add("")),
                      style: buttonStyle,
                      child: const Text("more parts"),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () => setState(() => parts.removeLast()),
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
                        for (var i = 0; i < parts.length; i++)
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Part ${i + 1}",
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white70),
                            onChanged: (value) => setPart(i, value),
                            controller: TextEditingController(
                              text: parts[i],
                            ),
                          ),
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
            ),
          ),
        ));
  }
}
