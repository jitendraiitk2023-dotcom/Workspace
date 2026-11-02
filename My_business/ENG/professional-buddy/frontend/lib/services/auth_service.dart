import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  AppUser? currentUser;
  bool isLoading = true; // true while checking for a saved session on app start
  String? errorMessage;

  Future<void> tryAutoLogin() async {
    isLoading = true;
    notifyListeners();
    final token = await _api.getToken();
    if (token != null) {
      try {
        final data = await _api.get('/auth/me');
        currentUser = AppUser.fromJson(data);
      } catch (_) {
        await _api.clearToken();
        currentUser = null;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    errorMessage = null;
    try {
      final data = await _api.post('/auth/register', body: {
        'name': name,
        'email': email,
        'password': password,
      });
      await _api.saveToken(data['access_token']);
      currentUser = AppUser.fromJson(data['user']);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    errorMessage = null;
    try {
      final data = await _api.postForm('/auth/login', {
        'username': email, // OAuth2 spec field name
        'password': password,
      });
      await _api.saveToken(data['access_token']);
      currentUser = AppUser.fromJson(data['user']);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? bio, String? avatarColor}) async {
    final data = await _api.patch('/auth/me', body: {
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (avatarColor != null) 'avatar_color': avatarColor,
    });
    currentUser = AppUser.fromJson(data);
    notifyListeners();
  }
}
