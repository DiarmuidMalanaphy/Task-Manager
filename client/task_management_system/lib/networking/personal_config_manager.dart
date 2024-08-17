import 'package:hive/hive.dart';

class PersonalConfigManager {
  static const String _boxName = 'gtd_box';
  static const String _configBoxName = "config_box";
  static const String _darkModeKey = 'dark_mode';
  static const String _showCompletedTasksKey = 'completed_tasks';
  static const String _animatedKey = 'animated?';
  static const String _monkeyKey = 'monkey_mode';
  late Box<dynamic> _box;
  PersonalConfigManager() {
    _box = Hive.box(_boxName);
  }

  String get darkModeKey {
    return _configBoxName + _darkModeKey;
  }

  String get showCompletedTasksKey {
    return _configBoxName + _showCompletedTasksKey;
  }

  String get animatedKey {
    return _configBoxName + _animatedKey;
  }

  String get monkeyKey {
    return _configBoxName + _monkeyKey;
  }

  void storeDarkModeConfig(bool darkModeConfig) {
    _box.put(darkModeKey, darkModeConfig);
  }

  void storeShowCompletedTasks(bool completedTasksConfig) {
    _box.put(showCompletedTasksKey, completedTasksConfig);
  }

  void storeAnimated(bool animatedConfig) {
    _box.put(animatedKey, animatedConfig);
  }

  void storeMonkey(bool monkeyConfig) {
    _box.put(monkeyKey, monkeyConfig);
  }

  bool getDarkModeConfig() {
    final bool? data = _box.get(darkModeKey) as bool?;
    if (data != null) {
      return data;
    }
    storeDarkModeConfig(true);
    return true; // -> Default case is darkmode
  }

  bool getShowCompletedTasksConfig() {
    final bool? data = _box.get(showCompletedTasksKey) as bool?;
    if (data != null) {
      return data;
    }
    storeShowCompletedTasks(false);
    return false; // -> Default case is don't show Completedtasks
  }

  bool getAnimated() {
    final bool? data = _box.get(animatedKey) as bool?;
    if (data != null) {
      return data;
    }
    storeAnimated(true);
    return true;
  }

  bool getMonkey() {
    final bool? data = _box.get(monkeyKey) as bool?;
    if (data != null) {
      return data;
    }
    storeMonkey(false);
    return false;
  }

  void flipDarkModeConfig() {
    storeDarkModeConfig(!getDarkModeConfig());
  }

  void flipShowCompletedTasksConfig() {
    storeShowCompletedTasks(!getShowCompletedTasksConfig());
  }

  void flipAnimated() {
    storeAnimated(!getAnimated());
  }

  void flipMonkey() {
    storeMonkey(!getMonkey());
  }
}
