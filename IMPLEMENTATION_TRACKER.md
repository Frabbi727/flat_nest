# FlatNest Implementation Tracker

## Status Legend
- ✅ Complete
- 🔲 Pending

---

## Phase 1 — Foundation & Auth ✅

| Item | File | Status |
|------|------|--------|
| Theme (FlatNestTheme, AppColors, AppTextStyles) | `lib/app/theme/` | ✅ |
| API config (base URL, env) | `lib/app/core/network/api_config.dart` | ✅ |
| ApiClient (Dio + interceptors + patch method) | `lib/app/core/network/api_client.dart` | ✅ |
| CacheManager (tokens + user JSON) | `lib/app/core/cache/cache_manager.dart` | ✅ |
| AuthService (reactive user, persist across restart) | `lib/app/core/service/auth_service.dart` | ✅ |
| UserModel + AuthResponse | `lib/app/modules/auth/model/user_model.dart` | ✅ |
| AuthRepository (login, register, saveDetails, logout) | `lib/app/modules/auth/repository/` | ✅ |
| AuthController (role-based routing) | `lib/app/modules/auth/controller/` | ✅ |
| LoginView | `lib/app/modules/auth/view/login_view.dart` | ✅ |
| SplashView (branded) | `lib/app/modules/splash/view/splash_view.dart` | ✅ |

---

## Phase 2 — Register (3-step wizard) ✅

| Item | File | Status |
|------|------|--------|
| RegisterController (3-step, API calls) | `lib/app/modules/register/controller/` | ✅ |
| Step 1 — name, email, password, phone | `lib/app/modules/register/view/register_step1_view.dart` | ✅ |
| Step 2 — role selection + DOB picker | `lib/app/modules/register/view/register_step2_view.dart` | ✅ |
| Step 3 — avatar upload + skip | `lib/app/modules/register/view/register_step3_view.dart` | ✅ |
| RegChrome (shared scaffold + progress bar) | `lib/app/modules/register/widget/reg_chrome.dart` | ✅ |
| FNField (animated input widget) | `lib/app/modules/register/widget/fn_field.dart` | ✅ |

---

## Phase 3 — Renter Side ✅

| Item | File | Status |
|------|------|--------|
| ListingModel (shared, + OwnerListingModel) | `lib/app/modules/listing/model/listing_model.dart` | ✅ |
| ListingRepository (feed, wishlist, amenities) | `lib/app/modules/renter_home/repository/` | ✅ |
| RenterHomeController (tabs, chips, optimistic wishlist) | `lib/app/modules/renter_home/controller/` | ✅ |
| Discovery tab (featured card, listing cards, chips) | `lib/app/modules/renter_home/view/discovery_view.dart` | ✅ |
| ListingCardWidget | `lib/app/modules/renter_home/view/listing_card_widget.dart` | ✅ |
| FiltersSheet (type, price slider, amenities) | `lib/app/modules/renter_home/view/filters_sheet.dart` | ✅ |
| Listing Detail (carousel, stats, owner card, CTA) | `lib/app/modules/renter_home/view/listing_detail_view.dart` | ✅ |
| Wishlist tab | `lib/app/modules/renter_home/view/wishlist_view.dart` | ✅ |
| Messages tab (placeholder) | `lib/app/modules/renter_home/view/messages_placeholder_view.dart` | ✅ |
| Profile tab | `lib/app/modules/renter_home/view/profile_placeholder_view.dart` | ✅ |

---

## Phase 4 — Owner Side ✅

| Item | File | Status |
|------|------|--------|
| OwnerRepository (my listings, delete) | `lib/app/modules/owner/repository/owner_repository.dart` | ✅ |
| OwnerController (KPIs: views, inquiries, active) | `lib/app/modules/owner/controller/owner_controller.dart` | ✅ |
| Dashboard tab (KPI grid, listings preview, activity) | `lib/app/modules/owner/view/owner_home_view.dart` | ✅ |
| My Listings tab (status badges, actions) | included in owner_home_view.dart | ✅ |
| Profile tab (initials avatar, logout) | included in owner_home_view.dart | ✅ |
| **Create Listing Wizard (4 steps)** | `lib/app/modules/owner/view/create_listing_*.dart` | ✅ |
| — Step 1: title, type, price, deposit, beds/baths/size, description, amenities | `create_listing_step1_view.dart` | ✅ |
| — Step 2: photo grid (up to 8, cover badge) | `create_listing_step2_view.dart` | ✅ |
| — Step 3: cascading location dropdowns (Division→District→Upazila→Union) | `create_listing_step3_view.dart` | ✅ |
| — Step 4: preview card + "what happens next" | `create_listing_step4_view.dart` | ✅ |
| CreateListingController (4-step submit, photo upload, location save) | `create_listing_controller.dart` | ✅ |
| CreateListingRepository (POST /listings, photos, location, submit) | `create_listing_repository.dart` | ✅ |

---

## Phase 5 — Chat ✅

| Item | File | Status |
|------|------|--------|
| ChatModel (chat, message, user, listing) | `lib/app/modules/chat/model/chat_model.dart` | ✅ |
| ChatRepository (get chats, open chat, messages, send) | `lib/app/modules/chat/repository/` | ✅ |
| ChatController (list + thread + send + unread count) | `lib/app/modules/chat/controller/` | ✅ |
| ChatListView (avatar, unread badge, time ago) | `lib/app/modules/chat/view/chat_list_view.dart` | ✅ |
| ChatDetailView (bubbles, input bar) | `lib/app/modules/chat/view/chat_detail_view.dart` | ✅ |

---

## Pending / Future

| Item | Notes |
|------|-------|
| 🔲 Notifications (Phase 6) | Push + in-app notifications not implemented |
| 🔲 Real-time chat (Pusher) | Currently polling only; backend supports Pusher |
| 🔲 Geo API integration | Cascading dropdowns use hardcoded data; backend has `/geo` endpoints for real IDs |
| 🔲 Map view (renter home) | Tab 2 is placeholder |
| 🔲 Onboarding screens | `OnboardingView` exists but not branded |
| 🔲 Cleanup old `HomeView` | `Routes.home` bypassed; can delete `lib/app/modules/home/` |

---

## Route Map

```
/splash              → SplashView
/onboarding          → OnboardingView
/login               → LoginView
/register            → RegisterView (3-step wizard)
/renter/home         → RenterHomeView (5-tab)
/listing/detail      → ListingDetailView
/owner/home          → OwnerHomeView (3-tab + FAB)
/owner/create-listing → CreateListingView (4-step wizard)
/chat                → ChatListView
/chat/detail         → ChatDetailView
```

---

## Architecture Notes

- All screens use `Theme.of(context).extension<FlatNestTheme>()!` for tokens
- Controllers extend `BaseController` → `showLoading()`, `hideLoading()`, `showError(msg)`
- All API calls return `Resource<T>` — pattern-matched with `Success(data:)` / `Error(message:)`
- Tokens persisted in `flutter_secure_storage`; user JSON in `CacheManager`
- Role routing: `user.isOwner` → `/owner/home`, else → `/renter/home`
