import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../model/chat_model.dart';

class ChatRepository extends BaseRepository {
  ChatRepository({required super.apiClient});

  Future<Resource<List<ChatModel>>> getChats() async {
    try {
      final response = await apiClient.get('/chats');
      final data = (response.data['data'] as List<dynamic>)
          .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: data, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<Map<String, dynamic>>> startChat({
    required String listingId,
    required String initialMessage,
  }) async {
    try {
      final response = await apiClient.post('/chats', data: {
        'listing_id': listingId,
        'initial_message': initialMessage,
      });
      return Success(data: response.data as Map<String, dynamic>, statusCode: response.statusCode ?? 201);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<List<ChatMessageModel>>> getMessages(String chatId) async {
    try {
      final response = await apiClient.get('/chats/$chatId/messages');
      final data = (response.data['messages'] as List<dynamic>)
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: data, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<ChatMessageModel>> sendMessage(String chatId, String text) async {
    try {
      final response = await apiClient.post('/chats/$chatId/messages', data: {'text': text});
      return Success(
        data: ChatMessageModel.fromJson(response.data as Map<String, dynamic>),
        statusCode: response.statusCode ?? 201,
      );
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
