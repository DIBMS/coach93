import 'package:get/get.dart';
import '../models/trainer.dart';
import 'api_service.dart';

class TrainerService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<dynamic>> getTrainers() async {
    try {
      final response = await _apiService.dio.get('/trainers');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get trainers: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getTrainerById(String id) async {
    try {
      final response = await _apiService.dio.get('/trainers/$id');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get trainer: ${e.toString()}');
    }
  }
}
