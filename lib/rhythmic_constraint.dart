import "package:flutter/material.dart";

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

  @override
  Widget build(BuildContext context) {
    return Row();
    // to do: display clickable square for each subdivision in rhythm length
  }
}
