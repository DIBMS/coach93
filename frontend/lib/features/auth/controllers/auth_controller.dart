import 'package:get/get.dart';
import '../../../core/models/user.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final token = await _storageService.getToken();
      if (token != null) {
        final userData = await _authService.getUserProfile();
        currentUser.value = User.fromJson(userData);
      }
    } catch (e) {
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _authService.login(email, password);
      await _storageService.setToken(response['token']);
      currentUser.value = User.fromJson(response['user']);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _authService.register(email, password);
      await _storageService.setToken(response['token']);
      currentUser.value = User.fromJson(response['user']);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }

  bool get isAuthenticated => currentUser.value != null;
}
