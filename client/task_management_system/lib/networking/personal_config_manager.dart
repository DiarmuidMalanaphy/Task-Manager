import 'package:hive/hive.dart';

class PersonalConfigManager {
  static const String _boxName = 'config_box';
  static const String _darkModeKey = 'dark_mode';
  static const String _showCompletedTasksKey = 'completed_tasks';
  static const String _animatedKey = 'animated?';
  static const String _monkeyKey = 'monkey_mode';
  late Box<dynamic> _box;
  PersonalConfigManager() {
    _box = Hive.box(_boxName);
  }

  void storeDarkModeConfig(bool darkModeConfig) {
    _box.put(_darkModeKey, darkModeConfig);
  }

  void storeShowCompletedTasks(bool completedTasksConfig) {
    _box.put(_showCompletedTasksKey, completedTasksConfig);
  }

  void storeAnimated(bool animatedConfig) {
    _box.put(_animatedKey, animatedConfig);
  }

  void storeMonkey(bool monkeyConfig) {
    _box.put(_monkeyKey, monkeyConfig);
  }

  bool getDarkModeConfig() {
    final bool? data = _box.get(_darkModeKey) as bool?;
    if (data != null) {
      return data;
    }
    storeDarkModeConfig(false);
    return false; // -> Default case is not darkmode
  }

  bool getShowCompletedTasksConfig() {
    final bool? data = _box.get(_showCompletedTasksKey) as bool?;
    if (data != null) {
      return data;
    }
    storeShowCompletedTasks(false);
    return false; // -> Default case is don't show Completedtasks
  }

  bool getAnimated() {
    final bool? data = _box.get(_animatedKey) as bool?;
    if (data != null) {
      return data;
    }
    storeAnimated(true);
    return true;
  }

  bool getMonkey() {
    final bool? data = _box.get(_monkeyKey) as bool?;
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
