import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/number_stepper.dart';
import 'styles.dart';

class TimerWidget extends StatefulWidget {
  final Function() onTimerReset;
  final Function() onTimerStop;
  const TimerWidget(
      {super.key, required this.onTimerReset, required this.onTimerStop});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  bool runTimer = false;
  Timer? _timer;
  int timerSetting = 15;
  late int timerValue = timerSetting - 1;
  get timerDisplayValue => timerValue + 1;
  get timerDisplayText =>
      "0:${timerDisplayValue < 10 ? "0" : ""}${timerDisplayValue.toString()}";

  void toggleTimer() {
    setState(() {
      runTimer = !runTimer;
      if (runTimer) {
        startTimer();
      } else {
        _timer?.cancel();
        widget.onTimerStop();
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timerValue = (timerValue - 1) % (timerSetting);
        if (timerValue == timerSetting - 1) {
          widget.onTimerReset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(trimColor)),
          onPressed: toggleTimer,
          child:
              Text('${runTimer ? 'stop' : 'start'} timer', style: defaultText)),
      runTimer
          ? Text(timerDisplayText, textScaleFactor: 2.0)
          : NumberStepper(
              initialValue: timerSetting,
              max: 120,
              min: 1,
              onChanged: (int val) {
                setState(() {
                  timerSetting = val;
                });
              },
              step: 5,
            )
    ]);
  }
}
