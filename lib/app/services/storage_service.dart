import 'package:flutter_oauth_chat/app/data/models/ad_account.dart';
import 'package:flutter_oauth_chat/app/data/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/app/data/models/ads_manager.dart';
import 'package:flutter_oauth_chat/app/data/models/organization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _box = GetStorage();

  // Keys
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';
  static const _csrfStateKey = 'csrf_state';
  static const _snapKey = 'snap_data';
  static const _adsManagerKey = 'ads_manager_data';
  static const _selectedOrganizationKey = 'selected_organization';
  static const _selectedAdAccountKey = 'selected_ad_account';
  // Token methods
  String? getAccessToken() => _box.read<String>(_tokenKey);
  Future<void> saveAccessToken(String token) => _box.write(_tokenKey, token);
  Future<void> removeAccessToken() => _box.remove(_tokenKey);

  // Refresh token methods
  String? getRefreshToken() => _box.read<String>(_refreshTokenKey);
  Future<void> saveRefreshToken(String token) =>
      _box.write(_refreshTokenKey, token);
  Future<void> removeRefreshToken() => _box.remove(_refreshTokenKey);

  // User data methods
  User? getUser() =>
      User.fromJson(_box.read<Map<String, dynamic>>(_userKey) ?? {});
  Future<void> saveUser(Map<String, dynamic> userData) =>
      _box.write(_userKey, userData);

  Future<void> saveSnapToken(Map<String, dynamic> snapTokenResponse) {
    return _box.write(_snapKey, snapTokenResponse);
  }

  SnapTokenResponse? get snapTokenResponse => SnapTokenResponse.fromJson(
      _box.read<Map<String, dynamic>>(_snapKey) ?? {});

  Future<void> removeSnapToken() => _box.remove(_snapKey);

  Future<void> removeUser() => _box.remove(_userKey);
  // CSRF state methodsxa
  String? getCsrfState() => _box.read<String>(_csrfStateKey);
  Future<void> saveCsrfState(String state) => _box.write(_csrfStateKey, state);
  Future<void> removeCsrfState() => _box.remove(_csrfStateKey);

  // AdsManager methods
  AdsManagerModel? getAdsManager() {
    final data = _box.read<Map<String, dynamic>>(_adsManagerKey);
    if (data == null || data.isEmpty) return null;
    return AdsManagerModel.fromJson(data);
  }

  Future<void> saveAdsManager(Map<String, dynamic> adsManagerData) =>
      _box.write(_adsManagerKey, adsManagerData);

  Future<void> removeAdsManager() => _box.remove(_adsManagerKey);

  // Organization methods
  Future<void> saveOrganization(Organization organization) async {
    await _box.write(_selectedOrganizationKey, organization.toJson());
  }

  Organization? get selectedOrganization {
    final data = _box.read<Map<String, dynamic>>(_selectedOrganizationKey);
    if (data == null || data.isEmpty) return null;
    return Organization.fromJson(data);
  }

  Future<void> removeSelectedOrganization() async {
    await _box.remove(_selectedOrganizationKey);
  }

  bool hasSelectedOrganization() {
    return _box.hasData(_selectedOrganizationKey);
  }

  // Clear all storage
  Future<void> clearAll() => _box.erase();

  void saveSelectedAdAccount(AdAccount account) {
    _box.write(_selectedAdAccountKey, account.toJson());
  }

  AdAccount? get selectedAdAccount {
    final data = _box.read<Map<String, dynamic>>(_selectedAdAccountKey);
    if (data == null || data.isEmpty) return null;
    return AdAccount.fromJson(data);
  }

  Future<void> saveSnapAuth(Map<String, dynamic> mapData) async {
    _box.write("snap_auth_v2", mapData);
  }

  Future<Map<String, dynamic>> getSnapAuth() async {
    return _box.read<Map<String, dynamic>>("snap_auth_v2") ?? {};
  }

  Future<String> getAuthCode() async {
    return _box.read<String>("auth_code") ?? '';
  }

  Future<void> saveAuthCode(String code) async {
    await _box.write("auth_code", code);
  }
}
