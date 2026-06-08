import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/guest_auth_sheet.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../controller/renter_home_controller.dart';
import '../../../../core/service/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/network/api_config.dart';
import '../../../../route/app_routes.dart';

class ProfilePlaceholderView extends GetView<RenterHomeController> {
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
              _MenuItem(t: t, icon: Icons.help_outline, label: 'Help & Support', onTap: () => _showHelpSheet(context, t)),
              const SizedBox(height: 12),
              _AppVersionText(t: t),
              const SizedBox(height: 12),
              _MenuItem(
                t: t,
                icon: Icons.logout,
                label: 'Logout',
                danger: true,
                onTap: () => _showLogoutConfirmation(context, t, auth),
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

  void _showHelpSheet(BuildContext context, FlatNestTheme t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: t.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _HelpSheet(t: t),
    );
  }

  Future<void> _showLogoutConfirmation(
      BuildContext context, FlatNestTheme t, AuthService auth) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout?',
          style: TextStyle(color: t.ink, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: t.inkMid, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: t.inkSoft)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Logout', style: TextStyle(color: t.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await auth.logout();
    Get.offAllNamed(Routes.login);
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

// ── Help sheet ────────────────────────────────────────────────────────────────

class _HelpSheet extends StatelessWidget {
  final FlatNestTheme t;
  const _HelpSheet({required this.t});

  static const _email = 'flatnesthelp@gmail.com';

  Future<void> _launchEmail() async {
    final uri = Uri(scheme: 'mailto', path: _email);
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: t.inkFaint, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Icon(Icons.help_outline_rounded, color: t.primary, size: 22),
              const SizedBox(width: 10),
              Text('Help & Support', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
            ]),
            const SizedBox(height: 8),
            Text(
              'Have a question or need help? Send us an email and we\'ll get back to you.',
              style: TextStyle(fontSize: 13, color: t.inkMid, height: 1.5),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _launchEmail,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: t.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: t.primary.withValues(alpha: 0.3)),
                ),
                child: Row(children: [
                  Icon(Icons.email_outlined, size: 18, color: t.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _email,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.primary),
                    ),
                  ),
                  Icon(Icons.open_in_new_rounded, size: 16, color: t.primary.withValues(alpha: 0.6)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
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

class _AppVersionText extends StatelessWidget {
  final FlatNestTheme t;
  const _AppVersionText({required this.t});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snap) {
        final version = snap.data != null
            ? 'Version ${snap.data!.version} (${snap.data!.buildNumber})'
            : '';
        return Text(
          version,
          style: TextStyle(fontSize: 12, color: t.inkSoft),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
