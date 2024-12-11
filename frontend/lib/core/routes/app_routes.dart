import 'package:get/get.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/trainers/screens/trainer_list_screen.dart';
import '../../features/trainers/screens/trainer_detail_screen.dart';
import '../../features/trainers/bindings/trainer_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/trainers',
      page: () => TrainerListScreen(),
      binding: TrainerBinding(),
    ),
    GetPage(
      name: '/trainers/:id',
      page: () {
        final trainerId = Get.parameters['id']!;
        return TrainerDetailScreen(trainerId: trainerId);
      },
      binding: TrainerBinding(),
    ),
  ];

  static const INITIAL = '/login';
}
