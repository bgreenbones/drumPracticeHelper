import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/settings_widget.dart';
import 'package:rhythm_practice_helper/styles.dart';

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

class Limbs extends SettingsObject {
  Stick right = Stick(symbol: 'R', maxBounces: 3, minBounces: 1, inUse: true);
  Stick left = Stick(symbol: 'L', maxBounces: 2, minBounces: 1, inUse: true);
  Stick kick = Stick(symbol: 'K', maxBounces: 2, minBounces: 1, inUse: false);
  Stick hat = Stick(symbol: 'H', maxBounces: 1, minBounces: 1, inUse: false);

  late List<Stick> availableSticks = [right, left, kick, hat];
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

class LimbsSettingsWidget extends SettingsWidget<Limbs> {
  const LimbsSettingsWidget({
    super.key,
    required limbs,
    required onLimbsChanged,
  }) : super(onChanged: onLimbsChanged, settings: limbs);

  @override
  LimbsSettingsWidgetState createState() => LimbsSettingsWidgetState();
}

class LimbsSettingsWidgetState extends SettingsWidgetState<Limbs> {
  late Limbs limbs = widget.settings;

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
    return getExpandable(
        const Text("limbs settings"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              for (Stick stick in limbs.availableSticks)
                Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                stick.inUse ? trimColor : darkGrey)),
                        onPressed: () => onSticksChanged(stick, !(stick.inUse)),
                        child: Text(
                          stick.symbol,
                          style: defaultText,
                        )),
                    RangeSlider(
                        min: 1,
                        max: 4,
                        divisions: 4 - 1,
                        labels: RangeLabels(
                            "${stick.minBounces}", "${stick.maxBounces}"),
                        activeColor: trimColor,
                        values: RangeValues(stick.minBounces.toDouble(),
                            stick.maxBounces.toDouble()),
                        onChanged: (rangeValue) => {
                              if (rangeValue.start != stick.minBounces)
                                {
                                  minimumBouncesChanged(
                                      rangeValue.start.toInt(), stick)
                                },
                              if (rangeValue.end != stick.maxBounces)
                                {
                                  maximumBouncesChanged(
                                      rangeValue.end.toInt(), stick)
                                }
                            })
                  ],
                )
            ])
          ],
        ),
        collapsed:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (Stick stick in limbs.availableSticks)
            TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        stick.inUse ? trimColor : darkGrey)),
                onPressed: () => onSticksChanged(stick, !(stick.inUse)),
                child: Text(
                  stick.symbol,
                  style: defaultText,
                ))
        ]),
        controller: limbsSettingsController);
  }
}
