import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/auth_mode.dart';

class AuthProvider with ChangeNotifier {
  static const apiKey = 'AIzaSyBnsddHE-wWXrUCnzxu_JncfCnX6Vi4LPE';
  static const authMethodSignUp = 'signUp';
  static const authMethodSignIn = 'signInWithPassword';

  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  Future<void> authenticate(String email, String password, AuthMode authMode) async {
    final String authMethod = AuthMode.signup == authMode ? authMethodSignUp : authMethodSignIn;
    final uri = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$authMethod?key=$apiKey');
    final response = await http.post(uri, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    print(json.decode(response.body));
  }
}