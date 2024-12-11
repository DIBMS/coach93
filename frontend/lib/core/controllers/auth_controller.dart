import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.getToken();
    if (token != null) {
      try {
        final userData = await _authService.getUserProfile();
        user.value = User.fromJson(userData);
        isAuthenticated.value = true;
      } catch (e) {
        await logout();
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _authService.login(email, password);
      await _storage.setToken(response['access_token']);
      
      user.value = User.fromJson(response['user']);
      isAuthenticated.value = true;
      
      Get.offAllNamed('/home');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _authService.register(email, password);
      await _storage.setToken(response['access_token']);
      
      user.value = User.fromJson(response['user']);
      isAuthenticated.value = true;
      
      Get.offAllNamed('/home');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    user.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }

  bool get isTrainer => user.value?.role == 'trainer';
}
