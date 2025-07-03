// lib/repositories/user_repository.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_oauth_chat/app/data/models/ads_manager.dart';

import '../services/supabase_service.dart';

class AdsManagerRepository extends BaseRepository<AdsManagerModel> {
  AdsManagerRepository() : super('ads_managers');

  final SupabaseService<AdsManagerModel> supabaseService =
      SupabaseService<AdsManagerModel>("ads_managers");
  @override
  Future<List<AdsManagerModel>> getAll() async {
    try {
      final response = await supabaseService.getAll();
      return response;
    } catch (e) {
      return [];
    }
  }

  @override
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
      throw SupabaseException("Failed to fetch AdsManager $e");
    }
  }

  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    try {
      final response = await supabaseService.create(data);
      return response;
    } catch (e) {
      throw SupabaseException("Failed to create AdsManager $e");
    }
  }

  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await supabaseService.update(
        id,
        data,
      );
      return response;
    } catch (e) {
      throw SupabaseException("Failed to update AdsManager $e");
    }
  }
}
