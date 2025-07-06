import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_valid_token_controller.dart';
import 'package:flutter_oauth_chat/app/data/models/ad_account.dart';
import 'package:flutter_oauth_chat/app/data/models/ad_accounts_response.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:positioned_scroll_observer/positioned_scroll_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/chat_message.dart';
import 'auth_controller.dart';
import 'message_display_controller.dart';

class ChatController extends GetxController {
  AuthController _authController = Get.find<AuthController>();
  // State Management
  final messages = <ChatMessage>[].obs;
  final isConnected = true.obs; // Always true with Supabase
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isWaitingForResponse = false.obs;
  final lastMessageId = ''.obs;
  final isUploadingImage = false.obs;

  // Session Management
  final _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  // UI Controllers
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final observer = ScrollObserver.sliverMulti();
  AdAccount? adAccountItem = AdAccount.fromJson({});
  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Supabase
  RealtimeChannel? _channel;

  // Getters
  AuthController get authController => _authController;
  StorageService get _storageService => Get.find<StorageService>();
  MessageDisplayController get _messageController =>
      Get.find<MessageDisplayController>();

  // Lifecycle Methods
  @override
  void onInit() {
    super.onInit();
    adAccountItem = _storageService.selectedAdAccount;
    _initializeSupabase();
    _loadMessages();
    // Add scroll listener for pagination
    // scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  // Resource Management
  void _disposeResources() {
    messageController.dispose();
    scrollController.dispose();
    _channel?.unsubscribe();
  }

  // Supabase Methods
  void _initializeSupabase() {
    // Subscribe to real-time updates
    _channel = Supabase.instance.client
        .channel('public')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'chat',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'session_id',
            value: _storageService.selectedAdAccount?.id ?? _sessionId,
          ),
          callback: (payload) {
            debugPrint('Received message from Supabase');
            final message = ChatMessage.fromJson(
                Map<String, dynamic>.from(payload.newRecord));
            // Remove messages with null id before adding the new message
            messages.removeWhere((msg) => msg.id == null);
            messages.add(message);

            if (message.message?.type != 'ai') {
              isWaitingForResponse.value = false;
            }
            update(['chat_messages']);
            _scrollToBottom();
          },
        )
        .subscribe(
      (status, [error]) {
        debugPrint('Subscription status: $status, error: $error');
      },
    );
  }

  Future<void> _loadMessages() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('chat')
          .select()
          .eq('session_id', _storageService.selectedAdAccount?.id ?? _sessionId)
          .order('created_at', ascending: false);

      final List<ChatMessage> loadedMessages =
          (response as List).map((msg) => ChatMessage.fromJson(msg)).toList();

      messages.value = loadedMessages.reversed.toList();
      _scrollToBottom();
    } catch (e) {
      debugPrint('Error loading messages: $e');
      _messageController.displayError('فشل في تحميل الرسائل');
    } finally {
      isLoading.value = false;
    }
  }

  String get webhookUrl => dotenv.env['WEBHOOK_URL'] ?? '';
  SnapValidTokenController get snapShotController =>
      Get.find<SnapValidTokenController>();

  // Function to send the POST request
  Future<void> sendWebhookData() async {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      _messageController.displayError('لا يمكن أن تكون الرسالة فارغة');
      return;
    } // Generate a unique message ID

    // Add user message to chat and clear input
    final chatMessage = ChatMessage(
      message: Message(
        type: 'user_local',
        content: text,
      ),
      sessionId: _sessionId,
      createdAt: DateTime.now(),
      adAccountId: adAccountItem?.id,
      organizationId: adAccountItem?.organizationId,
    );
    messages.add(chatMessage);
    messageController.clear();
    _scrollToBottom();

    // Set waiting state
    isWaitingForResponse.value = true;
    final Map<String, dynamic> data = {
      'name': 'Flutter App',
      'message': text,
      'session_id': _sessionId,
      'user_id': _storageService.getUser()?.id ?? '',
      'access_token': _storageService.snapTokenResponse?.accessToken ?? '',
      'refresh_token': _storageService.snapTokenResponse?.refreshToken ?? '',
      "client_id": _storageService.getAdsManager()?.clientId ?? '',
      'client_secret': _storageService.getAdsManager()?.clientSecret ?? '',
      'organization_id': adAccountItem?.organizationId ?? '',
      'ad_account': adAccountItem?.toJson() ?? {},
      "context_window_length": messages.length,
    };
    try {
      final dio = Dio();
      final response = await dio.post(
        webhookUrl,
        data: data,
        options: Options(
          headers: {
            'Access-Control-Allow-Origin': '*',
          },
        ),
      );

      if (response.statusCode != 200) {
        debugPrint(
            'Failed to send data. Status Code: ${response.statusCode}, Response: ${response.data}');
        isWaitingForResponse.value = false;
      }
    } catch (e) {
      debugPrint('Error sending webhook: $e');
      isWaitingForResponse.value = false;
    }
  }

  Future<void> sendMessage() async {
    sendWebhookData();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      observer.jumpToIndex(
        messages.length - 1,
        position: scrollController.position,
      );
    });
  }

  // Public Methods
  Future<void> refreshMessages() async {
    await _loadMessages();
  }

  void logout() {
    _channel?.unsubscribe();
    _authController.logout();
  }

  // Image Upload Methods
  Future<void> pickAndUploadImage() async {
    try {
      // Show image source selection dialog
      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) return;

      // Pick image
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        isUploadingImage.value = true;
        await _uploadImageToSupabase(pickedFile);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _messageController.displayError('فشل في اختيار الصورة: ${e.toString()}');
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Select Image Source',
          style: TextStyle(
            color: Get.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Get.theme.colorScheme.primary,
              ),
              title: Text(
                'Gallery',
                style: TextStyle(color: Get.theme.colorScheme.onSurface),
              ),
              onTap: () => Get.back(result: ImageSource.gallery),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Get.theme.colorScheme.primary,
              ),
              title: Text(
                'Camera',
                style: TextStyle(color: Get.theme.colorScheme.onSurface),
              ),
              onTap: () => Get.back(result: ImageSource.camera),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImageToSupabase(XFile imageFile) async {
    try {
      // Read image file as bytes
      final bytes = await imageFile.readAsBytes();
      final fileName =
          'chat_images/${_sessionId}/${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}'; // Upload to Supabase Storage
      await Supabase.instance.client.storage
          .from('chat-images')
          .uploadBinary(fileName, bytes);

      // Get public URL
      final imageUrl = Supabase.instance.client.storage
          .from('chat-images')
          .getPublicUrl(fileName);

      // Add image message to chat
      final chatMessage = ChatMessage(
        message: Message(
          type: 'user_image',
          content: imageUrl,
        ),
        createdAt: DateTime.now(),
      );

      messages.add(chatMessage);
      _scrollToBottom();

      // Send image to webhook (optional)
      await _sendImageToWebhook(imageUrl);

      _messageController.displaySuccess('تم رفع الصورة بنجاح');
    } catch (e) {
      debugPrint('Error uploading image: $e');
      _messageController.displayError('فشل في رفع الصورة: ${e.toString()}');
    }
  }

  Future<void> _sendImageToWebhook(String imageUrl) async {
    try {
      isWaitingForResponse.value = true;

      final Map<String, dynamic> data = {
        'name': 'Flutter App',
        'message': 'User shared an image',
        'image_url': imageUrl,
        'session_id': _sessionId,
        'user_id': _authController.currentUser.value?.id ?? '',
        'access_token': snapShotController.accessToken ?? '',
        'organization_id': snapShotController.currentToken?.organizationId ?? ""
      };

      final dio = Dio();
      final response = await dio.post(
        webhookUrl,
        data: data,
        options: Options(
          headers: {
            'Access-Control-Allow-Origin': '*',
          },
        ),
      );

      if (response.statusCode != 200) {
        debugPrint(
            'Failed to send image data. Status Code: ${response.statusCode}');
        isWaitingForResponse.value = false;
      }
    } catch (e) {
      debugPrint('Error sending image webhook: $e');
      isWaitingForResponse.value = false;
    }
  }
}
