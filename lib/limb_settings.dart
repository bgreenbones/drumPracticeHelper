import 'package:expandable/expandable.dart';
import "package:rhythm_practice_helper/utility.dart";
import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:rhythm_practice_helper/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stick {
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
}

class StickRepository extends SettingsObject<Stick> {
  StickRepository({required super.settings});

  @override
  void save() {
    prefsFuture.then((prefs) {
      prefs.setString('symbol', settings.symbol);
      prefs.setBool('inUse', settings.inUse);
      prefs.setInt('maxBounces', settings.maxBounces);
      prefs.setInt('minBounces', settings.minBounces);
      return prefs;
    });
  }

  @override
  Future<Stick> load() async {
    return prefsFuture.then((SharedPreferences prefs) {
      settings.symbol = prefs.getString('symbol') ?? 'R';
      settings.inUse = prefs.getBool('inUse') ?? true;
      settings.maxBounces = prefs.getInt('maxBounces') ?? 2;
      settings.minBounces = prefs.getInt('minBounces') ?? 1;
      return settings;
    });
  }
}

class StickSettingsWidget extends SettingsWidget<Stick> {
  const StickSettingsWidget(
      {super.key, required stick, required onStickChanged, required expanded})
      : super(onChanged: onStickChanged, settings: stick, expanded: expanded);

  @override
  StickSettingsWidgetState createState() => StickSettingsWidgetState();
}

class StickSettingsWidgetState
    extends SettingsWidgetState<Stick, StickRepository> {
  // late Stick stick = widget.settings;
  late bool expanded = widget.expanded ?? false;
  @override
  void initState() {
    super.initState();
    settingsRepository = StickRepository(settings: widget.settings);
  }

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

class Limbs {
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
}

class LimbsRepository extends SettingsObject<Limbs> {
  LimbsRepository({required super.settings});

  @override
  void save() {}
  @override
  Future<Limbs> load() async {
    return settings;
  }
}

class LimbsSettingsWidget extends SettingsWidget<Limbs> {
  const LimbsSettingsWidget({
    super.key,
    required limbs,
    required onLimbsChanged,
  }) : super(onChanged: onLimbsChanged, settings: limbs);

  @override
  LimbsSettingsWidgetState createState() => LimbsSettingsWidgetState();
}

class LimbsSettingsWidgetState
    extends SettingsWidgetState<Limbs, LimbsRepository> {
  // late Limbs limbs = widget.settings;

  bool expanded = false;
  late ExpandableController limbsSettingsController = ExpandableController(
    initialExpanded: expanded,
  );

  @override
  void initState() {
    super.initState();
    settingsRepository = LimbsRepository(settings: widget.settings);
    limbsSettingsController.addListener(() {
      expanded = !expanded;
    });
  }

  void onSticksChanged(Stick stick, bool useOrNot) {
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
                    onStickChanged: (newStick) {
                      setState(() {
                        stick = newStick;
                      });
                    },
                    stick: stick,
                    expanded: true)
            ])
          ],
        ),
        collapsed:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (Stick stick in limbs.availableSticks)
            StickSettingsWidget(
                onStickChanged: (newStick) {
                  setState(() {
                    stick = newStick;
                  });
                },
                stick: stick,
                expanded: false)
        ]),
        controller: limbsSettingsController));
  }
}
