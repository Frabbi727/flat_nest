import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../../../core/service/auth_service.dart';
import '../../../route/app_routes.dart';

class ProfilePlaceholderView extends StatelessWidget {
  const ProfilePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    final auth = Get.find<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
                child: Center(
                  child: Text(
                    _initials(user?.name ?? 'U'),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: t.primary,
                    ),
                  ),
                ),
              ),
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
            ],
          ),
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
