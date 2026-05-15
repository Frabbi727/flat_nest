import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../model/user_model.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({required super.apiClient});

  Future<Resource<UserModel>> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In real app:
      // final response = await apiClient.post('/login', data: {'email': email, 'password': password});
      // return Success(UserModel.fromJson(response.data['user']));
      
      if (email == 'test@example.com' && password == 'password') {
        return const Success(data: UserModel(id: '1', email: 'test@example.com', name: 'Test User'), statusCode: 200);
      } else {
        return const Error('Invalid credentials', statusCode: 401);
      }
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
