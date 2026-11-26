import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(
    this._store, {
    http.Client? client,
    this.host = 'jsonplaceholder.typicode.com',
  }) : _client = client ?? http.Client();

  final SecureStore _store;
  final http.Client _client;
  final String host;

  Future<Map<String, String>> _headers() async => {
    'Accept': 'application/json',
    if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
  };

  Future<http.Response> get(Uri uri) async {
    final headers = await _headers();
    final r = await _send(() => _client.get(uri, headers: headers));
    _afterResponse(r);
    return r;
  }

  Future<http.Response> post(Uri uri, Object body) async {
    final headers = await _headers();
    final r = await _send(
      () => _client.post(
        uri,
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );
    _afterResponse(r);
    return r;
  }

  dynamic decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException('not JSON: ${e.message}');
    }
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }

  void _afterResponse(http.Response r) {
    if (kDebugMode) {
      log(
        '${r.request?.method} ${r.request?.url} -> ${r.statusCode}',
        name: 'api',
      );
    }
    _check(r);
  }

  void _check(http.Response r) {
    final s = r.statusCode;
    if (s == 401) throw const UnauthorizedException();
    if (s == 404) throw const NotFoundException();
    if (s >= 500) throw ServerException(s);
    if (s < 200 || s >= 300) throw BadResponseException('HTTP $s');
  }
}
