import "package:expandable/expandable.dart";
import "package:flutter/material.dart";
import "package:rhythm_practice_helper/settings_widget.dart";
import "package:rhythm_practice_helper/styles.dart";
import "package:rhythm_practice_helper/utility.dart";
import "package:shared_preferences/shared_preferences.dart";
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

class RhythmicConstraintRepository extends SettingsObject<RhythmicConstraint> {
  RhythmicConstraintRepository({required super.settings});
  String _boolToString(bool boolean) {
    return boolean ? '1' : '0';
  }

  List<String> _boolListToStringList(List<bool> booleans) {
    return booleans.map((b) => _boolToString(b)).toList();
  }

  bool _stringToBool(String string) {
    return string == '1' ? true : false;
  }

  List<bool> _stringListToBoolList(List<String> strings) {
    return strings.map((s) => _stringToBool(s)).toList();
  }

  @override
  void save() async {
    prefsFuture.then((prefs) {
      prefs.setStringList('rhythm', _boolListToStringList(settings.rhythm));
      prefs.setBool('active', settings.active);
      return prefs;
    });
  }

  @override
  Future<RhythmicConstraint> load() async {
    return prefsFuture.then((SharedPreferences prefs) {
      // settings.limbs = ;
      settings.rhythm =
          _stringListToBoolList(prefs.getStringList('rhythm') ?? []);
      settings.active = prefs.getBool('active') ?? false;
      return settings;
    });
  }
}

class RhythmicConstraintWidget extends SettingsWidget<RhythmicConstraint> {
  const RhythmicConstraintWidget(
      {super.key, required settings, required onChanged})
      : super(onChanged: onChanged, settings: settings);

  @override
  RhythmicConstraintWidgetState createState() =>
      RhythmicConstraintWidgetState();
}

class RhythmicConstraintWidgetState extends SettingsWidgetState<
    RhythmicConstraint, RhythmicConstraintRepository> {
  // late RhythmicConstraint constraint = widget.settings;

  bool expanded = false;
  late ExpandableController rhythmicConstraintController = ExpandableController(
    initialExpanded: expanded,
  );

  @override
  void initState() {
    super.initState();
    settingsRepository =
        RhythmicConstraintRepository(settings: widget.settings);
    rhythmicConstraintController.addListener(() {
      expanded = !expanded;
    });
  }

  // List<TextButton> getStickButtons() {
  //   List<TextButton> result = [];
  //   for (Stick stick in constraint.limbs.availableSticks) {
  //     result.add(TextButton(
  //         style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(
  //                 stick.inUse ? trimColor : darkGrey)),
  //         onPressed: () => setState(() {
  //               stick.inUse = !(stick.inUse);
  //             }),
  //         child: Text(
  //           stick.symbol,
  //           style: defaultText,
  //         )));
  //   }
  //   return result;
  // }

  List<IconButton> getRhythmButtons(List<bool> rhythm) {
    List<IconButton> result = [];
    for (int i = 0; i < rhythm.length; i++) {
      result.add(IconButton(
          icon: Icon(Icons.circle, color: rhythm[i] ? trimColor : Colors.grey),
          onPressed: () => setState(() => {rhythm[i] = !rhythm[i]})));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return settingsRepository.getWidget((c) => getExpandable(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("rhythmic constraint"),
          Switch(
              activeColor: trimColor,
              inactiveTrackColor: darkGrey,
              value: c.active,
              onChanged: (val) => setState(() {
                    c.active = val;
                  }))
        ]),
        Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getRhythmButtons(c.rhythm)),
          LimbsSettingsWidget(
            limbs: c.limbs,
            onLimbsChanged: (l) => setState(() {
              c.limbs = l;
            }),
          ),
        ]),
        controller: rhythmicConstraintController));
  }
}
