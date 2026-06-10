# FlatNest — Complete Platform Specification (Business + API)

> **Purpose:** This is the single source of truth for rebuilding FlatNest on any platform (web, mobile, desktop).
> It documents every feature, business rule, API endpoint, request/response payload, and UX rule
> exactly as the production mobile app works today.
>
> **Base URL:** `https://flatnest.techrealify.com/api/v1`
> **Storage origin (for relative image paths):** `https://flatnest.techrealify.com`
> **Backend:** Laravel + Sanctum tokens. All requests/responses are `application/json` unless marked `multipart/form-data`.
>
> ⚠️ This document **supersedes** `FLATNEST_API_DOCS.md` (which uses an outdated status taxonomy and is missing guest access + chat accept/reject).

---

## Table of Contents

1. [Product Overview & User Roles](#1-product-overview--user-roles)
2. [API Conventions (Envelope, Auth, Errors, Images)](#2-api-conventions)
3. [Guest Access — Business Rules](#3-guest-access--business-rules)
4. [Authentication & Registration](#4-authentication--registration)
5. [Role-Based Routing & App Entry Flow](#5-role-based-routing--app-entry-flow)
6. [Reference / Meta Data APIs](#6-reference--meta-data-apis)
7. [Renter — Discovery, Search & Filters](#7-renter--discovery-search--filters)
8. [Renter — Nearby Map Search](#8-renter--nearby-map-search)
9. [Renter — Listing Detail](#9-renter--listing-detail)
10. [Renter — Wishlist](#10-renter--wishlist)
11. [Owner — My Listings & Dashboard](#11-owner--my-listings--dashboard)
12. [Owner — Create Listing Wizard (5 Steps)](#12-owner--create-listing-wizard-5-steps)
13. [Listing Status Lifecycle (Critical Business Logic)](#13-listing-status-lifecycle)
14. [Owner — Edit, Resubmit, Mark Rented, Delete](#14-owner--edit-resubmit-mark-rented-delete)
15. [Chat / Messaging — Request-to-Chat Model](#15-chat--messaging--request-to-chat-model)
16. [Notifications — In-App + Push (FCM)](#16-notifications--in-app--push-fcm)
17. [Device Registration & User Location](#17-device-registration--user-location)
18. [Data Models (Full Field Reference)](#18-data-models)
19. [Cross-Cutting Business Rules & Conventions](#19-cross-cutting-business-rules--conventions)
20. [Endpoint Quick Reference (All Endpoints)](#20-endpoint-quick-reference)
21. [Web Implementation Checklist](#21-web-implementation-checklist)

---

## 1. Product Overview & User Roles

**FlatNest** is a rental-property marketplace for Bangladesh. Owners list flats/rooms; renters discover them by filters, search, and map proximity; the two parties connect through a moderated chat system. Listings are admin-moderated before going live.

### The three actor types

| Actor | How they get this state | What they can do |
|---|---|---|
| **Guest** | Opens the app without logging in | Browse, search, and filter listings; view the nearby map. Everything else triggers a login prompt (see §3) |
| **Renter** | Registers and picks role `renter` | Everything a guest can + open listing details, wishlist, chat with owners, get nearby-listing notifications |
| **Owner** | Registers and picks role `owner` | Create/edit/manage listings, respond to chat requests, get moderation notifications |

There is also an **Admin** (web backend only, not in the mobile app) who approves/rejects submitted listings. The mobile/web client never calls admin endpoints — it only reacts to status changes the admin causes.

### Core value loops

1. **Owner loop:** Create listing (wizard) → submit → admin review → active → receive chat requests → accept → negotiate → mark rented.
2. **Renter loop:** Browse/filter/map-search → view detail → save to wishlist → send chat request → wait for accept → chat → rent.

---

## 2. API Conventions

### Authentication header

Every authenticated request:

```
Authorization: Bearer <access_token>
Accept: application/json
```

### Standard response envelope (all endpoints)

```json
{
  "success": true,
  "message": "...",
  "data": { } 
}
```

`data` may be an object, an array, or `null`. On failure, `success: false` and `message` contains a human-readable error.

Paginated responses add `meta`:

```json
{
  "success": true,
  "data": [ ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 72,
    "unread_count": 3
  }
}
```

(`unread_count` appears in `meta` only for the notifications list.)

### Token refresh flow

When any request returns **401 Unauthorized**:

1. Call `POST /auth/refresh` with body `{ "refresh_token": "<refresh_token>" }`.
2. Response `200`: `{ "data": { "access_token": "<new_token>" } }` — the **refresh token does not rotate**; keep the old one.
3. Retry the original request with the new access token.
4. If refresh fails → clear all local auth state and route to Login.

### Error code convention

Error responses may include a machine-readable `code`. Known code used by the app:

- `USE_GOOGLE_SIGN_IN` — returned by `POST /auth/login` when the account was created via Google. UI shows a hint: "This account uses Google Sign-In."

### Image / file URLs

- Listing photos and avatars are returned as URLs in responses. They are *usually* absolute, but **may be relative** (start with `/storage/...`). Always resolve: if the URL doesn't start with `http`, prepend the storage origin `https://flatnest.techrealify.com`.
- **Upload constraints (validate client-side before upload):**

| Field | Allowed types | Max size |
|---|---|---|
| Listing photo | jpg, jpeg, png | **200 KB** |
| Avatar | jpg, jpeg, png | **200 KB** |

### Coordinate convention (critical — easy to get wrong)

The API uses Cartesian naming everywhere:

- **`coord_x` = longitude** (X-axis)
- **`coord_y` = latitude** (Y-axis)

This applies to listing objects, the nearby search query params, and the save-location payload. Only `PATCH /user/location` uses plain `lat` / `lng`.

### Timeouts used by the mobile client

Connect timeout 30s, receive timeout 30s. Reasonable defaults for web too.

---

## 3. Guest Access — Business Rules

Guest mode is a first-class part of the product: **unauthenticated users land directly in the Renter Home experience**, not on a login wall.

### Entry into guest mode

- App launch routing (see §5): if the user is not authenticated (and has passed onboarding), they are sent to **Renter Home as a guest**.
- Greeting shows the name **"Guest"**.

### What guests CAN do (no token sent / not required)

| Capability | Endpoint(s) |
|---|---|
| Browse all active listings | `GET /listings` |
| Full-text search + all filters + type chips | `GET /listings?...` (see §7) |
| Nearby map search | `GET /listings/nearby?...` |
| Load all reference data (types, amenities, facings, geo) | `GET /listing-types`, `GET /amenities`, etc. |
| Reverse-geocode their GPS position for the location label | OpenStreetMap Nominatim (client-side, see §19) |

> Backend note: `GET /listings` works **without** auth for browsing. The mobile client simply omits the `Authorization` header when no token exists.

### What guests CANNOT do — and exactly how the UI gates it

Every gated action runs through one guard: *if authenticated → proceed; else → show the "Guest Auth Sheet"* (a bottom sheet/modal with a lock icon, a context-specific title + message, a primary **"Log in or Register"** button that navigates to Login, and a **"Maybe later"** dismiss button).

| Gated action | Sheet title | Sheet message |
|---|---|---|
| Open a listing detail (tap any card) | "Unlock full details" | "Log in to see full details, amenities, and contact the owner." |
| Save to wishlist (heart button) | "Save your favorites" | "Log in to save this flat to your wishlist and view it later." |
| Anything else gated (generic) | "Login Required" | "Please log in to continue with this action." |

Additional guest behavior:

- **Messages tab** and **Profile tab** render placeholder screens prompting login (no API calls made).
- **Wishlist fetch is skipped** entirely for guests (`GET /wishlist` is never called).
- **Location sync is skipped** — `PATCH /user/location` is never called for guests (it would 401).
- GPS is still acquired locally so guests get a location label and can use the nearby map.

### Web implementation guidance

Replicate this exactly: public landing/browse pages need no session; clicking a listing card, the heart icon, "Message Owner", or profile/wishlist routes opens a login-prompt modal (or redirects to `/login?next=...`). Important nuance: **the listing detail page itself is login-gated in the product UX**, even though browsing cards is free — this is the conversion mechanic that drives registration.

---

## 4. Authentication & Registration

### 4.1 Login — `POST /auth/login` (public)

**Request:**
```json
{ "email": "user@example.com", "password": "secret" }
```

**Response `data`:**
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "registration_step": null,
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "01711000000",
    "role": "renter",
    "avatar_url": "/storage/avatars/abc.jpg",
    "is_complete": true
  }
}
```

- `role` is `"renter"`, `"owner"`, or `null` (not chosen yet).
- `is_complete: false` → registration unfinished; route to the correct step (see below).
- `registration_step` (int or null) tells which step was last completed.
- On error with `code: "USE_GOOGLE_SIGN_IN"` → show "use Google" hint.

**After every successful login (email or Google):**
1. Persist `access_token`, `refresh_token`, and the `user` object locally.
2. Register the push token: `POST /device/fcm-token` (see §17).
3. Navigate by role (see §5).

### 4.2 Google Sign-In — `POST /auth/google` (public)

**Request:** `{ "id_token": "<google_id_token>" }`
**Response:** identical shape to Login.

Business rules:
- New Google account → server creates the user; `is_complete` is `false`, `role` is `null` → client routes to **registration step 2 (role selection)**.
- Web: obtain the ID token via Google Identity Services (the mobile app uses serverClientId `305560403551-pprdlkpkgolqhu6ho81bk5cb9sflcqbk.apps.googleusercontent.com` — your web client ID must be authorized for the same backend).
- On logout, also sign out of the Google session client-side so the account picker reappears.

### 4.3 Registration — 3-step wizard

| Step | Endpoint | Auth | Purpose |
|---|---|---|---|
| 1 | `POST /auth/register` | No | Create account → returns tokens immediately |
| 2 | `PATCH /auth/register/details` | Yes | Choose role (`owner` / `renter`) |
| 3 | `PATCH /auth/register/avatar` | Yes | Upload profile photo (optional, skippable) |

**Step 1 request:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secret123",
  "phone": "01711000000"
}
```
**Response:** same shape as Login (tokens + user, `is_complete: false`). The user is authenticated from this point.

**Step 2 request:** `{ "role": "renter" }` → `{ "success": true }`. This decides the home experience forever (Owner Home vs Renter Home).

**Step 3 request:** `multipart/form-data` with field `avatar: <image file>` (jpg/jpeg/png ≤ 200 KB).
**Response `data`:** `{ "avatar_url": "/storage/avatars/abc.jpg" }`

**Resuming an unfinished registration:** after any login, if `is_complete == false`:
- `role == null` → resume at **step 2**.
- `role != null` → resume at **step 3**.

### 4.4 Refresh — `POST /auth/refresh` (public)

`{ "refresh_token": "..." }` → `data: { "access_token": "..." }` (refresh token unchanged). See §2.

### 4.5 Logout — `POST /auth/logout` (auth)

- Empty body → `{ "success": true }`.
- **Backend automatically clears the FCM token / device session** — no separate unregister call needed.
- Client: best-effort (don't block logout on network failure), then clear tokens + cached user, sign out of Google, route to Login.
- The mobile app shows a **confirmation dialog** before logging out.

### 4.6 Delete Account — `DELETE /auth/account` (auth)

- No body. Response `200`: `{ "message": "Account deleted" }`.
- **Irreversible cascade:** deletes the account, all listings + photos, avatar, notifications, wishlist, chats, and device sessions, including storage files.
- Works for both roles. On `401`, treat as already-expired session: clear local state, go to Login.
- UI: requires an explicit destructive confirmation.

---

## 5. Role-Based Routing & App Entry Flow

### App launch (splash) decision tree

```
App start
  │
  ├─ first launch ever? ──────────→ Onboarding carousel
  │                                   ├─ "Skip"/finish → Renter Home (guest mode)
  │                                   └─ (login/register reachable from there)
  ├─ has valid stored session?
  │     ├─ user.role == "owner"  ──→ Owner Home
  │     └─ else (renter)         ──→ Renter Home
  │
  └─ no session ─────────────────→ Renter Home (GUEST MODE — not the login page!)
```

### After any successful auth

```
is_complete == false → resume registration (step 2 if role==null, else step 3)
role == "owner"      → Owner Home
role == "renter"     → Renter Home
```

### Home navigation structure

- **Renter Home tabs:** Discovery (0) · Map/Nearby (1) · Wishlist (2) · Messages (3) · Profile (4). Switching to the Messages tab refetches `GET /chats`.
- **Owner Home tabs:** Dashboard · My Listings · Messages · Profile.

---

## 6. Reference / Meta Data APIs

All **public** (no auth). Load once on app/page start and cache.

| Endpoint | Returns |
|---|---|
| `GET /listing-types` (alias `GET /meta/listing-types`) | `[ { "id": 1, "name": "apartment", "label": "Apartment" }, ... ]` — Apartment, Bachelor, Sublet, etc. |
| `GET /meta/listing-facings` | `[ { "id": 1, "label": "North", "slug": "north" }, ... ]` |
| `GET /amenities` | `[ { "id": 1, "name": "wifi", "label": "WiFi" }, ... ]` (WiFi, Parking, Generator, Lift, Gym, Security, CCTV, …) |
| `GET /meta/roles` | Available user roles (used in onboarding) |
| `GET /geo/divisions` | `[ { "id": 1, "name": "Dhaka", "bn_name": "ঢাকা" }, ... ]` |
| `GET /geo/districts/{division_id}` | Districts of a division (same shape) |
| `GET /geo/upazilas/{district_id}` | Upazilas of a district |
| `GET /geo/unions/{upazila_id}` | Unions of an upazila |

### Geo cascade business rule (used in filters AND the listing wizard)

Bangladesh's 4-level hierarchy: **Division → District → Upazila → Union**.

1. Load divisions on mount.
2. Selecting a division → fetch its districts; **clear** any selected district/upazila/union and their option lists.
3. Selecting a district → fetch upazilas; clear upazila/union below it.
4. Selecting an upazila → fetch unions.
5. Union is always optional.

---

## 7. Renter — Discovery, Search & Filters

### 7.1 Browse listings — `GET /listings` (public for browsing)

Returns **only `active` listings** (backend enforces this — drafts, pending, rejected, rented never appear).

**Response `data`:** array of Listing objects (full shape in §18). Key per-card fields: photos (thumbnail = lowest `position`), title, area, price, beds, baths, size, type, `available_from` (null = "Available now").

### 7.2 Filter & search query parameters

All appended to `GET /listings`:

| Param | Type | Meaning |
|---|---|---|
| `search` | string | Full-text search (title/area/description) |
| `listing_type_id` | int | Type chip (All = omit) |
| `price_min` / `price_max` | int | Monthly rent range (BDT) |
| `beds` | int | Bedrooms |
| `baths` | int | Bathrooms |
| `facing_id` | int | Facing direction |
| `floor_min` / `floor_max` | int | Floor range |
| `size_min` / `size_max` | int | Sq-ft range |
| `available_from_start` / `available_from_end` | `YYYY-MM-DD` | Availability window |
| `amenities` | string | **Comma-separated** amenity IDs, e.g. `1,3,5` |
| `division_id` / `district_id` / `upazila_id` / `union_id` | int | Geo cascade |
| `sort_by` | string | `price_asc` \| `price_desc` \| `newest` |

Example:
```
GET /listings?listing_type_id=1&beds=2&price_max=30000&division_id=1&amenities=1,4&sort_by=newest
```

### 7.3 Discovery UX business rules (replicate on web)

- **Search is debounced 500 ms** — fire the request only after the user pauses typing.
- **Price slider bounds in the UI: 0 – 80,000 BDT.** Only send `price_min` if > 0 and `price_max` if < 80,000 (i.e., untouched slider sends nothing).
- **Type chips** (All / Apartment / Bachelor / Sublet…) immediately refetch with `listing_type_id`.
- The filter sheet shows an **active-filter count badge**; "Reset" clears every filter (including geo selections and the search box) and refetches.
- On page mount, load in parallel: listing types, amenities, divisions, then fetch listings after GPS resolves (don't block listings on GPS failure).
- Pull-to-refresh (web: refresh button) re-runs the same filtered query.

---

## 8. Renter — Nearby Map Search

### `GET /listings/nearby` (public)

| Param | Type | Required | Notes |
|---|---|---|---|
| `coord_x` | float | **YES** | User **longitude** |
| `coord_y` | float | **YES** | User **latitude** |
| `radius` | float | no | km, **default 5.0** (UI exposes a radius selector) |
| `listing_type_id`, `price_min`, `price_max`, `beds`, `baths` | — | no | Optional narrowing |

**Response:** same Listing shape, plus `distance_km` (e.g. `1.24`) on each item. Render as map pins + a sortable list "1.2 km away".

Business notes:
- Works for guests too.
- Requires browser/device geolocation permission; if denied, show "Location unavailable" and let the user browse the normal list instead.

---

## 9. Renter — Listing Detail

### `GET /listings/{id}` (auth required)

Returns the full Listing object: all photos (ordered by `position`), all amenities, facing, geo IDs, coordinates, description, deposit, floor, views, owner public info `{ id, name, phone, avatar_url }`, and owner contact preferences.

Business rules:
- **Login-gated in the UX** (guests get the auth sheet — §3).
- If a listing has become `pending`/`rented` since the renter saw it, the backend returns 404 / unavailable → show a "This flat is not currently available" state.
- Detail page actions: photo gallery, amenity list, map preview at (`coord_y`,`coord_x`), **Save/heart** (wishlist toggle), and **"Message Owner"** (starts a chat request — §15).
- `views` is incremented server-side; nothing to do client-side.

---

## 10. Renter — Wishlist

### 10.1 Get wishlist — `GET /wishlist` (auth)

Array of full Listing objects.

### 10.2 Toggle — `POST /wishlist/{listing_id}/toggle` (auth)

No body. **Response `data`:** `{ "saved": true }` (`true` = now saved, `false` = now removed).

### Business rules (replicate exactly)

- **Optimistic UI:** flip the heart instantly, then reconcile with the server's `saved` value; revert + show error on failure. Guard against double-taps while a toggle request is in flight (per-listing lock).
- Wishlist state is kept **independent of the discovery filters** — saved IDs are a set used to paint hearts across discovery, map, and detail views.
- Wishlist degradation states (driven by listing status — see §13): a saved listing that went `pending` shows an **"Under Review"** badge greyed out; one that went `rented` shows **"Rented Out"** greyed out; both disable "Message Owner" with the message "This flat is not currently available".
- Guests: gated by the auth sheet; never fetched.

---

## 11. Owner — My Listings & Dashboard

### `GET /owner/listings` (auth, owner)

| Param | Type | Notes |
|---|---|---|
| `page` | int | default 1 — **paginated** (`meta.current_page/last_page/per_page/total`) |
| `status` | string | `draft` \| `pending` \| `active` \| `rejected` \| `rented` |
| `type_id` | int | listing type filter |

**Response `data`:** array of **OwnerListing** = Listing + two extra fields:
- `inquiries` (int) — number of chat inquiries on this listing
- `rejection_reason` (string | null) — admin's note when rejected

### Dashboard metrics

Computed client-side from the fetched list: e.g. **Active count** = items with `status == "active"`, total views, total inquiries.

### Status filter chips UI

All · Active · Pending · Draft · Rejected · Rented (each chip sets the `status` query param; "All" omits it). Infinite scroll / "load more" drives `page`.

---

## 12. Owner — Create Listing Wizard (5 Steps)

A draft is created first, then enriched step by step. The `id` returned by Step 1 is used in all later steps. **The user can abandon mid-way — the draft persists** and shows a "Continue" action in My Listings.

```
Step 1: POST  /listings                      → creates DRAFT, returns listing id
Step 2: POST  /listings/{id}/photos          → upload photos (multipart)
Step 3: PATCH /listings/{id}/location        → area + geo cascade + GPS pin
Step 4: PATCH /listings/{id}/owner-info      → contact details
Step 5: POST  /listings/{id}/submit          → status: draft → pending
```

### Step 1 — Basic info: `POST /listings`

```json
{
  "title": "Spacious 3 Bed Apartment",
  "listing_type_id": 1,
  "price": 25000,
  "beds": 3,
  "baths": 2,
  "deposit": 50000,
  "size": 1200,
  "description": "Bright, well-ventilated...",
  "amenities": [1, 2, 4],
  "available_from": "2026-07-01",
  "floor_no": 4,
  "facing_id": 1
}
```

| Field | Required | Notes |
|---|---|---|
| `title`, `listing_type_id`, `price`, `beds`, `baths` | **YES** | price = monthly rent (BDT) |
| `deposit`, `size`, `description`, `amenities` (int[]), `available_from` (`YYYY-MM-DD`, omit = available now), `floor_no`, `facing_id` | no | omit unfilled fields entirely (don't send null) |

**Response `data`:** the created listing — `{ "id": "uuid", "status": "draft", ... }`.

### Step 2 — Photos: `POST /listings/{id}/photos` (multipart)

Repeat the field name **`photos[]`** for each file. jpg/jpeg/png, **≤ 200 KB each** (validate before upload). Response: `{ "success": true }`.

### Step 3 — Location: `PATCH /listings/{id}/location`

```json
{
  "area": "Mirpur-10",
  "division_id": 1,
  "district_id": 21,
  "upazila_id": 341,
  "union_id": null,
  "road": "Road 5",
  "house_name": "Green Villa",
  "block": "A",
  "section": "11",
  "coord_y": 23.8103,
  "coord_x": 90.4125
}
```

- Geo IDs come from the cascade (§6). `union_id` optional.
- `coord_y` = **latitude**, `coord_x` = **longitude** — from a map-pin picker (the mobile app reverse-geocodes the pin via Nominatim to prefill the area label).
- Only non-empty fields are sent. **Response `data`:** updated listing.

### Step 4 — Owner contact: `PATCH /listings/{id}/owner-info`

```json
{
  "owner_name": "Rahim Ahmed",
  "owner_phone": "01711000001",
  "owner_alt_phone": "01811000002",
  "owner_email": "rahim@example.com",
  "preferred_contact": "phone"
}
```

`preferred_contact`: `phone` | `email` | `chat`. **Response `data`:** updated listing.

(There is also a generic `PATCH /listings/{id}` that accepts *any* subset of Step-1 fields + address + owner-info fields — used for edits, see §14.)

### Step 5 — Review & submit: `POST /listings/{id}/submit`

Empty body `{}` → `{ "success": true }`. Status: `draft` → **`pending`**. Owner gets a `listing_submitted` notification; admin reviews it.

### Draft resume UX

For a `draft`, the detail view shows a "Continue your listing" banner with step completeness indicators (Photos done? `photos.length > 0`. Location done? `area != null`), and the Continue button jumps to the first incomplete step.

---

## 13. Listing Status Lifecycle

**This is the core moderation business logic. The platform uses "Option B — Strict Re-review".**

Statuses: `draft` · `pending` · `active` · `rejected` · `rented`. Every listing also carries a display-ready `status_label`.

```
[draft]
  └─ POST /listings/{id}/submit ──────────→ [pending]

[pending]
  ├─ Admin approves ──────────────────────→ [active]
  └─ Admin rejects (with reason) ─────────→ [rejected]

[rejected]
  └─ POST /listings/{id}/submit (again) ──→ [pending]   ← rejection_reason is cleared

[active]
  ├─ Owner edits ANYTHING ────────────────→ [pending]   ← automatic re-review, notification sent
  └─ POST /listings/{id}/mark-rented ─────→ [rented]

[rented]   (terminal — no further transitions)
```

### Per-status owner UI rules

| status | Badge | Actions shown |
|---|---|---|
| `draft` | Grey "Draft" | **Continue** (resume wizard) |
| `pending` | Yellow "Pending Review" | **None — fully locked.** Show: "⏳ Your listing is under review. You'll be notified once it's approved." |
| `active` | Green "Active" | **Edit**, **Mark as Rented** |
| `rejected` | Red "Rejected" | **Fix & Resubmit** — show `rejection_reason` in a prominent red "Admin note" card |
| `rented` | Blue "Rented" | None — read-only, show in a "Past / Rented" section |

### Critical edit rule (must replicate)

Editing an **active** listing sends it back to `pending` and hides it from renters. Therefore, **before saving any edit to an active listing, show a warning dialog**:

> "Saving changes will temporarily hide your listing until it's re-approved by admin. Continue?"

After saving, the API returns the listing with `status: "pending"` → switch the UI to the Pending state and toast: "Your listing has been sent for re-approval."

### Renter-side consequences

- `GET /listings` / `/listings/nearby` only ever return `active` listings (backend enforced).
- A listing that leaves `active` disappears from discovery; wishlist entries show "Under Review" / "Rented Out" badges (§10).
- Chats on a listing that becomes `rented` **stay open** so both parties can finish the conversation.

---

## 14. Owner — Edit, Resubmit, Mark Rented, Delete

### Edit — `PATCH /listings/{id}` (auth, owner)

Send **only changed fields**; any subset of:

```json
{
  "title": "...", "listing_type_id": 1, "price": 28000, "beds": 3, "baths": 2,
  "deposit": 56000, "size": 1200, "description": "...", "amenities": [1,2,3],
  "available_from": "2026-08-01", "floor_no": 5, "facing_id": 2,
  "road": "Road 3", "house_name": "Blue Tower", "block": "B", "section": "12",
  "owner_name": "Rahim", "owner_phone": "01711000001",
  "owner_alt_phone": "01811000002", "owner_email": "rahim@example.com",
  "preferred_contact": "phone"
}
```

**Response `data`:** updated listing (with new `status` — see the re-review rule in §13).
Also available during edit: `POST /listings/{id}/photos` to add more photos and `PATCH /listings/{id}/location` to change location.

### Resubmit after rejection — `POST /listings/{id}/submit`

Empty body → status `rejected` → `pending`, `rejection_reason` cleared. Flow: owner reads the admin note → edits via the endpoints above → resubmits.

### Mark as Rented — `POST /listings/{id}/mark-rented`

Empty body → `{ "success": true }`, status → `rented` (terminal). Confirmation dialog required. Triggers `wishlist_listing_rented` notifications to every renter who wishlisted it.

### Delete — `DELETE /listings/{id}`

→ `{ "success": true }`. Destructive confirmation required. Removes the listing and its photos.

---

## 15. Chat / Messaging — Request-to-Chat Model

**FlatNest chat is NOT open messaging.** It is a moderated **request → accept/reject** model. A chat has a status: `pending` · `accepted` · `rejected`.

### The flow

1. **Renter initiates** from a listing detail page ("Message Owner") with one initial message. A chat room is created with status **`pending`**. The owner gets a push notification ("New Chat Request").
2. **While pending, NOBODY can send more messages** — not the renter, not the owner. The owner can read the initial message.
3. **Owner accepts** → status `accepted`, renter notified, both sides chat freely.
   **Owner rejects** → status `rejected`, renter notified, chat permanently closed.

### 15.1 Inbox — `GET /chats` (auth, both roles)

**Response `data`:**
```json
[
  {
    "id": "chat-uuid",
    "listing": { "id": "listing-uuid", "title": "3 Bed Apartment", "area": "Mirpur-10" },
    "other_user": { "id": "user-uuid", "name": "John Doe", "avatar_url": "/storage/avatars/john.jpg" },
    "last_message": {
      "id": "msg-uuid", "chat_id": "chat-uuid", "sender_id": "user-uuid",
      "sender": { "id": "...", "name": "John", "avatar_url": null },
      "text": "Is this still available?", "is_read": false,
      "created_at": "2026-05-24T10:30:00Z"
    },
    "unread_count": 3,
    "status": "pending",
    "updated_at": "2026-05-24T10:30:00Z"
  }
]
```

Use `status` to badge each row ("Waiting for owner" / "Rejected" / normal). Treat a missing/unknown status as `pending`.

### 15.2 Start a chat request — `POST /chats` (auth, renter only)

```json
{ "listing_id": "uuid-of-the-listing", "initial_message": "Hi, is this flat still available?" }
```

**Response `201`:**
```json
{ "success": true, "message": "Chat request sent.", "data": { "chat_id": "uuid-of-the-chat" } }
```

If a chat already exists for this renter+listing, the server returns the existing chat instead of creating a duplicate.

### 15.3 Get messages — `GET /chats/{chat_id}/messages` (auth)

**Response `data`** (note the wrapper — status comes with every fetch):
```json
{
  "chat": { "status": "accepted" },
  "messages": [
    {
      "id": "msg-uuid", "chat_id": "chat-uuid", "sender_id": "user-uuid",
      "sender": { "id": "user-uuid", "name": "John Doe", "avatar_url": null },
      "text": "Is this still available?", "is_read": true,
      "created_at": "2026-05-24T10:30:00Z"
    }
  ]
}
```

### 15.4 Accept / Reject (auth, **owner only**)

```
POST /chats/{chat_id}/accept   → data: { "status": "accepted" }
POST /chats/{chat_id}/reject   → data: { "status": "rejected" }
```

### 15.5 Send a message — `POST /chats/{chat_id}/messages` (auth)

```json
{ "text": "Yes, it is available from next month." }
```

**Response `data`:** the created message object.
**Returns `403 Forbidden` if the chat status is not `accepted`** — never render the input box unless status is `accepted`.

### Chat UI state matrix (replicate exactly)

| Status | Renter sees | Owner sees |
|---|---|---|
| `pending` | Input hidden. "Waiting for the owner to accept your chat request." | Input hidden. Renter's initial message + **Accept Request** / **Reject Request** buttons |
| `accepted` | Normal chat with input | Normal chat with input |
| `rejected` | Input hidden. "This chat request was declined." | Same |

### Real-time note

There is **no WebSocket/Pusher integration yet** (planned). The mobile app refetches `GET /chats` when the Messages tab is opened and refetches messages when a thread is opened. For web, polling (e.g. every 10–15 s on an open thread) is a faithful equivalent until real-time lands.

---

## 16. Notifications — In-App + Push (FCM)

Two parallel systems fire **simultaneously** for every event:

| System | Transport | Client duty |
|---|---|---|
| In-app notifications | Stored in DB, REST | List, badge, mark read |
| Push | Firebase Cloud Messaging | Register token after login, handle tap-navigation |

### 16.1 Notification kinds (complete list)

`reference_id` is always the relevant **listing UUID**.

**Owner receives:**

| `kind` | Fires when | Navigate to |
|---|---|---|
| `listing_submitted` | Owner submits a listing for review | Owner listing detail |
| `listing_approved` | Admin approves ("Your listing was approved! 🎉 — {title} is now live.") | Public listing detail |
| `listing_rejected` | Admin rejects (body = admin's typed reason) | Owner listing detail (show rejection reason) |
| `listing_review` | Owner edited an active listing → auto re-review ("temporarily hidden until re-approved") | Owner listing detail |

**Renter receives:**

| `kind` | Fires when | Navigate to |
|---|---|---|
| `nearby_listing` | A new listing goes active within **10 km** of the renter's saved location | Public listing detail |
| `wishlist_listing_rented` | An owner marks a wishlisted listing as rented | Wishlist screen |

**Chat events** (new chat request → owner; accept/reject → renter; new message) are also delivered as push notifications — tap should open the relevant chat thread.

### 16.2 List — `GET /notifications?page=1` (auth)

```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "kind": "nearby_listing",
      "title": "New listing near you!",
      "body": "2BHK Flat in Mirpur is now available nearby.",
      "time": "5 minutes ago",
      "is_unread": true,
      "reference_id": "listing-uuid"
    }
  ],
  "meta": { "current_page": 1, "last_page": 2, "per_page": 15, "total": 20, "unread_count": 3 }
}
```

`time` is pre-formatted relative time — render as-is. `unread_count` ships in `meta`, so no extra call is needed when the list is open.

### 16.3 Other notification endpoints (auth)

| Call | Response |
|---|---|
| `GET /notifications/unread-count` | `data: { "unread_count": 3 }` — for the bell badge on launch/resume |
| `PATCH /notifications/{id}/read` | `{ "success": true }` — call when a notification is tapped, then navigate by `kind` + `reference_id` |
| `PATCH /notifications/read-all` | `{ "success": true }` — "Mark all read" button; zero the badge locally |

---

## 17. Device Registration & User Location

### 17.1 FCM token — `POST /device/fcm-token` (auth)

Call **immediately after every login** (email or Google) and again whenever Firebase rotates the token.

```json
{
  "fcm_token": "<token from Firebase SDK>",
  "device_type": "web",
  "device_model": "Chrome / Windows"
}
```

| Field | Required | Values |
|---|---|---|
| `fcm_token` | YES | Web: Firebase JS SDK `getToken()` (needs a VAPID key + service worker) |
| `device_type` | no | `android` \| `ios` \| `web` |
| `device_model` | no | free text, ≤ 100 chars (mobile sends e.g. "Samsung SM-S921B") |

Response: `{ "success": true, "message": "Device registered" }`.
**Logout automatically unregisters the device server-side.**

### 17.2 User location — `PATCH /user/location` (auth)

```json
{ "lat": 23.8103, "lng": 90.4125 }
```

(`lat` −90…90, `lng` −180…180 — note this endpoint uses lat/lng, *not* coord_x/y.) Response: `{ "success": true }`.

Business rules:
- Send after login and on app resume / significant movement (>1 km). Powers the renter **`nearby_listing`** alerts (10 km radius).
- Fire-and-forget (ignore failures), **never called for guests**.

---

## 18. Data Models

### User
```typescript
{
  id: string                    // UUID
  name: string
  email: string
  phone: string | null
  role: "renter" | "owner" | null
  avatar_url: string | null     // may be relative — resolve against storage origin
  is_complete: boolean          // false = registration unfinished
}
```

### AuthResponse
```typescript
{
  access_token: string
  refresh_token: string
  registration_step: number | null   // last completed step; null = complete
  user: User
}
```

### Listing
```typescript
{
  id: string                    // UUID
  title: string
  area: string | null
  road_and_house: string | null // server-composed display address
  road: string | null
  house_name: string | null
  block: string | null
  section: string | null
  price: number                 // monthly rent, BDT
  deposit: number | null
  beds: number | null
  baths: number | null
  size: number | null           // sq ft
  floor_no: number | null
  facing_id: number | null
  facing: { id: number, label: string, slug: string } | null
  available_from: string | null // "YYYY-MM-DD"; null = available now
  description: string | null
  status: "draft" | "pending" | "active" | "rejected" | "rented"
  status_label: string          // display-ready, e.g. "Pending Review"
  views: number
  coord_y: number | null        // LATITUDE
  coord_x: number | null        // LONGITUDE
  distance_km: number | null    // only present from /listings/nearby
  listing_type_id: number | null
  type: string                  // slug, e.g. "apartment"
  division_id: number | null
  district_id: number | null
  upazila_id: number | null
  union_id: number | null
  amenities: { id: number, name: string, label: string }[]
  photos: { id: string, url: string, position: number }[]  // thumbnail = lowest position
  owner: { id: string, name: string, phone: string | null, avatar_url: string | null } | null
  owner_name: string | null     // listing-level contact info (set in wizard step 4)
  owner_phone: string | null
  owner_alt_phone: string | null
  owner_email: string | null
  preferred_contact: "phone" | "email" | "chat" | null
  created_at: string            // ISO datetime
}
```

### OwnerListing (extends Listing — only from /owner/listings & owner detail)
```typescript
{
  ...Listing,
  inquiries: number               // chat inquiry count
  rejection_reason: string | null // admin note when status == "rejected"
}
```

### Chat
```typescript
{
  id: string
  listing: { id: string, title: string, area: string | null }
  other_user: { id: string, name: string, avatar_url: string | null }
  last_message: ChatMessage | null
  unread_count: number
  status: "pending" | "accepted" | "rejected"   // default to "pending" if missing
  updated_at: string
}
```

### ChatMessage
```typescript
{
  id: string
  chat_id: string
  sender_id: string             // compare with current user id for left/right bubbles
  sender: { id: string, name: string, avatar_url: string | null } | null
  text: string
  is_read: boolean
  created_at: string
}
```

### Notification
```typescript
{
  id: string
  kind: string                  // see §16.1
  title: string
  body: string
  time: string                  // pre-formatted: "5 minutes ago"
  is_unread: boolean
  reference_id: string | null   // listing UUID to navigate to
}
```

### GeoItem / ListingType / Amenity / Facing
```typescript
GeoItem:     { id: number, name: string, bn_name: string }
ListingType: { id: number, name: string, label: string }
Amenity:     { id: number, name: string, label: string }
Facing:      { id: number, label: string, slug: string }
```

---

## 19. Cross-Cutting Business Rules & Conventions

1. **Coordinates:** `coord_x` = longitude, `coord_y` = latitude — everywhere except `PATCH /user/location` (plain lat/lng). Mixing these up breaks the map and nearby search silently.
2. **Relative URLs:** any photo/avatar URL starting with `/` → prepend `https://flatnest.techrealify.com`.
3. **Image uploads:** jpg/jpeg/png only, **max 200 KB per file** — compress/validate client-side before upload to avoid 422s.
4. **Optimistic wishlist toggles** with server reconciliation and in-flight locking (§10).
5. **Search debounce: 500 ms.** Price slider: 0–80,000 BDT, send params only when changed from defaults.
6. **Sparse payloads:** create/edit/location requests omit unset fields entirely (no nulls).
7. **Status source of truth** is always the API response — after edit/submit/accept actions, update local state from the returned object rather than assuming.
8. **Reverse geocoding** (location label + map-pin → address prefill) is done **client-side** against OpenStreetMap Nominatim (`https://nominatim.openstreetmap.org/reverse?format=json&lat=..&lon=..&addressdetails=1&zoom=18`, with a proper User-Agent and `Accept-Language: en`). Label = first 2 non-empty of: road, neighbourhood, hamlet, suburb, village, town, city_district, city, county, state; fallback to the first 2 segments of `display_name`; final fallback "Your location". The backend is not involved.
9. **Logout/delete are best-effort + local-first:** clear local session even if the network call fails; both require confirmation dialogs; Google session must also be signed out.
10. **401 handling is global:** one interceptor refreshes the token and retries; a failed refresh logs the user out. Don't handle 401 per-feature.
11. **Pending listings are locked:** no edit, delete, or submit actions while `pending`.
12. **Chats survive rentals:** when a listing becomes `rented`, existing accepted chats remain usable.
13. **One chat per renter+listing:** starting a chat that already exists returns the existing one.
14. **Currency** is BDT (৳) integers — no decimals anywhere in money fields.
15. **Localization:** the app ships English UI with Bangla geo names available via `bn_name`.

---

## 20. Endpoint Quick Reference

| # | Method | Endpoint | Auth | Who | Purpose |
|---|---|---|---|---|---|
| 1 | POST | `/auth/login` | No | All | Email/password login |
| 2 | POST | `/auth/google` | No | All | Google Sign-In (id_token) |
| 3 | POST | `/auth/register` | No | All | Register step 1 (returns tokens) |
| 4 | PATCH | `/auth/register/details` | Yes | All | Register step 2 — set role |
| 5 | PATCH | `/auth/register/avatar` | Yes | All | Register step 3 — avatar (multipart) |
| 6 | POST | `/auth/refresh` | No | All | Refresh access token |
| 7 | POST | `/auth/logout` | Yes | All | Logout (clears device/FCM server-side) |
| 8 | DELETE | `/auth/account` | Yes | All | Delete account (irreversible cascade) |
| 9 | GET | `/listing-types` | No | All | Listing types |
| 10 | GET | `/meta/listing-types` | No | All | Alias of #9 |
| 11 | GET | `/meta/listing-facings` | No | All | Facing directions |
| 12 | GET | `/meta/roles` | No | All | Role options |
| 13 | GET | `/amenities` | No | All | Amenities |
| 14 | GET | `/geo/divisions` | No | All | Divisions |
| 15 | GET | `/geo/districts/{division_id}` | No | All | Districts |
| 16 | GET | `/geo/upazilas/{district_id}` | No | All | Upazilas |
| 17 | GET | `/geo/unions/{upazila_id}` | No | All | Unions |
| 18 | GET | `/listings` | No* | Guest/Renter | Browse + filter active listings |
| 19 | GET | `/listings/nearby` | No* | Guest/Renter | Radius search (coord_x/coord_y) |
| 20 | GET | `/listings/{id}` | Yes | Renter/Owner | Listing detail (login-gated UX) |
| 21 | POST | `/listings` | Yes | Owner | Wizard 1 — create draft |
| 22 | POST | `/listings/{id}/photos` | Yes | Owner | Wizard 2 — photos (multipart `photos[]`) |
| 23 | PATCH | `/listings/{id}/location` | Yes | Owner | Wizard 3 — location + GPS |
| 24 | PATCH | `/listings/{id}/owner-info` | Yes | Owner | Wizard 4 — contact info |
| 25 | POST | `/listings/{id}/submit` | Yes | Owner | Wizard 5 / resubmit → `pending` |
| 26 | PATCH | `/listings/{id}` | Yes | Owner | Edit (active → auto `pending`) |
| 27 | POST | `/listings/{id}/mark-rented` | Yes | Owner | Mark rented (terminal) |
| 28 | DELETE | `/listings/{id}` | Yes | Owner | Delete listing |
| 29 | GET | `/owner/listings` | Yes | Owner | My listings (paginated, status/type filters) |
| 30 | GET | `/wishlist` | Yes | Renter | Saved listings |
| 31 | POST | `/wishlist/{id}/toggle` | Yes | Renter | Save/unsave → `{saved: bool}` |
| 32 | GET | `/chats` | Yes | Both | Inbox (includes chat `status`) |
| 33 | POST | `/chats` | Yes | Renter | Start chat request (`pending`) |
| 34 | GET | `/chats/{id}/messages` | Yes | Both | Messages + chat status |
| 35 | POST | `/chats/{id}/messages` | Yes | Both | Send message (403 unless `accepted`) |
| 36 | POST | `/chats/{id}/accept` | Yes | Owner | Accept chat request |
| 37 | POST | `/chats/{id}/reject` | Yes | Owner | Reject chat request |
| 38 | GET | `/notifications` | Yes | Both | Paginated list (+unread in meta) |
| 39 | GET | `/notifications/unread-count` | Yes | Both | Bell badge |
| 40 | PATCH | `/notifications/{id}/read` | Yes | Both | Mark one read |
| 41 | PATCH | `/notifications/read-all` | Yes | Both | Mark all read |
| 42 | POST | `/device/fcm-token` | Yes | Both | Register push token (web: `device_type:"web"`) |
| 43 | PATCH | `/user/location` | Yes | Both | Update GPS (powers nearby alerts; skip for guests) |

\* Browsing works unauthenticated (guest mode); send the Bearer token when you have one.

---

## 21. Web Implementation Checklist

**Routing / pages**
- [ ] Public: landing/discovery (guest browse), map/nearby, login, register wizard (3 steps), onboarding-equivalent
- [ ] Auth-gated: listing detail, wishlist, chat inbox + thread, notifications, profile
- [ ] Owner: dashboard, my listings (status chips + pagination), create-listing wizard (5 steps), edit listing, listing detail per-status views
- [ ] Guest gating modal (3 message variants, §3) + `?next=` redirect after login

**Core plumbing**
- [ ] HTTP client with: Bearer header injection, response-envelope unwrapping, global 401 → refresh → retry interceptor
- [ ] Relative image URL resolver
- [ ] Token + user persistence (localStorage equivalent of the mobile cache)
- [ ] Client-side image validation/compression to ≤ 200 KB before upload

**Feature parity details**
- [ ] 500 ms search debounce; 0–80k price slider semantics; filter count badge; reset
- [ ] Geo cascade with child-clearing
- [ ] Optimistic wishlist toggle with reconciliation
- [ ] coord_x/coord_y convention on map features; Nominatim reverse geocoding with custom User-Agent
- [ ] Status-driven owner UI (lock pending, warn before editing active, rejection-reason card)
- [ ] Chat status state machine UI (hide input unless `accepted`; owner accept/reject buttons; poll while open)
- [ ] Firebase Web SDK push (VAPID key + service worker), token registration after login, tap-navigation by `kind`/`reference_id`
- [ ] Browser geolocation → `PATCH /user/location` (logged-in only)
- [ ] Logout confirmation + Google sign-out; delete-account destructive confirmation

---

*Generated from the production mobile app source code (June 10, 2026). Where older docs disagree (e.g. `submitted`/`approved` statuses in `FLATNEST_API_DOCS.md`), THIS document reflects the live behavior.*
