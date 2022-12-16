import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl       = 'identitytoolkit.googleapis.com';
  final String _fireBaseToken = 'AIzaSyCfhvRZE976tVafhgOeqrAEV6HOOLVDyK0';

  final storage = const FlutterSecureStorage();

  Future<String?> signUp(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };
    final url = Uri.https(_baseUrl,'/v1/accounts:signUp',{
      'key' : _fireBaseToken
    });
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    print('decodeResp: $decodeResp');
    if ( decodeResp.containsKey('idToken') ) {
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return null ;
    } else {
      return decodeResp['error']['message'];
    }
  }
  Future<String?> logIn(String email, String password) async {

    final Map<String, dynamic> authData = {
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };
    final url = Uri.https(_baseUrl,'/v1/accounts:signInWithPassword',{
      'key' : _fireBaseToken
    });
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if ( decodeResp.containsKey('idToken') ) {
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return null ;
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key:'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}