import 'package:get/get.dart';
import '../controllers/trainer_controller.dart';
import '../../../core/services/trainer_service.dart';

class TrainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainerService());
    Get.lazyPut(() => TrainerController());
  }
}
