// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

/// Generic Supabase service for handling all database operations
/// Usage: SupabaseService<YourModel>('table_name')
class SupabaseService<T> {
  final String tableName;
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseService(this.tableName);

  /// Create a new record
  Future<dynamic> create(Map<String, dynamic> data) async {
    try {
      final response =
          await _supabase.from(tableName).insert(data).select().single();
      return response;
    } catch (e) {
      throw SupabaseException('Failed to create record: $e');
    }
  }

  /// Get all records with optional filtering
  Future<List<T>> getAll({
    String? orderBy,
    bool ascending = true,
    int? limit,
    Map<String, dynamic>? filters,
  }) async {
    try {
      PostgrestTransformBuilder<PostgrestList> query =
          _supabase.from(tableName).select();

      // Apply filters if provided
      if (filters != null) {
        filters.forEach((key, value) {
          query =
              (query as PostgrestFilterBuilder<PostgrestList>).eq(key, value);
        });
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<T>.from(response);
    } catch (e) {
      throw SupabaseException('Failed to fetch records: $e');
    }
  }

  /// Get a single record by ID
  Future<dynamic> getById({required String key, required String id}) async {
    try {
      final response =
          await _supabase.from(tableName).select().eq(key, id).single();
      return response;
    } catch (e) {
      throw SupabaseException('Failed to fetch record: $e');
    }
  }

  /// Update a record by ID
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw SupabaseException('Failed to update record: $e');
    }
  }

  /// Delete a record by ID
  Future<dynamic> delete(String id) async {
    try {
      await _supabase.from(tableName).delete().eq('id', id);
    } catch (e) {
      throw SupabaseException('Failed to delete record: $e');
    }
  }

  /// Search records with text search
  Future<List<T>> search(String column, String searchTerm) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .textSearch(column, searchTerm);
      return List<T>.from(response);
    } catch (e) {
      throw SupabaseException('Failed to search records: $e');
    }
  }

  /// Get records with pagination
  Future<List<T>> getPaginated({
    required int page,
    required int pageSize,
    String? orderBy,
    bool ascending = true,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final from = page * pageSize;
      final to = from + pageSize - 1;

      PostgrestTransformBuilder<PostgrestList> query =
          _supabase.from(tableName).select();

      // Apply filters
      if (filters != null) {
        for (var entry in filters.entries) {
          query = (query as PostgrestFilterBuilder<PostgrestList>)
              .eq(entry.key, entry.value);
        }
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      final response = await query.range(from, to);
      return List<T>.from(response);
    } catch (e) {
      throw SupabaseException('Failed to fetch paginated records: $e');
    }
  }

  /// Count total records
  Future<int> count({Map<String, dynamic>? filters}) async {
    try {
      var query =
          _supabase.from(tableName).select('*').count(CountOption.exact);

      // Apply filters
      if (filters != null && filters.isNotEmpty) {
        for (var entry in filters.entries) {
          query = (query as PostgrestFilterBuilder).eq(entry.key, entry.value)
              as ResponsePostgrestBuilder<PostgrestResponse<PostgrestList>,
                  PostgrestList, PostgrestList>;
        }
      }

      final response = await query;
      return response.count;
    } catch (e) {
      throw SupabaseException('Failed to count records: $e');
    }
  }

  /// Bulk insert records
  Future<List<T>> bulkInsert(List<Map<String, dynamic>> dataList) async {
    try {
      final response =
          await _supabase.from(tableName).insert(dataList).select();
      return List<T>.from(response);
    } catch (e) {
      throw SupabaseException('Failed to bulk insert records: $e');
    }
  }

  /// Upsert (insert or update) record
  Future<T?> upsert(Map<String, dynamic> data) async {
    try {
      final response =
          await _supabase.from(tableName).upsert(data).select().single();
      return response as T?;
    } catch (e) {
      throw SupabaseException('Failed to upsert record: $e');
    }
  }

  /// Execute custom query
  Future<List<T>> customQuery(String query,
      {Map<String, dynamic>? params}) async {
    try {
      final response = await _supabase.rpc(query, params: params);
      return List<T>.from(response);
    } catch (e) {
      throw SupabaseException('Failed to execute custom query: $e');
    }
  }

  /// Listen to real-time changes
  Stream<List<T>> listenToChanges() {
    return _supabase
        .from(tableName)
        .stream(primaryKey: ['id']).map((data) => List<T>.from(data));
  }

  /// Listen to specific record changes
  Stream<T?> listenToRecord(String id) {
    return _supabase
        .from(tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => data.isNotEmpty ? data.first as T : null);
  }
}

/// Authentication service for Supabase
class SupabaseAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign up with email and password
  Future<dynamic> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw SupabaseException('Failed to sign out: $e');
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  /// Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw SupabaseException('Failed to reset password: $e');
    }
  }

  /// Update user metadata
  Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: data,
        ),
      );
    } catch (e) {
      throw SupabaseException('Failed to update user: $e');
    }
  }
}

/// File storage service for Supabase
class SupabaseStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String bucketName;

  SupabaseStorageService(this.bucketName);

  /// Upload file
  Future<String> uploadFile({
    required String path,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    try {
      final Uint8List bytes = Uint8List.fromList(fileBytes);
      await _supabase.storage.from(bucketName).uploadBinary(path, bytes,
          fileOptions: FileOptions(contentType: contentType));

      return _supabase.storage.from(bucketName).getPublicUrl(path);
    } catch (e) {
      throw SupabaseException('Failed to upload file: $e');
    }
  }

  /// Delete file
  Future<void> deleteFile(String path) async {
    try {
      await _supabase.storage.from(bucketName).remove([path]);
    } catch (e) {
      throw SupabaseException('Failed to delete file: $e');
    }
  }

  /// Get file URL
  String getFileUrl(String path) {
    return _supabase.storage.from(bucketName).getPublicUrl(path);
  }

  /// List files in directory
  Future<List<FileObject>> listFiles(String path) async {
    try {
      return await _supabase.storage.from(bucketName).list(path: path);
    } catch (e) {
      throw SupabaseException('Failed to list files: $e');
    }
  }
}

/// Custom exception for Supabase operations
class SupabaseException implements Exception {
  final String message;
  SupabaseException(this.message);

  @override
  String toString() => 'SupabaseException: $message';
}

/// Repository pattern implementation
abstract class BaseRepository<T> {
  final SupabaseService<T> _service;

  BaseRepository(String tableName) : _service = SupabaseService<T>(tableName);

  Future<dynamic> create(Map<String, dynamic> data) => _service.create(data);
  Future<List<T>> getAll() => _service.getAll();
  Future<dynamic> getById({required String key, required String id}) =>
      _service.getById(key: key, id: id);
  Future<dynamic> update(String id, Map<String, dynamic> data) =>
      _service.update(id, data);
  Future<dynamic> delete(String id) => _service.delete(id);
  Stream<List<T>> listenToChanges() => _service.listenToChanges();
}
