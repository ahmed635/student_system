# Firebase Setup Instructions

This document provides step-by-step instructions to configure Firebase for the Student Management System.

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- A Google account

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `student-system` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Configure Firebase for Android

1. In Firebase Console, click the Android icon to add an Android app
2. Enter Android package name: `com.example.student_system` (or your actual package name from `android/app/build.gradle`)
3. Enter app nickname: `Student System Android` (optional)
4. Download the `google-services.json` file
5. Place `google-services.json` in `android/app/` directory

### Update Android Configuration Files

Already configured in the project:
- ✅ Firebase dependencies in `pubspec.yaml`
- ⚠️ Need to add to `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

- ⚠️ Need to add to `android/app/build.gradle`:
```gradle
// Add at the bottom of the file
apply plugin: 'com.google.gms.google-services'
```

## Step 3: Configure Firebase for iOS

1. In Firebase Console, click the iOS icon to add an iOS app
2. Enter iOS bundle ID (from `ios/Runner.xcodeproj`)
3. Enter app nickname: `Student System iOS` (optional)
4. Download the `GoogleService-Info.plist` file
5. Open `ios/Runner.xcworkspace` in Xcode
6. Right-click on `Runner` folder and select "Add Files to Runner"
7. Select the downloaded `GoogleService-Info.plist` file
8. Make sure "Copy items if needed" is checked

## Step 4: Initialize Firebase with FlutterFire CLI (Alternative Method)

For easier setup, you can use FlutterFire CLI:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter app
flutterfire configure

# Select your Firebase project and platforms (Android/iOS)
```

## Step 5: Enable Firebase Services

### Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" authentication

### Enable Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" for development (remember to secure it later)
4. Select your preferred location
5. Click "Enable"

### Enable Firebase Storage (Optional)

1. In Firebase Console, go to "Storage"
2. Click "Get started"
3. Choose security rules (start with test mode for development)
4. Select your preferred location
5. Click "Done"

## Step 6: Configure Firestore Security Rules

For production, update your Firestore rules in Firebase Console > Firestore Database > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write their own data
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 7: Run the Application

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Troubleshooting

### Common Issues and Solutions

1. **MinSdkVersion Error**: 
   - Update `android/app/build.gradle`: `minSdkVersion 21` or higher

2. **MultiDex Error**:
   - Add to `android/app/build.gradle`:
   ```gradle
   android {
       defaultConfig {
           multiDexEnabled true
       }
   }
   ```

3. **iOS Build Errors**:
   ```bash
   cd ios
   pod install
   pod update
   ```

4. **Firebase Initialization Error**:
   - Ensure `Firebase.initializeApp()` is called in `main.dart`
   - Check that configuration files are in the correct locations

## Security Reminders

⚠️ **Important for Production:**

1. Update Firestore security rules to restrict access appropriately
2. Enable App Check for additional security
3. Configure proper authentication rules
4. Never commit Firebase configuration files to public repositories
5. Use environment variables for sensitive configuration

## Testing the Integration

1. Run the app
2. Try to register a new account
3. Check Firebase Console > Authentication to see the new user
4. Try to login with the created account
5. Create a group/student and check Firestore Database for the data

## Additional Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)