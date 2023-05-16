import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

const Color trimColor = Colors.blueGrey;
const Color backgroundColor = Colors.black87;
const Color darkGrey = Color.fromARGB(255, 72, 72, 72);

const Color textColor = Colors.white70;
const TextStyle defaultText = TextStyle(fontSize: 18, color: textColor);

const elementPadding = EdgeInsets.all(2.0);
const morePadding = EdgeInsets.all(10);
const TextStyle barMarker =
    TextStyle(fontWeight: FontWeight.w900, color: Colors.green);
const TextStyle beatMarker =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan);
const TextStyle groupingMarker = TextStyle(color: Colors.deepOrange);

ButtonStyle buttonStyle =
    ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(trimColor));

ExpandablePanel getExpandable(Widget header, Widget expanded,
        {ExpandableController? controller, Widget? collapsed}) =>
    ExpandablePanel(
        controller: controller,
        theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToCollapse: true,
            iconColor: textColor,
            hasIcon: true),
        header: header,
        collapsed: collapsed ?? Column(),
        expanded: expanded);
