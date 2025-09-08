import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/google_auth_config.dart';

class AuthResult {
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? user;
  final bool isNew;
  final String? pendingId;
  final String? error;

  AuthResult({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isNew = false,
    this.pendingId,
    this.error,
  });
}

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api'; // Change for prod
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: GoogleAuthConfig.webClientId, // Add this for web support
    serverClientId:
        GoogleAuthConfig.webClientId, // Add this for getting serverAuthCode
  );

  // Store tokens
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Start OTP flow
  Future<AuthResult> startAuth(String contact) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/start'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'contact': contact}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthResult(pendingId: data['pendingId']);
      } else {
        final error = json.decode(response.body);
        return AuthResult(
          error: error['message'] ?? 'Failed to start authentication',
        );
      }
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  // Verify OTP
  Future<AuthResult> verifyOtp(String pendingId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'pendingId': pendingId, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokens(data['accessToken'], data['refreshToken']);

        return AuthResult(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          user: data['user'],
          isNew: data['isNew'] ?? false,
        );
      } else {
        final error = json.decode(response.body);
        return AuthResult(error: error['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  // Google Sign In
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult(error: 'Google sign in cancelled');
      }

      // Get email and start OTP flow
      // Note: In production, you might want a separate endpoint for Google auth
      return startAuth(googleUser.email);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  // Sign Out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await _googleSignIn.signOut();
  }
}
