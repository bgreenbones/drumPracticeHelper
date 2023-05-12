import "package:flutter/material.dart";
import "package:rhythm_practice_helper/styles.dart";
import "stickings.dart";

class RhythmicConstraint {
  RhythmicConstraint({required this.sticks, required rhythmLength}) {
    rhythm = List<bool>.generate(rhythmLength, (i) => false);
  }
  List<Stick> sticks;
  late List<bool> rhythm;

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
  final RhythmicConstraint constraint;
  const RhythmicConstraintWidget({super.key, required this.constraint});

  @override
  RhythmicConstraintWidgetState createState() =>
      RhythmicConstraintWidgetState();
}

class RhythmicConstraintWidgetState extends State<RhythmicConstraintWidget> {
  RhythmicConstraintWidgetState();

  List<IconButton> getRhythmButtons() {
    List<IconButton> result = [];
    for (int i = 0; i < widget.constraint.rhythm.length; i++) {
      result.add(IconButton(
          icon: Icon(Icons.widgets,
              color: widget.constraint.rhythm[i] ? trimColor : Colors.grey),
          onPressed: () => setState(() =>
              {widget.constraint.rhythm[i] = !widget.constraint.rhythm[i]})));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: getRhythmButtons());
  }
}
