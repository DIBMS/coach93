import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/trainer_profile.dart';
import '../services/trainer_service.dart';

class TrainerController extends GetxController {
  final TrainerService _trainerService = Get.find<TrainerService>();
  
  final RxList<TrainerProfile> trainers = <TrainerProfile>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  // For location-based features
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLoadingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainers();
    getCurrentLocation();
  }

  Future<void> fetchTrainers() async {
    try {
      isLoading.value = true;
      error.value = '';
      trainers.value = await _trainerService.getAllTrainers();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyTrainers() async {
    if (currentPosition.value == null) {
      error.value = 'Location not available';
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';
      trainers.value = await _trainerService.getNearbyTrainers(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      error.value = '';

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          error.value = 'Location permission denied';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        error.value = 'Location permissions are permanently denied';
        return;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition();
      currentPosition.value = position;
      
      // Fetch nearby trainers once we have the location
      await fetchNearbyTrainers();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<TrainerProfile?> getTrainerProfile(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      return await _trainerService.getTrainerProfile(id);
    } catch (e) {
      error.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTrainerProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _trainerService.createTrainerProfile(data);
      await fetchTrainers();
      Get.back(); // Return to previous screen
      Get.snackbar('Success', 'Trainer profile created successfully');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTrainerProfile(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _trainerService.updateTrainerProfile(id, data);
      await fetchTrainers();
      Get.back(); // Return to previous screen
      Get.snackbar('Success', 'Trainer profile updated successfully');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }
}
