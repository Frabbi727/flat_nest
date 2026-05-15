import '../../../core/base/base_repository.dart';
import '../model/user_model.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({required super.apiClient});

  Future<UserModel> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // In real app:
    // final response = await apiClient.post('/login', data: {'email': email, 'password': password});
    // return UserModel.fromJson(response.data['user']);
    
    if (email == 'test@example.com' && password == 'password') {
      return const UserModel(id: '1', email: 'test@example.com', name: 'Test User');
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
