import 'dart:convert';
import 'dart:io';

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
    try {
      final response = await http.post(uri, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));
      final responseData = json.decode(response.body);
      if (responseData['error'] == null) {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
        notifyListeners();
      } else {
        throw HttpException(responseData['error']['message']);
      }
    } catch(_) {
      rethrow;
    }
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    return _token != null && _expiryDate != null && _expiryDate!.isAfter(DateTime.now()) ? _token : null;
  }
}