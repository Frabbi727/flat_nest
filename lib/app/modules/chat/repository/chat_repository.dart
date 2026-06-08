import 'package:falt_nest/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/api_response.dart';
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

  Future<Resource<({ChatStatus status, List<ChatMessageModel> messages})>> getMessages(String chatId) async {
    try {
      final response = await apiClient.get(path: ApiEndpoints.chatMessages(chatId));
      
      final body = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (j) {
          final map = j as Map<String, dynamic>;
          final statusStr = map['status'] as String?;
          final msgsRaw = map['messages'] as List? ?? [];
          return (
            status: ChatModel.statusFromJson(statusStr),
            messages: msgsRaw.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList(),
          );
        },
      );

      if (body.success && body.data != null) {
        return Success(data: body.data!, statusCode: response.statusCode ?? 200);
      }
      return Error(body.errorMessage, statusCode: response.statusCode ?? 500);
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

  Future<Resource<bool>> acceptChatRequest(String chatId) async {
    try {
      final response = await apiClient.post(path: ApiEndpoints.chatAccept(chatId));
      return Success(data: true, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }

  Future<Resource<bool>> rejectChatRequest(String chatId) async {
    try {
      final response = await apiClient.post(path: ApiEndpoints.chatReject(chatId));
      return Success(data: true, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(parseError(e), statusCode: parseStatusCode(e));
    }
  }
}
