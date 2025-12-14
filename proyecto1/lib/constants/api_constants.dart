import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    // Detecta si la app está corriendo en un emulador de Android
    // o en la web para desarrollo.
    bool isEmulator = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    
    // PC y emuladores Android usan diferentes direcciones para localhost.
    // En un dispositivo físico, deberías usar la IP de tu máquina.
    return isEmulator ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
  }

  // Endpoints de autenticación
  static const String login = '/auth/login'; // Corregido para coincidir con el backend
  static const String register = '/auth/register'; // Corregido para coincidir con el backend

  // Otros endpoints que puedas necesitar
  // static const String products = '/api/products';
}
