import 'package:flutter/material.dart';
import 'styles.dart';

class ReferencePoints extends StatefulWidget {
  const ReferencePoints({super.key});

  @override
  _ReferencePointsState createState() => _ReferencePointsState();
}

class _ReferencePointsState extends State<ReferencePoints> {
  String phraseText = "LLRRLRL";
  int divisionsPerBeat = 4;
  int beatsPerBar = 4;
  int divisionsPerBar() => beatsPerBar * divisionsPerBeat;
  int groupingLength = 3;

  bool newLine(i) {
    return i % divisionsPerBar() == 0;
  }

  TextStyle getDivisionMarker(i) {
    return i % (divisionsPerBeat * beatsPerBar) == 0
        ? barMarker
        : i % divisionsPerBeat == 0
            ? beatMarker
            : i % groupingLength == 0
                ? groupingMarker
                : defaultText;
  }

  List<Widget> getReferencePoints(String phrase) {
    List<Widget> result = [];
    List<Widget> currentRow = [];
    int j = 0;
    do {
      for (int i = 0; i < phrase.length; i++) {
        if (newLine(j)) {
          result.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: currentRow));
          currentRow = [];
        }
        currentRow.add(Text(phrase[i], style: getDivisionMarker(j)));
        j++;
      }
    } while (!newLine(j));
    return result;
    // return phrase.split('').asMap().entries.map((entry) {
    //   var i = entry.key;
    //   var c = entry.value;
    //   return newLine(i)
    //       ? Text("\n$c", style: getDivisionMarker(i))
    //       : Text(c, style: getDivisionMarker(i));
    // }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getReferencePoints(phraseText));
  }
}
