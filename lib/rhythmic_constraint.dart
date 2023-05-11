import "package:flutter/material.dart";
import "package:rhythm_practice_helper/styles.dart";

import "stickings.dart";

class RhythmicConstraint {
  List<Stick> sticks = [];
  List<bool> rhythm = [];
  int subdivisionsUntilNextHit(int currentSubdivision) {
    if (currentSubdivision >= rhythm.length) {
      return -1;
    }
    for (int i = 0; i < rhythm.length; i++) {
      if (rhythm[i] && i >= currentSubdivision) {
        return i - currentSubdivision;
      }
    }
    return rhythm.length - currentSubdivision;
  }
}

class RhythmicConstraintWidget extends StatefulWidget {
  final int rhythmLength;
  const RhythmicConstraintWidget({super.key, required this.rhythmLength});

  @override
  RhythmicConstraintWidgetState createState() =>
      RhythmicConstraintWidgetState();
}

class RhythmicConstraintWidgetState extends State<RhythmicConstraintWidget> {
  RhythmicConstraint constraint = RhythmicConstraint();

  List<IconButton> getRhythmButtons() {
    List<IconButton> result = [];
    for (int i = 0; i < constraint.rhythm.length; i++) {
      result.add(IconButton(
          icon: Icon(Icons.widgets,
              color: constraint.rhythm[i] ? trimColor : Colors.grey),
          onPressed: () => {constraint.rhythm[i] = !constraint.rhythm[i]}));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: getRhythmButtons());
  }
}
