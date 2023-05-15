import "package:expandable/expandable.dart";
import "package:flutter/material.dart";
import "package:rhythm_practice_helper/styles.dart";
import "limb_settings.dart";

class RhythmicConstraint {
  RhythmicConstraint({
    required int rhythmLength,
  }) {
    rhythm = List<bool>.generate(rhythmLength, (i) => false);
  }

  Limbs limbs = Limbs();
  late List<bool> rhythm;
  bool active = false;

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
  final Function(RhythmicConstraint) onChanged;
  final RhythmicConstraint constraint;

  const RhythmicConstraintWidget(
      {super.key, required this.constraint, required this.onChanged});

  @override
  RhythmicConstraintWidgetState createState() =>
      RhythmicConstraintWidgetState();
}

class RhythmicConstraintWidgetState extends State<RhythmicConstraintWidget> {
  late RhythmicConstraint constraint = widget.constraint;

  bool expanded = false;
  late ExpandableController rhythmicConstraintController = ExpandableController(
    initialExpanded: expanded,
  );

  @override
  void initState() {
    super.initState();
    rhythmicConstraintController.addListener(() {
      expanded = !expanded;
    });
  }

  @override
  void setState(Function fn) {
    fn();
    widget.onChanged(constraint);
  }

  List<TextButton> getStickButtons() {
    List<TextButton> result = [];
    for (Stick stick in constraint.limbs.availableSticks) {
      result.add(TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  stick.inUse ? trimColor : darkGrey)),
          onPressed: () => setState(() {
                stick.inUse = !(stick.inUse);
              }),
          child: Text(
            stick.symbol,
            style: defaultText,
          )));
    }
    return result;
  }

  List<IconButton> getRhythmButtons() {
    List<IconButton> result = [];
    for (int i = 0; i < constraint.rhythm.length; i++) {
      result.add(IconButton(
          icon: Icon(Icons.circle,
              color: constraint.rhythm[i] ? trimColor : Colors.grey),
          onPressed: () =>
              setState(() => {constraint.rhythm[i] = !constraint.rhythm[i]})));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return getExpandable(
        Row(children: [
          const Text("rhythmic constraint"),
          Switch(
              activeColor: trimColor,
              inactiveTrackColor: darkGrey,
              value: constraint.active,
              onChanged: (val) => setState(() {
                    constraint.active = val;
                  }))
        ]),
        Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getRhythmButtons()),
          LimbsSettingsWidget(
            limbs: constraint.limbs,
            onLimbsChanged: (l) => setState(() {
              constraint.limbs = l;
            }),
          ),
        ]),
        controller: rhythmicConstraintController);
  }
}
