import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/styles.dart';

class NumberStepper extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final int step;

  final Function(int) onChanged;

  const NumberStepper(
      {super.key,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.step,
      required this.onChanged});

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  int _currentValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                if (_currentValue > widget.min) {
                  _currentValue -= widget.step;
                }
                widget.onChanged(_currentValue);
              });
            },
            icon: const Icon(
              Icons.remove_circle,
              color: trimColor,
            )),
        Text(_currentValue.toString()),
        IconButton(
            onPressed: () {
              setState(() {
                if (_currentValue < widget.max) {
                  _currentValue += widget.step;
                }
                widget.onChanged(_currentValue);
              });
            },
            icon: const Icon(Icons.add_circle, color: trimColor)),
      ],
    );
  }
}
