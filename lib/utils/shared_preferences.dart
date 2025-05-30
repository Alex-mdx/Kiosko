import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static SharedPreferences? _preferences;
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get instance => _preferences;

  static bool get logeado => _preferences?.getBool('isLogged') ?? false;
  static set logeado(bool value) =>
      _preferences?.setBool('isLogged', value);

      static String get servidorLicencia => _preferences?.getString('servidor') ?? "";
  static set servidorLicencia(String value) =>
      _preferences?.setString('servidor', value);

      static bool get imprimirMP => _preferences?.getBool('imprimirmp') ?? false;
  static set imprimirMP(bool value) =>
      _preferences?.setBool('imprimirmp', value);
}
