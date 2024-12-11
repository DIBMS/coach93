import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../config/env_config.dart';
import 'storage_service.dart';

class ApiService extends GetxService {
  late final Dio dio;
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    dio = Dio(BaseOptions(
      baseUrl: EnvConfig().apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired or invalid
          Get.offAllNamed('/login');
        }
        return handler.next(error);
      },
    ));
  }
}
