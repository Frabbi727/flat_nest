import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../../../core/service/notification_service.dart';
import '../model/chat_model.dart';
import '../repository/chat_repository.dart';

class ChatController extends BaseController {
  final ChatRepository _chatRepository;
  final AuthService _authService = Get.find<AuthService>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  ChatController({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  final chats = <ChatModel>[].obs;
  final messages = <ChatMessageModel>[].obs;
  final selectedChat = Rxn<ChatModel>();
  late final TextEditingController messageController;
  final scrollController = ScrollController();
  final isSendingMessage = false.obs;
  final isMessagesLoading = false.obs;

  String get myUserId => _authService.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();
    fetchChats();
    _initRealtime();
  }

  void _initRealtime() {
    // Placeholder for WebSocket/Pusher initialization
    // For now, we sync with NotificationService to refresh when a push arrives
    ever(_notificationService.unreadCount, (_) {
      if (Get.currentRoute == '/chat/detail' && selectedChat.value != null) {
        fetchMessages(selectedChat.value!.id);
      }
      fetchChats();
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchChats() async {
    showLoading();
    final result = await _chatRepository.getChats();
    hideLoading();

    switch (result) {
      case Success(data: final data?):
        chats.value = data;
      case Success():
        chats.clear();
      case Error(message: final msg):
        showError(msg);
    }
  }

  Future<void> openChat(ChatModel chat) async {
    selectedChat.value = chat;
    _markLocalAsRead(chat.id);
    Get.toNamed('/chat/detail');
    await fetchMessages(chat.id);
  }

  void _markLocalAsRead(String chatId) {
    final index = chats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      chats[index] = chats[index].copyWith(unreadCount: 0);
    }
  }

  Future<Map<String, dynamic>?> startChat({
    required String listingId,
    required String initialMessage,
  }) async {
    final result = await _chatRepository.startChat(
      listingId: listingId,
      initialMessage: initialMessage,
    );

    if (result case Success(data: final data?)) {
      await fetchChats();
      return data;
    } else if (result case Error(message: final msg)) {
      showError(msg);
      return null;
    }
    return null;
  }

  Future<void> fetchMessages(String chatId) async {
    isMessagesLoading.value = true;
    final result = await _chatRepository.getMessages(chatId);
    isMessagesLoading.value = false;
    if (result case Success(data: final data?)) {
      messages.value = data.messages;
      _updateLocalStatus(data.status);
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> acceptRequest() async {
    if (selectedChat.value == null) return;
    showLoading();
    final result = await _chatRepository.acceptChatRequest(selectedChat.value!.id);
    hideLoading();
    if (result case Success(data: final status?)) {
      _updateLocalStatus(status);
    } else if (result case Error(message: final msg)) {
      showError(msg);
    }
  }

  Future<void> rejectRequest() async {
    if (selectedChat.value == null) return;
    showLoading();
    final result = await _chatRepository.rejectChatRequest(selectedChat.value!.id);
    hideLoading();
    if (result case Success(data: final status?)) {
      _updateLocalStatus(status);
    } else if (result case Error(message: final msg)) {
      showError(msg);
    }
  }

  void _updateLocalStatus(ChatStatus newStatus) {
    if (selectedChat.value == null) return;
    final updated = selectedChat.value!.copyWith(status: newStatus);
    selectedChat.value = updated;
    // Update in the list as well
    final index = chats.indexWhere((c) => c.id == updated.id);
    if (index != -1) chats[index] = updated;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || selectedChat.value == null) return;

    isSendingMessage.value = true;
    messageController.clear();
    final result = await _chatRepository.sendMessage(selectedChat.value!.id, text);
    isSendingMessage.value = false;

    if (result case Success(data: final msg?)) {
      messages.add(msg);
      scrollToBottom();
    }
  }

  int get totalUnread => chats.fold(0, (sum, c) => sum + c.unreadCount);

  ChatModel? findExistingChat(String listingId) {
    return chats.firstWhereOrNull((c) => c.listing.id == listingId);
  }
}
