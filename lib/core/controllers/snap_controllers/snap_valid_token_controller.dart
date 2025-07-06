import 'package:flutter_oauth_chat/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/core/models/ad_accounts_response.dart';
import 'package:flutter_oauth_chat/core/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/core/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/core/services/storage_service.dart';
import 'package:get/get.dart';

class SnapValidTokenController extends GetxController {
  SnapRepository snapRepository;
  SnapValidTokenController({required this.snapRepository});
  static SnapValidTokenController get to =>
      Get.find<SnapValidTokenController>();
  StorageService get _storageService => Get.find<StorageService>();
  SnapTokenResponse? get currentToken => _storageService.snapTokenResponse;
  String? get accessToken => _storageService.snapTokenResponse?.accessToken;

  /// Auto-refresh token if needed

  /// Get all ad accounts for the current organization
}
