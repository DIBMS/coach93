import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_controller.dart';
import '../models/trainer_profile.dart';
import 'trainer_detail_screen.dart';

class TrainerListScreen extends StatelessWidget {
  final TrainerController controller = Get.put(TrainerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Trainer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => controller.getCurrentLocation(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLocationStatus(),
          _buildSearchBar(),
          Expanded(
            child: _buildTrainerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Obx(() {
      if (controller.isLoadingLocation.value) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.error.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            controller.error.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (controller.currentPosition.value != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Showing trainers near you',
            style: TextStyle(color: Colors.green[700]),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search trainers...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildTrainerList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.error.value,
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                onPressed: controller.fetchTrainers,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.trainers.isEmpty) {
        return const Center(
          child: Text('No trainers found'),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchTrainers,
        child: ListView.builder(
          itemCount: controller.trainers.length,
          itemBuilder: (context, index) {
            return _buildTrainerCard(controller.trainers[index]);
          },
        ),
      );
    });
  }

  Widget _buildTrainerCard(TrainerProfile trainer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(trainer.userEmail[0].toUpperCase()),
        ),
        title: Text(trainer.userEmail),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trainer.specializations.join(', ')),
            Text('\$${trainer.hourlyRate}/hour'),
          ],
        ),
        trailing: trainer.isVerified
            ? const Icon(Icons.verified, color: Colors.blue)
            : null,
        onTap: () => Get.to(() => TrainerDetailScreen(trainerId: trainer.id)),
      ),
    );
  }
}
