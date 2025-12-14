import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto1/constants/api_constants.dart';
import 'package:proyecto1/dto/register_request_dto.dart';
import 'package:proyecto1/dto/tipo_documento_dto.dart';

class ApiService {
  // Almacenamiento temporal de sesión (En una app real usar SharedPreferences o SecureStorage)
  static String? _token;
  static int? _currentPersonId;

  static int? get currentPersonId => _currentPersonId;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _token = body['token'];
        _currentPersonId = body['personId']; // Guardamos el ID de persona

        debugPrint('Login exitoso. Person ID: $_currentPersonId');
        return true;
      } else {
        debugPrint('Error de login: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión: $e');
      return false;
    }
  }

  Future<bool> register(RegisterRequestDTO registerRequest) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(registerRequest.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Cualquier 2xx es éxito
        return true;
      } else {
        // Manejar errores de registro
        debugPrint('Error de registro: ${response.statusCode}');
        debugPrint('Cuerpo de la respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      // Manejar errores de conexión
      debugPrint('Error de conexión: $e');
      return false;
    }
  }

  Future<List<TipoDocumentoDTO>> getTipoDocumentos() async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/tipo-documentos',
    ); // Endpoint a confirmar
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<TipoDocumentoDTO> tiposDocumento = body
            .map((dynamic item) => TipoDocumentoDTO.fromJson(item))
            .toList();
        return tiposDocumento;
      } else {
        debugPrint(
          'Error al obtener tipos de documento: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error de conexión al obtener tipos de documento: $e');
      return [];
    }
  }

  Future<bool> createReservation(Map<String, dynamic> reservationData) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/reservaciones',
    ); // Endpoint correcto
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reservationData),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        debugPrint('Error al crear reservación: ${response.statusCode}');
        debugPrint('Cuerpo: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión al crear reservación: $e');
      return false;
    }
  }

  Future<List<dynamic>> getReservationsByPerson(int personId) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/reservaciones/person/$personId',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Error al obtener reservaciones: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error de conexión al obtener reservaciones: $e');
      return [];
    }
  }

  Future<bool> updateReservation(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/reservaciones/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        debugPrint('Error al actualizar reservación: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión al actualizar: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getPerson(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/persons/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Error al obtener persona: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error de conexión al obtener persona: $e');
      return null;
    }
  }

  Future<bool> cancelReservation(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/reservaciones/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": id, "condition": "CANCELLED"}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        debugPrint('Error al cancelar reservación: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error de conexión al cancelar: $e');
      return false;
    }
  }
}
