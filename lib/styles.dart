import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

const Color trimColor = Colors.blueGrey;
const Color backgroundColor = Colors.black87;
const Color darkGrey = Color.fromARGB(255, 72, 72, 72);

const Color textColor = Colors.white70;
const double defaultTextSize = 18;
const TextStyle defaultText =
    TextStyle(fontSize: defaultTextSize, color: textColor);

const elementPadding = EdgeInsets.all(2.0);
const morePadding = EdgeInsets.all(10);
const TextStyle barMarker =
    TextStyle(fontWeight: FontWeight.w900, color: Colors.green);
const TextStyle beatMarker =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan);
const TextStyle groupingMarker = TextStyle(color: Colors.deepOrange);

ButtonStyle buttonStyle =
    ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(trimColor));
