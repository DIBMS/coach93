import 'package:get/get.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Login failed');
      }

      return response.data;
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _apiService.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }

      // Ensure we return a properly structured response
      return {
        'token': response.data['token'] ?? '',
        'user': response.data['user'] ?? {
          'id': '',
          'email': email,
          'role': null,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      };
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.dio.get('/users/profile');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }
}
