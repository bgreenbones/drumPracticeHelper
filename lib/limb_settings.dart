import 'package:expandable/expandable.dart';
import "package:rhythm_practice_helper/utility.dart";
import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:rhythm_practice_helper/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stick implements Settings {
  Stick(
      {required this.symbol,
      this.maxBounces = 2,
      this.minBounces = 1,
      this.inUse = true});
  String symbol;
  int maxBounces;
  int minBounces;
  bool inUse;

  @override
  bool operator ==(Object b) {
    return b is Stick && symbol == b.symbol;
  }

  @override
  int get hashCode => symbol.hashCode;

  @override
  Future<void> save(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    await prefsFuture.then((prefs) {
      prefs.setString('$absKey/symbol', symbol);
      prefs.setBool('$absKey/inUse', inUse);
      prefs.setInt('$absKey/maxBounces', maxBounces);
      prefs.setInt('$absKey/minBounces', minBounces);
      return prefs;
    });
  }

//
  @override
  Future<void> load(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    await prefsFuture.then((SharedPreferences prefs) {
      symbol = prefs.getString('$absKey/symbol') ?? symbol;
      inUse = prefs.getBool('$absKey/inUse') ?? inUse;
      maxBounces = prefs.getInt('$absKey/maxBounces') ?? maxBounces;
      minBounces = prefs.getInt('$absKey/minBounces') ?? minBounces;
    });
  }

  @override
  late String key = symbol;
}

class StickSettingsWidget extends SettingsWidget<Stick> {
  const StickSettingsWidget({
    super.key,
    required super.settings,
    required super.onChanged,
    required super.expanded,
    super.parentKey,
    // super.settingsKey
  });
  @override
  StickSettingsWidgetState createState() => StickSettingsWidgetState();
}

class StickSettingsWidgetState extends SettingsWidgetState<Stick> {
  late bool expanded = widget.expanded ?? false;

  void onSticksChanged(bool useOrNot, Stick stick) {
    setState(() => {stick.inUse = useOrNot});
  }

  void minimumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.minBounces = val <= stick.maxBounces ? val : stick.minBounces);
  }

  void maximumBouncesChanged(int val, Stick stick) {
    setState(() =>
        stick.maxBounces = val >= stick.minBounces ? val : stick.maxBounces);
  }

  Widget getStickButton(Stick stick) => TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              stick.inUse ? trimColor : darkGrey)),
      onPressed: () => onSticksChanged(!(stick.inUse), stick),
      child: Text(
        stick.symbol,
        style: defaultText,
      ));
  @override
  Widget build(BuildContext context) {
    return settingsRepository.getWidget((stick) => expanded
        ? Row(
            children: [
              getStickButton(stick),
              RangeSlider(
                  min: 1,
                  max: 4,
                  divisions: 4 - 1,
                  labels:
                      RangeLabels("${stick.minBounces}", "${stick.maxBounces}"),
                  activeColor: trimColor,
                  values: RangeValues(
                      stick.minBounces.toDouble(), stick.maxBounces.toDouble()),
                  onChanged: (rangeValue) => {
                        if (rangeValue.start != stick.minBounces)
                          {
                            minimumBouncesChanged(
                                rangeValue.start.toInt(), stick)
                          },
                        if (rangeValue.end != stick.maxBounces)
                          {maximumBouncesChanged(rangeValue.end.toInt(), stick)}
                      })
            ],
          )
        : getStickButton(stick));
  }
}

class Limbs implements Settings {
  Stick right = Stick(symbol: 'R', maxBounces: 3, minBounces: 1, inUse: true);
  Stick left = Stick(symbol: 'L', maxBounces: 2, minBounces: 1, inUse: true);
  Stick kick = Stick(symbol: 'K', maxBounces: 2, minBounces: 1, inUse: false);
  Stick hat = Stick(symbol: 'H', maxBounces: 1, minBounces: 1, inUse: false);

  List<Stick> get availableSticks => [right, left, kick, hat];
  List<Stick> get usingSticks =>
      availableSticks.where((element) => element.inUse).toList();
  List<Stick> get unusedSticks =>
      availableSticks.where((element) => !element.inUse).toList();

  Map<String, Stick> get stickMap =>
      {for (Stick s in availableSticks) s.symbol: s};

  List<Stick> getSomeSticks(int numberOfSticks) {
    return availableSticks.sublist(0, numberOfSticks);
  }

  @override
  Future<void> save(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    for (Stick stick in availableSticks) {
      await stick.save(absKey, prefsFuture);
    }
  }

  @override
  Future<void> load(
      String parentKey, Future<SharedPreferences> prefsFuture) async {
    String absKey = Settings.absoluteKey(parentKey, key);
    for (Stick stick in availableSticks) {
      await stick.load(absKey, prefsFuture);
    }
  }

  @override
  String key = 'limbs';
}

class LimbsSettingsWidget extends SettingsWidget<Limbs> {
  const LimbsSettingsWidget({
    super.key,
    required super.settings,
    required super.onChanged,
    super.repository,
    super.parentKey,
    // super.settingsKey = 'limbs'
  });
  @override
  LimbsSettingsWidgetState createState() => LimbsSettingsWidgetState();
}

class LimbsSettingsWidgetState extends SettingsWidgetState<Limbs> {
  bool expanded = false;
  late ExpandableController limbsSettingsController = ExpandableController(
    initialExpanded: expanded,
  );
  @override
  void initState() {
    super.initState();
    limbsSettingsController.addListener(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return settingsRepository.getWidget((limbs) => getExpandable(
        const Text("limbs settings"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              for (Stick stick in limbs.availableSticks)
                StickSettingsWidget(
                    onChanged: (newStick) {
                      setState(() {
                        stick = newStick;
                      });
                    },
                    settings: stick,
                    expanded: true,
                    parentKey: limbs.key)
            ])
          ],
        ),
        collapsed:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (Stick stick in limbs.availableSticks)
            StickSettingsWidget(
                onChanged: (newStick) {
                  setState(() {
                    stick = newStick;
                  });
                },
                settings: stick,
                expanded: false,
                parentKey: limbs.key)
        ]),
        controller: limbsSettingsController));
  }
}
