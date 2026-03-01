
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _webLocal = 'http://localhost:8000';
  static const _webLan   = 'http://192.168.0.50:8000'; // change to your PC IP
  static const _androidEmu = 'http://10.0.2.2:8000';

  static String get baseUrl {
    if (kIsWeb) return _webLocal; // switch to _webLan when needed
    return _androidEmu;
  }
}