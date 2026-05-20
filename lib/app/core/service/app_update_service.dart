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
      'https://play.google.com/store/apps/details?id=com.fzrabbironto.flatnest.app';
  static const _appStoreUrl =
      'https://apps.apple.com/app/id0000000000'; // replace with real App Store ID

  static Future<void> checkForUpdate() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('flat_nest_app_version')
          .limit(1)
          .get();

      debugPrint('[AppUpdate] docs found: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        debugPrint('[AppUpdate] No version document found in Firestore.');
        return;
      }

      final rawData = snapshot.docs.first.data();
      debugPrint('[AppUpdate] Firestore raw data: $rawData');

      final model = AppVersionModel.fromJson(rawData);
      debugPrint('[AppUpdate] androidBuildNumber: ${model.androidBuildNumber}');
      debugPrint('[AppUpdate] iosBuildNumber: ${model.iosBuildNumber}');
      debugPrint('[AppUpdate] update_type: ${model.updateType}');

      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
      debugPrint('[AppUpdate] currentBuild: $currentBuild');

      final remoteBuild = Platform.isIOS
          ? (model.iosBuildNumber ?? 0)
          : (model.androidBuildNumber ?? 0);
      debugPrint('[AppUpdate] remoteBuild: $remoteBuild');

      if (remoteBuild <= currentBuild) return;

      // Default to SOFT_UPDATE when update_type is missing/empty
      final isHard = model.updateType == 'HARD_UPDATE';
      final isNone = model.updateType == 'NONE';
      if (isNone) return;

      debugPrint('[AppUpdate] showing dialog — isHardUpdate: $isHard');
      _showUpdateDialog(isHardUpdate: isHard);
    } catch (e) {
      debugPrint('[AppUpdate] ERROR: $e');
    }
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
