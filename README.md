# WhatsApp Clone — Flutter

A Flutter messaging-app project inspired by WhatsApp. The codebase is organized into modules for authentication, chats, groups, status, calls, and contact selection, with a responsive layout and Firebase initialization.

## Modules
- Authentication and landing screens
- Chat UI and message models
- Group and status areas
- Contact selection
- Call-related UI/integration
- Shared widgets and responsive layouts

## Tech stack
- Flutter and Dart
- Firebase Authentication, Cloud Firestore, and Firebase Storage
- Riverpod for state management
- Contact and media access packages
- Zego UIKit integration for call experiences

## Setup

1. Install Flutter and Android Studio/Xcode for your target platform.
2. Create or select a Firebase project and configure the Flutter app using the official FlutterFire tooling. Review `lib/firebase_options.dart`; don't commit service-account credentials.
3. Enable the Firebase services used by the app and apply suitable security rules.
4. Install packages and launch:

~~~bash
flutter pub get
flutter run
~~~

Calling and platform-specific media features may need additional provider credentials and device permissions. Review the configuration expected by the relevant feature before testing.

## Project structure
- `lib/features/` — auth, chat, group, status, call, contact selection, and landing modules
- `lib/common/` — reusable widgets
- `lib/models/` — app data models
- `lib/screens/` — layout and responsive screen components

This is a learning/project implementation; don't use it with real user data until authentication, Firebase rules, privacy, and call configuration have been reviewed.
