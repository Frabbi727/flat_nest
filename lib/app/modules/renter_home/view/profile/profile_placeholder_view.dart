import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../../core/service/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/network/api_config.dart';
import '../../../../route/app_routes.dart';

class ProfilePlaceholderView extends StatelessWidget {
  const ProfilePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    final auth = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: t.bg,
      body: Obx(() {
        final user = auth.currentUserRx.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              _buildAvatar(t, user?.avatarUrl, user?.name ?? 'U'),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.ink),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 13, color: t.inkMid),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: t.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user?.isOwner == true ? 'Owner' : 'Renter',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: t.primaryInk,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Menu items
              _MenuItem(t: t, icon: Icons.person_outline, label: 'Edit profile'),
              _MenuItem(t: t, icon: Icons.notifications_outlined, label: 'Notifications'),
              _MenuItem(t: t, icon: Icons.lock_outline, label: 'Privacy & Security'),
              _MenuItem(t: t, icon: Icons.help_outline, label: 'Help & Support'),
              const SizedBox(height: 12),
              _MenuItem(
                t: t,
                icon: Icons.logout,
                label: 'Logout',
                danger: true,
                onTap: () async {
                  await auth.logout();
                  Get.offAllNamed(Routes.login);
                },
              ),
              Divider(height: 28, color: t.borderSoft),
              _MenuItem(
                t: t,
                icon: Icons.delete_forever_outlined,
                label: 'Delete Account',
                danger: true,
                onTap: () => _showDeleteConfirmation(context, t, auth),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, FlatNestTheme t, AuthService auth) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account?',
          style: TextStyle(color: t.error, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          'Are you sure? This will permanently delete your account, all listings, and all data. This cannot be undone.',
          style: TextStyle(color: t.inkMid, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: t.inkSoft)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Delete', style: TextStyle(color: t.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final result = await auth.deleteAccount();
    Get.back(); // close loading

    if (result == true) {
      Get.offAllNamed(Routes.login);
      Get.snackbar(
        'Account Deleted',
        'Your account has been permanently deleted.',
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (result == null) {
      Get.offAllNamed(Routes.login);
      Get.snackbar(
        'Session Expired',
        'Please log in again to delete your account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  Widget _buildAvatar(FlatNestTheme t, String? avatarUrl, String name) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      final url = ApiConfig.resolveAvatarUrl(avatarUrl);
      debugPrint('[Profile] avatarUrl raw: $avatarUrl');
      debugPrint('[Profile] avatarUrl resolved: $url');
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: 88,
          height: 88,
          fit: BoxFit.cover,
          placeholder: (_, __) => _initialsAvatar(t, name),
          errorWidget: (_, __, ___) => _initialsAvatar(t, name),
        ),
      );
    }
    debugPrint('[Profile] avatarUrl is null — showing initials');
    return _initialsAvatar(t, name);
  }

  Widget _initialsAvatar(FlatNestTheme t, String name) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: t.primary),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _MenuItem extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String label;
  final bool danger;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.t,
    required this.icon,
    required this.label,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.borderSoft),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: danger ? t.error : t.inkMid),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: danger ? t.error : t.ink,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 18, color: t.inkFaint),
          ],
        ),
      ),
    );
  }
}
