// lib/repositories/ads_managers_repository.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_oauth_chat/core/models/ads_manager.dart';
import 'package:flutter_oauth_chat/core/services/supabase_service.dart';

class AdsManagerRepository {
  final SupabaseService<Map<String, dynamic>> supabaseService;

  AdsManagerRepository()
      : supabaseService = SupabaseService<Map<String, dynamic>>("ads_managers");

  Future<List<AdsManagerModel>> getAll() async {
    try {
      final response = await supabaseService.getAll();
      return response.map((json) => AdsManagerModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error in getAll: $e');
      }
      return [];
    }
  }

  Future<AdsManagerModel?> getById(
      {required String key, required String id}) async {
    debugPrint("### AdsManagerRepository getById response: $id");

    try {
      final response = await supabaseService.getById(key: key, id: id)
          as Map<String, dynamic>?;
      if (response != null) {
        return AdsManagerModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch AdsManager $e");
    }
  }

  Future<dynamic> create(Map<String, dynamic> data) async {
    try {
      final response = await supabaseService.create(data);
      return response;
    } catch (e) {
      throw Exception("Failed to create AdsManager $e");
    }
  }

  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await supabaseService.update(id, data);
      return response;
    } catch (e) {
      throw Exception("Failed to update AdsManager $e");
    }
  }
}
