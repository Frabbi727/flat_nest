# FlatNest — Registration Process Documentation

## Overview

Registration is a **3-step wizard** flow. The user creates an account in Step 1, then enriches their profile in Steps 2 and 3 before landing on their role-specific home screen.

---

## Base URL

```
https://flatnest.techrealify.com/api/v1
```

---

## Step 1 — Basic Information

### UI Fields

| Field | Type | Label | Prefix |
|-------|------|-------|--------|
| `name` | text | Full Name | — |
| `email` | email | Email Address | — |
| `password` | password | Password | — |
| `password_confirmation` | password | Confirm Password | — |
| `phone` | tel | Phone Number | `+88` (fixed) |

### Validation Rules

| Field | Rule |
|-------|------|
| `name` | Required. Must contain at least **2 words** (first + last name) |
| `email` | Required. Must be a valid email format |
| `password` | Required. Minimum **8 characters**. Strength meter shows 4 levels |
| `password_confirmation` | Required. Must **exactly match** password |
| `phone` | Required. Exactly **11 digits** (Bangladesh format: `01XXXXXXXXX`) |

### Password Strength Levels

| Level | Criteria |
|-------|----------|
| 1 — Weak | 8+ characters |
| 2 — Fair | 8+ chars + uppercase letter |
| 3 — Good | 8+ chars + uppercase + digit |
| 4 — Strong | 8+ chars + uppercase + digit + special character |

### API Call

```
POST /auth/register
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "Passw0rd!",
  "password_confirmation": "Passw0rd!",
  "phone": "01712345678"
}
```

**Success Response `200`:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "registration_step": 1,
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "01712345678",
      "role": null,
      "avatar": null,
      "is_complete": false
    }
  }
}
```

**After success:** Save `access_token` and `refresh_token`. Proceed to Step 2.

---

## Step 2 — Role Selection

### Fetch Available Roles First

```
GET /meta/roles
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "success": true,
  "data": [
    { "value": "renter", "label": "Renter" },
    { "value": "owner", "label": "Owner" }
  ]
}
```

### Role Cards UI

| Role | Tag | Description | Badge |
|------|-----|-------------|-------|
| `renter` | Find a flat | Browse listings, save favorites, message owners | Free |
| `owner` | List my flat | Post property, manage inquiries, rent faster | Verified listings |

### API Call

```
PATCH /auth/register/details
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "role": "renter"
}
```

**Success Response `200`:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "registration_step": 2,
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "01712345678",
      "role": "renter",
      "avatar": null,
      "is_complete": false
    }
  }
}
```

---

## Step 3 — Profile Photo Upload

### UI

- Upload photo from device (camera or file picker)
- Preview the selected photo before submitting
- Image should be compressed before upload (recommended max ~500KB)

### API Call

```
PATCH /auth/register/avatar
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
```

**Request Body (FormData):**
```
avatar: <image file>
```

**Success Response `200`:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "registration_step": 3,
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "01712345678",
      "role": "renter",
      "avatar": "https://flatnest.techrealify.com/storage/avatars/john.jpg",
      "is_complete": true
    }
  }
}
```

---

## Post-Registration Navigation

After Step 3, check `user.role` and redirect:

```
user.role === "owner"  →  /owner/home
user.role === "renter" →  /renter/home
```

---

## Standard Error Response Format

All API errors follow this structure:

```json
{
  "success": false,
  "message": "The email has already been taken.",
  "code": "VALIDATION_ERROR",
  "errors": {
    "email": ["The email has already been taken."],
    "phone": ["The phone number must be 11 digits."]
  }
}
```

---

## Token Management

| Token | Storage | Purpose |
|-------|---------|---------|
| `access_token` | localStorage / httpOnly cookie | Sent as `Authorization: Bearer {token}` on every API request |
| `refresh_token` | localStorage / httpOnly cookie | Used to get a new access token when it expires |

### Refresh Token Flow

```
POST /auth/refresh
Content-Type: application/json

{ "refresh_token": "eyJ..." }
```

Returns a new `access_token`. If refresh fails (401), clear tokens and redirect to `/login`.

---

## Other Auth Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/login` | Email + password login |
| `POST` | `/auth/google` | Google OAuth — body: `{ "id_token": "..." }` |
| `POST` | `/auth/logout` | Invalidate tokens |
| `POST` | `/auth/refresh` | Refresh access token |
| `DELETE` | `/auth/account` | Delete account |

---

## Complete Registration Flow Diagram

```
Landing / Login Page
       ↓
  [Create Account]
       ↓
┌─────────────────────────────────┐
│  STEP 1 – Basic Info            │
│  name, email, password, phone   │
│  POST /auth/register            │
│  → Save access_token            │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│  STEP 2 – Role Selection        │
│  GET /meta/roles                │
│  User picks: owner / renter     │
│  PATCH /auth/register/details   │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│  STEP 3 – Profile Photo         │
│  User uploads avatar            │
│  PATCH /auth/register/avatar    │
│  user.is_complete = true        │
└──────────────┬──────────────────┘
               ↓
     Check user.role
    ┌────────────────┐
    ↓                ↓
 owner            renter
/owner/home    /renter/home
```

---

## Incomplete Registration Recovery

If a user closes the browser mid-flow, detect incomplete registration on login:

```
POST /auth/login → user.is_complete === false
  → redirect to the incomplete registration step
  → registration_step value tells you which step to resume
```

---

## Notes for Web Implementation

- No OTP or email verification — registration is instant after Step 1.
- Google Sign-In is supported as an alternative (sends `id_token` to `/auth/google`).
- The phone field always uses `+88` as a fixed country code prefix — store only the 11-digit local number.
- Steps 2 and 3 can be skipped if the user closes mid-flow; resume from `registration_step` on next login.
- After any successful login, check `user.is_complete`. If `false`, redirect to registration step `registration_step + 1`.
