import 'package:shared_preferences/shared_preferences.dart';

class FlutterSecureStorage {
  Future<String> read({String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString(key);
    } catch (ex) {
      return null;
    }
  }

  Future<void> write({String key, String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return prefs.setString(key, value);
    } catch (ex) {
      return null;
    }
  }

  Future<void> delete({String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return prefs.remove(key);
    } catch (ex) {
      return null;
    }
  }
}
