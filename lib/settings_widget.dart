import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsObject<T> {
  bool loaded = false;
  T settings;
  late String key;
  SettingsObject({required this.settings, required key, required parentKey}) {
    this.key = parentKey + '/' + key;
  }
  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  void save();
  Future<T> load();
  Widget getWidget(Widget Function(T) w) {
    if (loaded) {
      return w(settings);
    }
    // loaded = true;
    return getFutureBuilder(load(), w);
  }
}

abstract class SettingsWidget<T> extends StatefulWidget {
  final Function(T) onChanged;
  final T settings;
  final bool? expanded;
  final String parentKey;
  final String settingsKey;
  const SettingsWidget(
      {super.key,
      required this.onChanged,
      required this.settings,
      this.expanded,
      this.settingsKey = 'settings',
      this.parentKey = ''});
}

abstract class SettingsWidgetState<T, U extends SettingsObject<T>>
    extends State<SettingsWidget<T>> {
  late U settingsRepository;
  T get settings => settingsRepository.settings;
  @override
  void setState(void Function() fn) {
    super.setState(() => {fn(), settingsRepository.loaded = true});
    settingsRepository.save();
    widget.onChanged(settings);
  }
}
