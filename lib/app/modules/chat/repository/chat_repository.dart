import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../model/chat_model.dart';

class ChatRepository extends BaseRepository {
  ChatRepository({required super.apiClient});

  Future<Resource<List<ChatModel>>> getChats() async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.chats);
      return parseListResponse(response, ChatModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<Map<String, dynamic>>> startChat({
    required String listingId,
    required String initialMessage,
  }) async {
    try {
      final response = await apiClient.post(path: ApiEndpoints.chats, data: {
        'listing_id': listingId,
        'initial_message': initialMessage,
      });
      return parseResponse<Map<String, dynamic>>(response, (j) => j);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<List<ChatMessageModel>>> getMessages(String chatId) async {
    try {
      final response =
          await apiClient.get(path: ApiEndpoints.chatMessages(chatId));
      return parseListResponse(response, ChatMessageModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<ChatMessageModel>> sendMessage(
      String chatId, String text) async {
    try {
      final response = await apiClient.post(
          path: ApiEndpoints.chatMessages(chatId), data: {'text': text});
      return parseResponse(response, ChatMessageModel.fromJson);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
