import 'package:flutter/material.dart';
import 'possible_stickings.dart';
import 'groupings.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    setState(() => {Wakelock.enable()});
    return const MaterialApp(title: 'Drum Helper', home: PossibleStickings());
  }
}
