import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/trainer_profile.dart';
import '../../../core/services/api_service.dart';

class TrainerService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<TrainerProfile>> getAllTrainers() async {
    try {
      final response = await _apiService.dio.get('/trainers');
      return (response.data as List)
          .map((json) => TrainerProfile.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<TrainerProfile>> getNearbyTrainers(
      double latitude, double longitude, {double radius = 10}) async {
    try {
      final response = await _apiService.dio.get(
        '/trainers/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        },
      );
      return (response.data as List)
          .map((json) => TrainerProfile.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TrainerProfile> getTrainerProfile(String id) async {
    try {
      final response = await _apiService.dio.get('/trainers/$id');
      return TrainerProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TrainerProfile> createTrainerProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post('/trainers', data: data);
      return TrainerProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TrainerProfile> updateTrainerProfile(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.put('/trainers/$id', data: data);
      return TrainerProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 404) {
      return Exception('Trainer not found');
    }
    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception('Connection timeout. Please try again.');
    }
    return Exception(e.response?.data?['message'] ?? 'An error occurred');
  }
}
