import "package:flutter/material.dart";
import "package:rhythm_practice_helper/styles.dart";
import "limb_settings.dart";
import "stickings.dart";

class RhythmicConstraint {
  RhythmicConstraint({
    required this.rhythm,
  });

  Limbs limbs = Limbs();
  List<bool> rhythm;

  set rhythmLength(rhythmLength) {
    rhythm = List<bool>.generate(
        rhythmLength, (i) => i < rhythm.length ? rhythm[i] : false);
  }

  int subdivisionsUntilNextHit(int currentSubdivision) {
    if (currentSubdivision >= rhythm.length) {
      return -1;
    }
    for (int i = 0; i < rhythm.length; i++) {
      if (rhythm[i] && i > currentSubdivision) {
        return i - currentSubdivision;
      }
    }
    return rhythm.length - currentSubdivision;
  }
}

class RhythmicConstraintWidget extends StatefulWidget {
  final RhythmicConstraint constraint;
  final Function(Stick, bool) onSticksChanged;
  final Function(int, bool) onRhythmChanged;
  final bool activated;
  final Function(bool) onActivation;

  const RhythmicConstraintWidget(
      {super.key,
      required this.activated,
      required this.onActivation,
      required this.constraint,
      required this.onRhythmChanged,
      required this.onSticksChanged});

  @override
  RhythmicConstraintWidgetState createState() =>
      RhythmicConstraintWidgetState();
}

class RhythmicConstraintWidgetState extends State<RhythmicConstraintWidget> {
  RhythmicConstraintWidgetState();

  List<TextButton> getStickButtons() {
    List<TextButton> result = [];
    for (Stick stick in widget.constraint.limbs.availableSticks) {
      result.add(TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  stick.inUse ? trimColor : darkGrey)),
          onPressed: () => widget.onSticksChanged(stick, !(stick.inUse)),
          child: Text(
            stick.symbol,
            style: defaultText,
          )));
    }
    return result;
  }

  List<IconButton> getRhythmButtons() {
    List<IconButton> result = [];
    for (int i = 0; i < widget.constraint.rhythm.length; i++) {
      result.add(IconButton(
          icon: Icon(Icons.circle,
              color: widget.constraint.rhythm[i] ? trimColor : Colors.grey),
          onPressed: () =>
              widget.onRhythmChanged(i, !widget.constraint.rhythm[i])));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          const Text("rhythmic constraint"),
          Switch(
            activeColor: trimColor,
            inactiveTrackColor: darkGrey,
            value: widget.activated,
            onChanged: widget.onActivation,
          )
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[const Text("assign")] + getStickButtons()),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: getRhythmButtons())
      ],
    );
  }
}
