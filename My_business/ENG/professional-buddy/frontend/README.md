# Professional Buddy — Flutter App

## What's included
- Login / Sign up (JWT-based, token persisted with `shared_preferences`)
- Home tab: buddy list with online status, unread badges, buddy requests
- Search & add buddies
- Chats tab: conversation list, sorted by most recent
- Real-time 1:1 chat screen (WebSocket)
- Profile / account menu

## 1. Setup

```bash
cd frontend
flutter pub get
```

## 2. Point the app at your backend

Edit `lib/services/api_client.dart` default, or pass at run/build time:

```bash
# Android emulator (10.0.2.2 maps to your host machine's localhost)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# iOS simulator
flutter run --dart-define=API_BASE_URL=http://localhost:8000

# Real device / production
flutter run --dart-define=API_BASE_URL=https://your-api-domain.com
```

## 3. Run

```bash
flutter run
```

## Project structure

```
lib/
  main.dart                    # app entrypoint, providers, auth routing
  theme/app_theme.dart         # dark theme, brand colors
  models/                      # AppUser, ChatMessage, Buddy, BuddyRequestModel
  services/
    api_client.dart            # HTTP wrapper + token storage
    auth_service.dart          # register/login/logout, current user state
    buddy_service.dart         # search, requests, buddy list
    chat_service.dart          # message history + WebSocket live chat
  screens/
    login_screen.dart
    signup_screen.dart
    home_screen.dart           # bottom nav shell
    buddy_list_screen.dart     # Home tab
    search_buddy_screen.dart
    pending_requests_screen.dart
    chat_list_screen.dart      # Chats tab
    chat_detail_screen.dart    # 1:1 chat
    profile_screen.dart        # account menu
  widgets/
    user_avatar.dart           # colored-initial avatar w/ online dot
```

## Next: adding calling (Agora)

Once you're ready:
```bash
flutter pub add agora_rtc_engine
```
Get a token from your backend's `/calls/token` endpoint (see backend README), then join a channel with `RtcEngine`. A `CallScreen` can be added alongside `chat_detail_screen.dart` and triggered from a phone icon in the chat app bar.
