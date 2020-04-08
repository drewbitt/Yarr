import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  final fontFamilyString = 'chapterFontFamily';
  final fontSizeString = 'chapterFontSize';

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  String get fontFamily => _getFromDisk(fontFamilyString);
  int get fontSize => _getFromDisk(fontSizeString);

  set fontFamily(String value) => saveToDisk(fontFamilyString, value);
  set fontSize(int value) => saveToDisk(fontSizeString, value);

  dynamic _getFromDisk(String key) => _preferences.get(key);
  void saveToDisk(String key, dynamic value) {
    switch (value.runtimeType) {
      case String:
        _preferences.setString(key, value);
        break;
      case int:
        _preferences.setInt(key, value);
        break;
      case bool:
        _preferences.setBool(key, value);
        break;
      case double:
        _preferences.setBool(key, value);
        break;
      // case List<String>: _preferences.setStringList(key, value);
      default:
        throw ("Setting invalid type to disk");
    }
  }

  bool containsKey(String key) => _preferences.containsKey(key);
}
