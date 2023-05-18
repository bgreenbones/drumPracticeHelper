import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/styles.dart';

FutureBuilder<T> getFutureBuilder<T>(Future<T> future, Function(T) w) =>
    FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return w(snapshot.data!);
              }
          }
        });

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
