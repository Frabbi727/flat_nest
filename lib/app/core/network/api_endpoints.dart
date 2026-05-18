class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────x────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String registerDetails = '/auth/register/details';
  static const String registerAvatar = '/auth/register/avatar';
  static const String refreshToken = '/auth/refresh';
  static const String googleSignIn = '/auth/google';
  static const String logout = '/auth/logout';

  // ── Listings ──────────────────────────────────────────────────────────────
  static const String listings = '/listings';
  static const String nearbyListings = '/listings/nearby';
  static String listing(String id) => '/listings/$id';
  static String listingPhotos(String id) => '/listings/$id/photos';
  static String listingLocation(String id) => '/listings/$id/location';
  static String listingSubmit(String id) => '/listings/$id/submit';
  static String listingMarkRented(String id) => '/listings/$id/mark-rented';
  static String listingOwnerInfo(String id) => '/listings/$id/owner-info';

  // ── Owner ─────────────────────────────────────────────────────────────────
  static const String ownerListings = '/owner/listings';

  // ── Wishlist ──────────────────────────────────────────────────────────────
  static const String wishlist = '/wishlist';
  static String wishlistToggle(String id) => '/wishlist/$id/toggle';

  // ── Chat ──────────────────────────────────────────────────────────────────
  static const String chats = '/chats';
  static String chatMessages(String id) => '/chats/$id/messages';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // ── Device ────────────────────────────────────────────────────────────────
  static const String deviceFcmToken = '/device/fcm-token';
  static const String userLocation = '/user/location';

  // ── Reference data ────────────────────────────────────────────────────────
  static const String listingTypes = '/listing-types';
  static const String metaRoles = '/meta/roles';
  static const String metaListingTypes = '/meta/listing-types';
  static const String metaListingFacings = '/meta/listing-facings';
  static const String amenities = '/amenities';
  static const String geoDivisions = '/geo/divisions';
  static String geoDistricts(int divisionId) => '/geo/districts/$divisionId';
  static String geoUpazilas(int districtId) => '/geo/upazilas/$districtId';
  static String geoUnions(int upazilaId) => '/geo/unions/$upazilaId';
}
