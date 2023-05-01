import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'styles.dart';

class TimeSettings extends StatefulWidget {
  const TimeSettings({super.key});

  @override
  _TimeSettingsState createState() => _TimeSettingsState();
}

class _TimeSettingsState extends State<TimeSettings> {
  int divisionsPerBeat = 4;
  int beatsPerBar = 4;
  int divisionsPerBar() => beatsPerBar * divisionsPerBeat;
  int groupingLength = 3;
  int beatsPerQuarter = 1;

  static const List<DropdownMenuItem> timeSignatureBottoms = [
    DropdownMenuItem(value: 0.5, child: Text("2", style: defaultText)),
    DropdownMenuItem(value: 1, child: Text("4", style: defaultText)),
    DropdownMenuItem(value: 2, child: Text("8", style: defaultText)),
    DropdownMenuItem(value: 4, child: Text("16", style: defaultText)),
    DropdownMenuItem(value: 8, child: Text("32", style: defaultText)),
  ];

  static const List<DropdownMenuItem> divisions = [
    DropdownMenuItem(value: 2, child: Text("eighths", style: defaultText)),
    DropdownMenuItem(value: 3, child: Text("triplets", style: defaultText)),
    DropdownMenuItem(value: 4, child: Text("sixteenths", style: defaultText)),
    DropdownMenuItem(value: 5, child: Text("quints", style: defaultText)),
    DropdownMenuItem(
        value: 6, child: Text("sixteenth triplets", style: defaultText)),
    DropdownMenuItem(value: 7, child: Text("septuplets", style: defaultText)),
    DropdownMenuItem(
        value: 8, child: Text("thirty seconds", style: defaultText)),
    DropdownMenuItem(value: 9, child: Text("nonuplets", style: defaultText)),
  ];

  int getDivisionsPerBeat(int divisionsPerQuarter) {
    return divisionsPerQuarter ~/ beatsPerQuarter;
  }

  Widget timeSignatureSelector() {
    return Column(children: [
      NumberStepper(
          initialValue: beatsPerBar,
          min: 1,
          max: 64,
          step: 1,
          onChanged: (val) => setState(() => {beatsPerBar = val})),
      DropdownButton(
          items: timeSignatureBottoms,
          value: 1,
          dropdownColor: backgroundColor,
          onChanged: (val) => setState(() => {beatsPerQuarter = val}))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text("time signature:"), timeSignatureSelector()]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("division: "),
        DropdownButton(
            items: divisions,
            value: 4,
            dropdownColor: backgroundColor,
            onChanged: (val) =>
                setState(() => {divisionsPerBeat = getDivisionsPerBeat(val)}))
      ])
    ]);
  }
}
