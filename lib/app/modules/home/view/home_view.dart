import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome Home!'),
      ),
    );
  }
}
