import "package:expandable/expandable.dart";
import "package:flutter/material.dart";
import "package:rhythm_practice_helper/settings_widget.dart";
import "package:rhythm_practice_helper/styles.dart";
import "package:rhythm_practice_helper/utility.dart";
import "package:shared_preferences/shared_preferences.dart";
import "limb_settings.dart";

class RhythmicConstraint implements Settings {
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

  String _boolToString(bool boolean) {
    return boolean ? '1' : '0';
  }

  List<String> _boolListToStringList(List<bool> booleans) {
    return booleans.map((b) => _boolToString(b)).toList();
  }

  bool _stringToBool(String string) {
    return string == '1' ? true : false;
  }

  List<bool>? _stringListToBoolList(List<String>? strings) {
    return strings?.map((s) => _stringToBool(s)).toList();
    // return strings == null ? null : strings.map((s) => _stringToBool(s)).toList();
  }

  @override
  Future<void> save(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    await limbs.save(absKey, prefsFuture);
    await prefsFuture.then((prefs) {
      prefs.setStringList('$absKey/rhythm', _boolListToStringList(rhythm));
      prefs.setBool('$absKey/active', active);
      return prefs;
    });
  }

  @override
  Future<void> load(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    await limbs.load(absKey, prefsFuture);
    await prefsFuture.then((SharedPreferences prefs) {
      int enforcedLength = rhythm.length;
      rhythm = _stringListToBoolList(prefs.getStringList('$absKey/rhythm')) ??
          rhythm;
      rhythmLength = enforcedLength;
      active = prefs.getBool('$absKey/active') ?? active;
    });
  }

  @override
  String key = 'rhythmicConstraint';
}

class RhythmicConstraintWidget extends SettingsWidget<RhythmicConstraint> {
  const RhythmicConstraintWidget({
    super.key,
    required super.settings,
    required super.onChanged,
    super.parentKey,
    // super.settingsKey = 'rhythmicConstraint'
  });

  @override
  RhythmicConstraintWidgetState createState() =>
      RhythmicConstraintWidgetState();
}

class RhythmicConstraintWidgetState
    extends SettingsWidgetState<RhythmicConstraint> {
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
                    settings.active = val;
                  }))
        ]),
        Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getRhythmButtons(c.rhythm)),
          LimbsSettingsWidget(
              settings: c.limbs,
              onChanged: (l) => setState(() {
                    settings.limbs = l;
                  }),
              parentKey: settingsRepository.absoluteKey),
        ]),
        controller: rhythmicConstraintController));
  }
}
