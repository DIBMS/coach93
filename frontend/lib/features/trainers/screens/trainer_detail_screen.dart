import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_controller.dart';
import '../models/trainer_profile.dart';

class TrainerDetailScreen extends StatelessWidget {
  final String trainerId;
  final TrainerController controller = Get.find<TrainerController>();

  TrainerDetailScreen({Key? key, required this.trainerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Profile'),
      ),
      body: FutureBuilder<TrainerProfile?>(
        future: controller.getTrainerProfile(trainerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.getTrainerProfile(trainerId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final trainer = snapshot.data;
          if (trainer == null) {
            return const Center(child: Text('Trainer not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrainerHeader(trainer),
                const SizedBox(height: 24),
                _buildInfoSection('About', trainer.bio ?? 'No bio available'),
                const SizedBox(height: 16),
                _buildSpecializations(trainer),
                const SizedBox(height: 16),
                _buildCertifications(trainer),
                const SizedBox(height: 16),
                _buildPricingSection(trainer),
                const SizedBox(height: 24),
                _buildBookingButton(trainer),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrainerHeader(TrainerProfile trainer) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            trainer.userEmail[0].toUpperCase(),
            style: const TextStyle(fontSize: 32),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    trainer.userEmail,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (trainer.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: Colors.blue),
                  ],
                ],
              ),
              if (trainer.yearsOfExperience != null)
                Text(
                  '${trainer.yearsOfExperience} years of experience',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }

  Widget _buildSpecializations(TrainerProfile trainer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specializations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: trainer.specializations.map((spec) {
            return Chip(
              label: Text(spec),
              backgroundColor: Colors.blue[100],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCertifications(TrainerProfile trainer) {
    if (trainer.certifications == null || trainer.certifications!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Certifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: trainer.certifications!
              .map((cert) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(cert),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPricingSection(TrainerProfile trainer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hourly Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${trainer.hourlyRate}/hour',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton(TrainerProfile trainer) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: trainer.isAvailableForHire
            ? () {
                // Navigate to booking screen
                Get.toNamed('/book-trainer', arguments: trainer);
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          trainer.isAvailableForHire ? 'Book a Session' : 'Not Available',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
