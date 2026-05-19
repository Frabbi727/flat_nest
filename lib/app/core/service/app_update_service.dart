import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/app_version_model.dart';
import '../../theme/flat_nest_theme.dart';

class AppUpdateService {
  AppUpdateService._();

  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.falt_nest';
  static const _appStoreUrl =
      'https://apps.apple.com/app/id0000000000'; // replace with real App Store ID

  static Future<void> checkForUpdate() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();

      if (!doc.exists || doc.data() == null) return;

      final model = AppVersionModel.fromJson(doc.data()!);

      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final remoteBuild = Platform.isIOS
          ? (model.iosBuildNumber ?? 0)
          : (model.androidBuildNumber ?? 0);

      if (remoteBuild <= currentBuild) return;

      final isHard = model.updateType == 'HARD_UPDATE';
      final isSoft = model.updateType == 'SOFT_UPDATE';
      if (!isHard && !isSoft) return;

      _showUpdateDialog(isHardUpdate: isHard);
    } catch (_) {}
  }

  static void _showUpdateDialog({required bool isHardUpdate}) {
    final t = Get.context != null
        ? Theme.of(Get.context!).extension<FlatNestTheme>()
        : null;

    Get.dialog(
      PopScope(
        canPop: !isHardUpdate,
        child: AlertDialog(
          backgroundColor: t?.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Update Available',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: t?.ink,
            ),
          ),
          content: Text(
            isHardUpdate
                ? 'A required update is available. Please update FlatNest to continue.'
                : 'A new version of FlatNest is available. Update for the latest features and fixes.',
            style: TextStyle(fontSize: 14, color: t?.inkMid),
          ),
          actions: [
            if (!isHardUpdate)
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'Later',
                  style: TextStyle(color: t?.inkSoft, fontSize: 14),
                ),
              ),
            TextButton(
              onPressed: _openStore,
              child: Text(
                'Update Now',
                style: TextStyle(
                  color: t?.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: !isHardUpdate,
    );
  }

  static Future<void> _openStore() async {
    final url = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
