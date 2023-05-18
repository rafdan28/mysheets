import 'package:shared_preferences/shared_preferences.dart';

class Utente {
  static SharedPreferences? _prefs;

  static const _keyCodiceLogin = 'codiceLogin';
  static const _keyCodicePersona = 'codicePersona';
  static const _keyUsername = 'username';
  static const _keyNome = 'nome';
  static const _keyCognome = 'cognome';
  static const _keyPassword = 'password';
  static const _keyAzienda = 'azienda';
  static const _keyToken = 'token';
  static const _keyRemember = 'remember';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int? get codiceLogin => _prefs?.getInt(_keyCodiceLogin);
  static set codiceLogin(int? value) {
    if (_prefs != null) {
      _prefs!.setInt(_keyCodiceLogin, value ?? 0);
    }
  }

  static String? get codicePersona => _prefs?.getString(_keyCodicePersona);
  static set codicePersona(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyCodicePersona, value ?? '');
    }
  }

  static String? get username => _prefs?.getString(_keyUsername);
  static set username(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyUsername, value ?? '');
    }
  }

  static String? get nome => _prefs?.getString(_keyNome);
  static set nome(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyNome, value ?? '');
    }
  }

  static String? get cognome => _prefs?.getString(_keyCognome);
  static set cognome(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyCognome, value ?? '');
    }
  }

  static String? get password => _prefs?.getString(_keyPassword);
  static set password(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyPassword, value ?? '');
    }
  }

  static String? get azienda => _prefs?.getString(_keyAzienda);
  static set azienda(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyAzienda, value ?? '');
    }
  }

  static String? get token => _prefs?.getString(_keyToken);
  static set token(String? value) {
    if (_prefs != null) {
      _prefs!.setString(_keyToken, value ?? '');
    }
  }

  static bool? get remember => _prefs?.getBool(_keyRemember);
  static set remember(bool? value) {
    if (_prefs != null) {
      _prefs!.setBool(_keyRemember, value ?? false);
    }
  }
}
