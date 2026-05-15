import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/network/resource.dart';
import '../../../core/service/auth_service.dart';
import '../model/chat_model.dart';
import '../repository/chat_repository.dart';

class ChatController extends BaseController {
  final ChatRepository _chatRepository;
  final AuthService _authService = Get.find<AuthService>();

  ChatController({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  final chats = <ChatModel>[].obs;
  final messages = <ChatMessageModel>[].obs;
  final selectedChat = Rxn<ChatModel>();
  final messageController = TextEditingController();
  final isSendingMessage = false.obs;

  String get myUserId => _authService.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  @override
  void onClose() {
    messageController.dispose();
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
    Get.toNamed('/chat/detail');
    await fetchMessages(chat.id);
  }

  Future<void> fetchMessages(String chatId) async {
    final result = await _chatRepository.getMessages(chatId);
    if (result case Success(data: final data?)) {
      messages.value = data;
    }
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
    }
  }

  int get totalUnread => chats.fold(0, (sum, c) => sum + c.unreadCount);
}
