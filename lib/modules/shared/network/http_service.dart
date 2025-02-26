import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = 'http://192.168.1.2:3300';
  final String fallbackUrl = 'http://localhost:3300';
  final storage = FlutterSecureStorage();

  String _token = '';

  Future<void> _ensureToken() async {
    final token = await storage.read(key: 'jwt');
    if (token == null || token.isEmpty) {
      throw Exception('Token de autenticação não encontrado.');
    }
    _token = token;
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    await _ensureToken();
    return _request('GET', path, queryParameters: queryParameters);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    await _ensureToken();
    return _request('POST', path, body: body);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    await _ensureToken();
    return _request('PUT', path, body: body);
  }

  Future<dynamic> delete(String path) async {
    await _ensureToken();
    return _request('DELETE', path);
  }

  /// **Novo método para chamadas sem autenticação**
  Future<dynamic> postWithoutAuth(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro ao conectar-se ao backend: $e');
    }
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri =
        Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
    final fallbackUri = Uri.parse('$fallbackUrl$path')
        .replace(queryParameters: queryParameters);

    try {
      final response = await _sendRequest(method, uri, body);
      return _handleResponse(response);
    } on SocketException catch (_) {
      return await _sendRequest(method, fallbackUri, body)
          .then((response) => _handleResponse(response));
    } on TimeoutException catch (_) {
      return await _sendRequest(method, fallbackUri, body)
          .then((response) => _handleResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> _sendRequest(
      String method, Uri uri, Map<String, dynamic>? body) async {
    final headers = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json'
    };

    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await http.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw Exception('Método HTTP não suportado');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro: ${response.statusCode}, ${response.body}');
    }
  }
}
