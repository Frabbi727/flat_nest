import 'package:falt_nest_mobile_app/app/core/network/api_endpoints.dart';

import '../../../core/base/base_repository.dart';
import '../../../core/network/resource.dart';
import '../model/user_model.dart';

class AuthRepository extends BaseRepository {
  AuthRepository({required super.apiClient});

  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return Success(data: AuthResponse.fromJson(response.data), statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await apiClient.post(
        path: ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );
      return Success(data: AuthResponse.fromJson(response.data), statusCode: response.statusCode ?? 201);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<Map<String, dynamic>>> saveDetails({
    required String role,
    required String dateOfBirth,
  }) async {
    try {
      final response = await apiClient.patch(
        path: ApiEndpoints.registerDetails,
        data: {'role': role, 'date_of_birth': dateOfBirth},
      );
      return Success(data: response.data as Map<String, dynamic>, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }

  Future<Resource<Map<String, dynamic>>> logout() async {
    try {
      final response = await apiClient.post(path: ApiEndpoints.logout);
      return Success(data: response.data as Map<String, dynamic>, statusCode: response.statusCode ?? 200);
    } catch (e) {
      return Error(e.toString(), statusCode: 500);
    }
  }
}
