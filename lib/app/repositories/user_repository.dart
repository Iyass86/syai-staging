// lib/repositories/user_repository.dart
import 'package:flutter_oauth_chat/app/data/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class UserRepository extends BaseRepository<UserModel> {
  final SupabaseAuthService supabaseAuthService;
  UserRepository({required this.supabaseAuthService}) : super('users');

  Future<dynamic> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await supabaseAuthService
          .signUp(email: email, password: password, metadata: <String, dynamic>{
        'role': 'user',
        'created_at': DateTime.now().toIso8601String(),
        'name': name,
      });
    } catch (e) {
      throw SupabaseException((e as AuthException).message);
    }
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await supabaseAuthService.signIn(email: email, password: password);
    } catch (e) {
      throw SupabaseException((e as AuthException).message);
    }
  }

  Future<dynamic> signOut() async {
    try {
      return await supabaseAuthService.signOut();
    } catch (e) {
      throw SupabaseException((e as AuthException).message);
    }
  }
}
