import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConstants {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get oauthClientId => dotenv.env['OAUTH_CLIENT_ID'] ?? '';
  static String get oauthClientSecret =>
      dotenv.env['OAUTH_CLIENT_SECRET'] ?? '';
  static String get oauthRedirectUri => dotenv.env['OAUTH_REDIRECT_URI'] ?? '';
  static const List<String> oauthScopes = [
    'snapchat-marketing-api'
  ]; // Replace with your required scopes
  static const String oauthAuthorizationEndpoint =
      'https://accounts.snapchat.com/login/oauth2/authorize'; // Replace with your OAuth provider's authorization endpoint
  static const String n8nWebSocketUrl = 'wss://socket.example.com';

  static var oauthCallbackUrlScheme =
      "https://localhost:8080/callback.html"; // Replace with your WebSocket server URL

  // Generate a random state for CSRF protection
  static String generateState() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final state =
        List.generate(32, (index) => chars[index % chars.length]).join();
    return '$state$random';
  }

 
}
