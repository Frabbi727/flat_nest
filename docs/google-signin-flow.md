# FlatNest — Google Sign-In Flow Documentation

## Overview

Google Sign-In uses a single endpoint (`POST /auth/google`) for both **new user registration** and **returning user login**. The backend determines which scenario applies based on whether the Google email already exists in the database. The frontend then routes the user based on the `is_complete` and `role` fields in the response.

---

## API Endpoint

```
POST /auth/google
Content-Type: application/json
```

**Request Body:**
```json
{
  "id_token": "<Google ID Token from OAuth>"
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
      "email": "john@gmail.com",
      "phone": null,
      "role": null,
      "avatar": null,
      "is_complete": false
    }
  }
}
```

> `registration_step`, `role`, `is_complete`, and `avatar` values differ per scenario — see below.

---

## The 3 Scenarios

---

### Scenario 1 — Brand New User (Never Registered)

The user has **no account** with FlatNest at all.

**What happens:**
1. User taps "Continue with Google"
2. Google OAuth returns an `id_token`
3. App calls `POST /auth/google` with the token
4. Backend finds **no existing account** for this Google email
5. Backend **auto-creates a new account** using the Google profile (name, email, avatar from Google)
6. Response returns `is_complete: false` and `role: null`
7. App saves tokens and user data
8. App navigates user to **Registration Step 2** (Role Selection)

**Response shape:**
```json
{
  "user": {
    "role": null,
    "is_complete": false
  }
}
```

**Navigation:**
```
POST /auth/google
       ↓
  is_complete = false
  role = null
       ↓
  Register Step 2 (Role Selection)
       ↓
  PATCH /auth/register/details { "role": "renter" }
       ↓
  Register Step 3 (Avatar Upload)
       ↓
  PATCH /auth/register/avatar
       ↓
  Home (owner/renter)
```

> Note: The Google profile photo may be used as the initial avatar by the backend. The user is still required to complete Step 3 (avatar upload) unless the backend pre-populates it from Google.

---

### Scenario 2 — Returning Google User (Already Registered with Google)

The user previously signed up via Google and is now logging in again.

**What happens:**
1. User taps "Continue with Google"
2. Google OAuth returns the `id_token` (may show account picker or auto-select cached account)
3. App calls `POST /auth/google`
4. Backend finds an existing account with matching Google email and `is_complete: true`
5. Response returns `is_complete: true` and `role: "owner"` or `"renter"`
6. App saves updated tokens
7. App navigates directly to the role-specific home screen — **no registration steps shown**

**Response shape:**
```json
{
  "user": {
    "role": "renter",
    "is_complete": true
  }
}
```

**Navigation:**
```
POST /auth/google
       ↓
  is_complete = true
       ↓
  role === "owner" → /owner/home
  role === "renter" → /renter/home
```

---

### Scenario 3 — Email Already Registered via Email/Password

The user previously created an account using email + password with the **same email address** as their Google account.

**What happens:**
1. User taps "Continue with Google"
2. App calls `POST /auth/google`
3. Backend detects a conflict — the email exists but is tied to an email/password account, not Google
4. Backend returns an error
5. App shows the error message on the Login screen
6. User remains on the Login screen — **no navigation, no account creation**

**Account linking is NOT supported** — Google and email/password are separate auth methods.

**Response shape:**
```json
{
  "success": false,
  "message": "An account with this email already exists. Please sign in with your email and password.",
  "code": "EMAIL_ACCOUNT_EXISTS"
}
```

**What the user should do:** Sign in with email/password instead.

---

## Post-Auth Navigation Logic (Decision Tree)

This is the single decision point that all auth methods (email/password + Google) share after a successful response:

```
After receiving AuthResponse
         ↓
  is_complete === false?
    ├── YES → role === null?
    │           ├── YES → Go to Register Step 2 (Role Selection)
    │           └── NO  → Go to Register Step 3 (Avatar Upload)
    └── NO  → role === "owner"?
                ├── YES → /owner/home
                └── NO  → /renter/home
```

---

## Special UX: "USE_GOOGLE_SIGN_IN" Error Hint

When a user tries to log in with **email + password** but their account was originally created via Google:

1. Backend returns error code: `USE_GOOGLE_SIGN_IN`
2. The UI transforms the login form:
   - Password field is **hidden**
   - Login button is **hidden**
   - Google button is **highlighted** with the primary brand color
   - Button text changes to **"Continue with Google"**
3. User is guided to tap the Google button to proceed

This provides a friendly recovery path instead of a generic error message.

---

## Google Sign-Out Behavior

When the user logs out:
- App tokens (`access_token`, `refresh_token`) are cleared from secure storage
- `GoogleSignIn.signOut()` is called — this **clears the cached Google session**
- Next time the user taps "Continue with Google", the **account picker is shown** (they must re-select their account)

> If `GoogleSignIn.disconnect()` were used instead, the app loses permission entirely and requires full re-authorization. The app uses `signOut()` intentionally.

---

## Incomplete Google Registration Recovery

If a user completes Google auth (Step 1) but closes the app before completing Steps 2 or 3:

1. On next login via Google, `POST /auth/google` responds with `is_complete: false`
2. `registration_step` in the response tells the app which step to resume from
3. App routes the user back to the correct step automatically

| `registration_step` value | Redirect to |
|---------------------------|-------------|
| `1` | Step 2 — Role Selection |
| `2` | Step 3 — Avatar Upload |

---

## Summary Table

| Scenario | Account exists? | `is_complete` | `role` | Navigation |
|----------|----------------|---------------|--------|------------|
| New user via Google | No — auto-created | `false` | `null` | Step 2 (Role Selection) |
| Returning Google user | Yes (Google) | `true` | `"owner"` / `"renter"` | Owner/Renter Home |
| Email/password conflict | Yes (email/password) | N/A | N/A | Error shown, stays on Login |
| Google user mid-flow | Yes (Google, incomplete) | `false` | `null` or set | Step 2 or Step 3 |

---

## Notes for Web Implementation

- Use **Google Identity Services** (GIS) or a package like `@react-oauth/google` to obtain the `id_token`
- Send only `{ "id_token": "..." }` to the backend — no other fields needed
- All routing decisions are driven by `user.is_complete` and `user.role` in the response
- There is **no separate** "register with Google" vs "login with Google" endpoint — it's one unified call
- After a successful Google auth that returns `is_complete: false`, the web app must continue with the same 2-step wizard (role selection → avatar upload) as the email/password registration flow
- On Google sign-out, call `google.accounts.id.disableAutoSelect()` to clear the cached Google session so the account picker reappears next time
