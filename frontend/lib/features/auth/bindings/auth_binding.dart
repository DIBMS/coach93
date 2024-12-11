import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StorageService());
    Get.lazyPut(() => AuthService());
    Get.put(AuthController());
  }
}
