import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

// abstract class SettingsObject {
abstract class SettingsObject<T> {
  bool loaded = false;
  T settings;
  SettingsObject({required this.settings});
  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  void save();
  // Future<SettingsObject> load();
  Future<T> load();
  Widget getWidget(Function(T) w) {
    if (loaded) {
      return w(settings);
    }
    loaded = true;
    return getFutureBuilder(load(), w);
  }
}

// abstract class SettingsWidget<T extends SettingsObject> extends StatefulWidget {
abstract class SettingsWidget<T> extends StatefulWidget {
  final Function(T) onChanged;
  final T settings;
  final bool? expanded;
  const SettingsWidget(
      {super.key,
      required this.onChanged,
      required this.settings,
      this.expanded});
}

// abstract class SettingsWidgetState<T extends SettingsObject>
//     extends State<SettingsWidget<T>> {
abstract class SettingsWidgetState<T, U extends SettingsObject<T>>
    extends State<SettingsWidget<T>> {
  // late Future<T> settingsFuture = settingsRepository.load();
  // late T settings; //= widget.settings;
  late U settingsRepository;
  T get settings => settingsRepository.settings;

  @override
  void setState(Function fn) {
    fn();
    settingsRepository.save();
    settingsRepository.loaded = true;
    widget.onChanged(settings);
  }

  // @override
  // void initState() async {
  //   super.initState();
  //   await settings.load();
  // }
}
