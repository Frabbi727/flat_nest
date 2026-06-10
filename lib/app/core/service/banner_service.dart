import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../model/banner_model.dart';
import '../cache/cache_manager.dart';
import '../../shared/widgets/banner_widget.dart';

class BannerService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final CacheManager _cacheManager = Get.find<CacheManager>();

  final Rx<BannerData?> activeBanner = Rx<BannerData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isDismissed = false.obs;
  
  // Track the ID of the banner we've already shown in this session
  int? _lastShownBannerIdInSession;

  Future<BannerService> init() async {
    await fetchActiveBanner();
    return this;
  }

  Future<void> fetchActiveBanner() async {
    try {
      isLoading.value = true;
      Get.log('BannerService: Fetching active banner...');
      
      final response = await _apiClient.get(path: ApiEndpoints.activeBanner);

      if (response.statusCode == 200) {
        final rawData = response.data;
        Map<String, dynamic> jsonData;
        if (rawData is Map) {
          jsonData = Map<String, dynamic>.from(rawData);
        } else if (rawData is String) {
          jsonData = jsonDecode(rawData) as Map<String, dynamic>;
        } else {
          return;
        }

        final bannerResponse = BannerResponse.fromJson(jsonData);
        if (bannerResponse.success && bannerResponse.data != null) {
          final banner = bannerResponse.data!;
          activeBanner.value = banner;
          
          final dismissedId = await _cacheManager.getLastDismissedBannerId();
          isDismissed.value = (dismissedId == banner.id);
          Get.log('BannerService: Banner loaded. ID: ${banner.id}, Dismissed: ${isDismissed.value}');
        }
      }
    } catch (e) {
      Get.log('BannerService: FETCH ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showBannerDialog() async {
    final currentId = activeBanner.value?.id;
    Get.log('BannerService: showBannerDialog attempt. shouldShowBanner: $shouldShowBanner, currentId: $currentId, lastShownInSession: $_lastShownBannerIdInSession');
    
    if (!shouldShowBanner || _lastShownBannerIdInSession == currentId) return;

    _lastShownBannerIdInSession = currentId;
    Get.log('BannerService: Triggering Get.dialog');
    
    await Get.dialog(
      const BannerDialog(),
      barrierDismissible: true,
      useSafeArea: true,
    );
  }

  Future<void> dismissBanner() async {
    Get.log('BannerService: dismissBanner called for ID: ${activeBanner.value?.id}');
    if (activeBanner.value != null) {
      await _cacheManager.saveLastDismissedBannerId(activeBanner.value!.id);
      isDismissed.value = true;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  bool get shouldShowBanner {
    final banner = activeBanner.value;
    final res = !isLoading.value && 
                banner != null && 
                !isDismissed.value &&
                banner.isActive;
                
    Get.log('BannerService status check: [loading=${isLoading.value}] [hasBanner=${banner != null}] [dismissed=${isDismissed.value}] [bannerActive=${banner?.isActive}] -> Result: $res');
    
    return res;
  }
}

