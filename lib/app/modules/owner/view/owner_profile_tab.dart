part of 'owner_home_view.dart';

// ── Profile tab ───────────────────────────────────────────────────────────────

class _ProfileTab extends GetView<OwnerController> {
  final FlatNestTheme t;
  const _ProfileTab({required this.t});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthService>().currentUser;

    return Scaffold(
      backgroundColor: t.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
              child: Center(
                child: Text(
                  controller.ownerInitials,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: t.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? controller.ownerName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.ink)),
            const SizedBox(height: 4),
            Text(user?.email ?? '', style: TextStyle(fontSize: 13, color: t.inkMid)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: t.primarySoft, borderRadius: BorderRadius.circular(20)),
              child: Text('Owner', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.primaryInk)),
            ),
            const SizedBox(height: 32),
            _OwnerMenuItem(t: t, icon: Icons.person_outline, label: 'Edit profile'),
            _OwnerMenuItem(t: t, icon: Icons.notifications_outlined, label: 'Notifications'),
            _OwnerMenuItem(t: t, icon: Icons.lock_outline, label: 'Privacy & Security'),
            _OwnerMenuItem(t: t, icon: Icons.help_outline, label: 'Help & Support', onTap: () => _showHelpSheet(context, t)),
            const SizedBox(height: 12),
            _AppVersionText(t: t),
            const SizedBox(height: 12),
            _OwnerMenuItem(t: t, icon: Icons.logout, label: 'Logout', danger: true, onTap: () => _showLogoutConfirmation(context, t)),
            Divider(height: 28, color: t.borderSoft),
            _OwnerMenuItem(
              t: t,
              icon: Icons.delete_forever_outlined,
              label: 'Delete Account',
              danger: true,
              onTap: () => _showDeleteConfirmation(context, t),
            ),
          ],
        ),
      ),
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

  Future<void> _showLogoutConfirmation(BuildContext context, FlatNestTheme t) async {
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
    await controller.logout();
  }

  Future<void> _showDeleteConfirmation(BuildContext context, FlatNestTheme t) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Account?', style: TextStyle(color: t.error, fontWeight: FontWeight.w700, fontSize: 18)),
        content: Text(
          'Are you sure? This will permanently delete your account, all listings, and all data. This cannot be undone.',
          style: TextStyle(color: t.inkMid, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text('Cancel', style: TextStyle(color: t.inkSoft))),
          TextButton(onPressed: () => Get.back(result: true), child: Text('Delete', style: TextStyle(color: t.error, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirmed != true) return;

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    final result = await controller.deleteAccount();
    Get.back();

    if (result == true) {
      Get.offAllNamed(Routes.login);
      Get.snackbar('Account Deleted', 'Your account has been permanently deleted.',
          duration: const Duration(seconds: 4), snackPosition: SnackPosition.BOTTOM);
    } else if (result == null) {
      Get.offAllNamed(Routes.login);
      Get.snackbar('Session Expired', 'Please log in again to delete your account.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to delete account. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
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

// ── Owner menu item ───────────────────────────────────────────────────────────

class _OwnerMenuItem extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String label;
  final bool danger;
  final VoidCallback? onTap;

  const _OwnerMenuItem({
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
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: danger ? t.error : t.ink)),
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
