import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../trainers/screens/trainer_list_screen.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../trainers/services/trainer_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  HomeScreen({super.key}) {
    // Initialize trainer service
    Get.put(TrainerService());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coach93'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _authController.logout(),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.person), text: 'Trainers'),
              Tab(icon: Icon(Icons.fitness_center), text: 'Classes'),
              Tab(icon: Icon(Icons.account_circle), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomeTab(),
            TrainerListScreen(),
            _buildClassesTab(),
            _buildProfileTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Coach93!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildFeatureCard(
            icon: Icons.person,
            title: 'Find a Trainer',
            description: 'Browse through our list of certified trainers and find the perfect match for your fitness goals.',
            onTap: () => Get.toNamed('/trainers'),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: Icons.fitness_center,
            title: 'Join a Class',
            description: 'Explore group fitness classes and join the ones that match your schedule.',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildClassesTab() {
    return const Center(
      child: Text('Classes Coming Soon'),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text('Profile Coming Soon'),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
