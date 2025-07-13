import 'package:flutter_oauth_chat/core/models/ad_account.dart';
import 'package:flutter_oauth_chat/core/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/core/models/ads_manager.dart';
import 'package:flutter_oauth_chat/core/models/organization.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _box = GetStorage();
  static final StorageService i = Get.find<StorageService>();
  // Keys
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';
  static const _csrfStateKey = 'csrf_state';
  static const _snapKey = 'snap_data';
  static const _adsManagerKey = 'ads_manager_data';
  static const _selectedOrganizationKey = 'selected_organization';
  static const _selectedAdAccountKey = 'selected_ad_account';
  static const _snapAuthKey = 'snap_auth_v2';
  static const _authCodeKey = 'auth_code';

  // Helper methods
  String _getUserSpecificKey(String baseKey) =>
      '${baseKey}_${getUser()?.id ?? ''}';

  // User data methods
  User? getUser() => _box.read<Map<String, dynamic>>(_userKey) != null
      ? User.fromJson(_box.read<Map<String, dynamic>>(_userKey)!)
      : null;

  Future<void> saveUser(Map<String, dynamic> userData) =>
      _box.write(_userKey, userData);
  Future<void> removeUser() => _box.remove(_userKey);

  // Token methods
  String? getAccessToken() => _box.read<String>(_getUserSpecificKey(_tokenKey));
  Future<void> saveAccessToken(String token) =>
      _box.write(_getUserSpecificKey(_tokenKey), token);
  Future<void> removeAccessToken() =>
      _box.remove(_getUserSpecificKey(_tokenKey));

  // Refresh token methods
  String? getRefreshToken() =>
      _box.read<String>(_getUserSpecificKey(_refreshTokenKey));
  Future<void> saveRefreshToken(String token) =>
      _box.write(_getUserSpecificKey(_refreshTokenKey), token);
  Future<void> removeRefreshToken() =>
      _box.remove(_getUserSpecificKey(_refreshTokenKey));

  // CSRF state methods
  String? getCsrfState() =>
      _box.read<String>(_getUserSpecificKey(_csrfStateKey));
  Future<void> saveCsrfState(String state) =>
      _box.write(_getUserSpecificKey(_csrfStateKey), state);
  Future<void> removeCsrfState() =>
      _box.remove(_getUserSpecificKey(_csrfStateKey));

  // Snap token methods
  SnapTokenResponse? get snapTokenResponse {
    final data = _box.read<Map<String, dynamic>>(_getUserSpecificKey(_snapKey));
    if (data == null || data.isEmpty) return null;
    return SnapTokenResponse.fromJson(data);
  }

  Future<void> saveSnapToken(Map<String, dynamic> snapTokenResponse) =>
      _box.write(_getUserSpecificKey(_snapKey), snapTokenResponse);

  Future<void> removeSnapToken() => _box.remove(_getUserSpecificKey(_snapKey));

  // AdsManager methods
  AdsManagerModel? getAdsManager() {
    final data =
        _box.read<Map<String, dynamic>>(_getUserSpecificKey(_adsManagerKey));
    if (data == null || data.isEmpty) return null;
    return AdsManagerModel.fromJson(data);
  }

  Future<void> saveAdsManager(Map<String, dynamic> adsManagerData) =>
      _box.write(_getUserSpecificKey(_adsManagerKey), adsManagerData);

  Future<void> removeAdsManager() =>
      _box.remove(_getUserSpecificKey(_adsManagerKey));

  // Organization methods
  Organization? get selectedOrganization {
    final data = _box.read<Map<String, dynamic>>(
        _getUserSpecificKey(_selectedOrganizationKey));
    if (data == null || data.isEmpty) return null;
    return Organization.fromJson(data);
  }

  Future<void> saveOrganization(Organization organization) => _box.write(
      _getUserSpecificKey(_selectedOrganizationKey), organization.toJson());

  Future<void> removeSelectedOrganization() =>
      _box.remove(_getUserSpecificKey(_selectedOrganizationKey));

  bool hasSelectedOrganization() =>
      _box.hasData(_getUserSpecificKey(_selectedOrganizationKey));

  // Ad Account methods
  AdAccount? get selectedAdAccount {
    final data = _box
        .read<Map<String, dynamic>>(_getUserSpecificKey(_selectedAdAccountKey));
    if (data == null || data.isEmpty) return null;
    return AdAccount.fromJson(data);
  }

  Future<void> saveSelectedAdAccount(AdAccount account) =>
      _box.write(_getUserSpecificKey(_selectedAdAccountKey), account.toJson());

  Future<void> removeSelectedAdAccount() =>
      _box.remove(_getUserSpecificKey(_selectedAdAccountKey));

  // Snap auth methods
  Future<Map<String, dynamic>> getSnapAuth() async =>
      _box.read<Map<String, dynamic>>(_getUserSpecificKey(_snapAuthKey)) ?? {};

  Future<void> saveSnapAuth(Map<String, dynamic> mapData) =>
      _box.write(_getUserSpecificKey(_snapAuthKey), mapData);

  // Auth code methods
  Future<String> getAuthCode() async =>
      _box.read<String>(_getUserSpecificKey(_authCodeKey)) ?? '';

  Future<void> saveAuthCode(String code) =>
      _box.write(_getUserSpecificKey(_authCodeKey), code);

  // Clear all storage
  Future<void> clearAll() => _box.erase();

  // Clear user-specific data
  Future<void> clearUserData() async {
    final userId = getUser()?.id;
    if (userId == null) return;

    final keysToRemove = [
      _getUserSpecificKey(_tokenKey),
      _getUserSpecificKey(_refreshTokenKey),
      _getUserSpecificKey(_csrfStateKey),
      _getUserSpecificKey(_snapKey),
      _getUserSpecificKey(_adsManagerKey),
      _getUserSpecificKey(_selectedOrganizationKey),
      _getUserSpecificKey(_selectedAdAccountKey),
      _getUserSpecificKey(_snapAuthKey),
      _getUserSpecificKey(_authCodeKey),
    ];

    for (final key in keysToRemove) {
      await _box.remove(key);
    }

    await removeUser();
  }
}
