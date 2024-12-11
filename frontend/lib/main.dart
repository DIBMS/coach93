import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_routes.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/storage_service.dart';
import 'core/config/env_config.dart';
import 'features/trainers/services/trainer_service.dart';
import 'features/auth/bindings/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment
  const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  EnvConfig().setEnvironment(
    environment == 'prod' ? Environment.prod : Environment.dev
  );
  
  // Initialize services
  Get.put(StorageService());
  Get.put(ApiService());
  Get.put(AuthService());
  Get.put(TrainerService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Coach93',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.INITIAL,
      getPages: AppRoutes.routes,
      initialBinding: AuthBinding(),
      defaultTransition: Transition.fade,
    );
  }
}
