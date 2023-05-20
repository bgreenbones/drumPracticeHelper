import 'package:flutter/material.dart';
import 'package:rhythm_practice_helper/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Settings {
  late String key;
  static String absoluteKey(String parentKey, String childKey) =>
      '$parentKey/$childKey';
  Future<void> save(String parentKey, Future<SharedPreferences> prefsFuture);
  Future<void> load(String parentKey, Future<SharedPreferences> prefsFuture);
}

class SettingsRepository<T extends Settings> {
  bool loaded = false;
  T settings;
  String parentKey;
  String get absoluteKey => Settings.absoluteKey(parentKey, settings.key);

  SettingsRepository({required this.settings, required this.parentKey});
  final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  void save() {
    settings.save(parentKey, prefsFuture);
  }

  Future<T> load() async {
    if (!loaded) {
      loaded = true;
      await settings.load(parentKey, prefsFuture);
    }
    return settings;
  }

  Widget getWidget(Widget Function(T) w) {
    return getFutureBuilder(load(), w);
  }
}

abstract class SettingsWidget<T extends Settings> extends StatefulWidget {
  final SettingsRepository<T>? repository;
  final Function(T) onChanged;
  final T settings;
  final bool? expanded;
  final String parentKey;
  // final String settingsKey;
  const SettingsWidget(
      {super.key,
      required this.onChanged,
      required this.settings,
      this.repository,
      this.expanded,
      // this.settingsKey = 'settings',
      this.parentKey = ''});
}

abstract class SettingsWidgetState<T extends Settings>
    extends State<SettingsWidget<T>> {
  late SettingsRepository<T> settingsRepository = widget.repository ??
      SettingsRepository<T>(
          settings: widget.settings,
          // key: widget.settingsKey,
          parentKey: widget.parentKey);
  T get settings => settingsRepository.settings;
  set settings(T s) {
    settingsRepository.settings = s;
  }

  @override
  void setState(void Function() fn) {
    super.setState(fn);
    settingsRepository.save();
    widget.onChanged(settings);
  }
}
