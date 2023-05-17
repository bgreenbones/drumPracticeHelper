import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsObject {
  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  void save();
  Future<SettingsObject> load();
  FutureBuilder<SettingsObject> getFutureBuilder(Function(SettingsObject) w) =>
      FutureBuilder<SettingsObject>(
          future: load(),
          builder:
              (BuildContext context, AsyncSnapshot<SettingsObject> snapshot) {
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
}

abstract class SettingsWidget<T extends SettingsObject> extends StatefulWidget {
  final Function(T) onChanged;
  final T settings;

  const SettingsWidget(
      {super.key, required this.onChanged, required this.settings});
}

abstract class SettingsWidgetState<T extends SettingsObject>
    extends State<SettingsWidget<T>> {
  late T settings = widget.settings;

  @override
  void setState(Function fn) {
    fn();
    settings.save();
    widget.onChanged(settings);
  }

  // @override
  // void initState() async {
  //   super.initState();
  //   await settings.load();
  // }

  // @override
  // Widget build(BuildContext context) {
  // return const Text("implement");
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('SharedPreferences Demo'),
  //     ),
  //     body: Center(
  //         child: FutureBuilder<int>(
  //             future: _counter,
  //             builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
  //               switch (snapshot.connectionState) {
  //                 case ConnectionState.none:
  //                 case ConnectionState.waiting:
  //                   return const CircularProgressIndicator();
  //                 case ConnectionState.active:
  //                 case ConnectionState.done:
  //                   if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else {
  //                     return Text(
  //                       'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
  //                       'This should persist across restarts.',
  //                     );
  //                   }
  //               }
  //             })),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Increment',
  //       child: const Icon(Icons.add),
  //     ),
  //   );
  // }
}
