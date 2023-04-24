import 'package:flutter/material.dart';

const Color trimColor = Colors.blueGrey;
const Color backgroundColor = Colors.black87;

const TextStyle defaultText = TextStyle(
  fontSize: 18,
  color: Colors.white70,
);

const elementPadding = EdgeInsets.all(2.0);

const TextStyle barMarker =
    TextStyle(fontWeight: FontWeight.w900, color: Colors.greenAccent);
const TextStyle beatMarker =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan);

ButtonStyle buttonStyle =
    ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(trimColor));
