import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
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
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome Home!'),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout?', style: TextStyle(color: t.ink, fontWeight: FontWeight.w700, fontSize: 18)),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: t.inkMid, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text('Cancel', style: TextStyle(color: t.inkSoft))),
          TextButton(onPressed: () => Get.back(result: true), child: Text('Logout', style: TextStyle(color: t.error, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirmed != true) return;
    controller.logout();
  }
}
