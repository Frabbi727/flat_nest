import 'package:get/get.dart';

import '../modules/auth/binding/auth_binding.dart';
import '../modules/auth/view/login_view.dart';
import '../modules/chat/binding/chat_binding.dart';
import '../modules/chat/view/chat_detail_view.dart';
import '../modules/chat/view/chat_list_view.dart';
import '../modules/notification/binding/notification_binding.dart';
import '../modules/notification/view/notification_view.dart';
import '../modules/home/binding/home_binding.dart';
import '../modules/home/view/home_view.dart';
import '../modules/onboarding/binding/onboarding_binding.dart';
import '../modules/onboarding/view/onboarding_view.dart';
import '../modules/owner/binding/access_requests_binding.dart';
import '../modules/owner/binding/create_listing_binding.dart';
import '../modules/owner/binding/owner_binding.dart';
import '../modules/owner/view/create_listing_view.dart';
import '../modules/owner/view/owner_access_requests_view.dart';
import '../modules/owner/view/owner_home_view.dart';
import '../modules/register/binding/register_binding.dart';
import '../modules/register/view/register_view.dart';
import '../modules/renter_home/binding/listing_detail_binding.dart';
import '../modules/renter_home/binding/renter_home_binding.dart';
import '../modules/renter_home/view/listing/listing_detail_view.dart';
import '../modules/renter_home/view/renter_home_view.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/splash/view/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // Renter
    GetPage(
      name: Routes.renterHome,
      page: () => const RenterHomeView(),
      binding: RenterHomeBinding(),
    ),
    GetPage(
      name: Routes.listingDetail,
      page: () => const ListingDetailView(),
      binding: ListingDetailBinding(),
    ),
    // Owner
    GetPage(
      name: Routes.ownerHome,
      page: () => const OwnerHomeView(),
      binding: OwnerBinding(),
    ),
    GetPage(
      name: Routes.ownerAccessRequests,
      page: () => const OwnerAccessRequestsView(),
      binding: OwnerAccessRequestsBinding(),
    ),
    GetPage(
      name: Routes.createListing,
      page: () => const CreateListingView(),
      binding: CreateListingBinding(),
    ),
    // Notifications
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    // Chat
    GetPage(
      name: Routes.chatList,
      page: () => const ChatListView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.chatDetail,
      page: () => const ChatDetailView(),
      binding: ChatBinding(),
    ),
  ];
}
