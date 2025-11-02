# Offerwall Flutter Plugin

A Flutter plugin to integrate the offerwall web app into Flutter applications. This plugin provides a seamless way to display the offerwall web interface and interact with the offerwall API from your Flutter app.

## Features

- 🌐 Display the offerwall in a WebView with full authentication
- 📱 Native Android and iOS support
- 🔐 Automatic authentication token management
- 📊 Access to offerwall API methods
- 💾 Persistent credential storage
- 🎨 Customizable WebView widget

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  offerwall_flutter:
    path: ../flutter_plugin  # or use git/pub.dev when published
```

Then run:

```bash
flutter pub get
```

### Android Setup

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Setup

Add the following to your `ios/Podfile` (if not already present):

```ruby
platform :ios, '12.0'
```

Then run:

```bash
cd ios && pod install && cd ..
```

## Usage

### 1. Initialize the Plugin

First, initialize the plugin with your offerwall base URL:

```dart
import 'package:offerwall_flutter/offerwall_flutter.dart';

// Initialize the plugin
await OfferwallFlutter.instance.initialize(
  baseUrl: 'https://your-offerwall-domain.com',
);
```

### 2. Set Authentication Credentials

Set the user's Firebase authentication credentials:

```dart
await OfferwallFlutter.instance.setAuthCredentials(
  userId: 'user-firebase-uid',
  authToken: 'firebase-id-token',
);
```

### 3. Display the Offerwall

You can display the offerwall using the provided widget:

```dart
import 'package:offerwall_flutter/offerwall_flutter.dart';

// In your widget
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OfferwallWebView(
      onClose: () {
        Navigator.pop(context);
      },
      onOfferClick: (offerId) {
        print('Offer clicked: $offerId');
        // Handle offer click
      },
    ),
  ),
);
```

Or navigate to it directly:

```dart
final url = OfferwallFlutter.instance.getOfferwallUrl();
if (url != null) {
  // Navigate to URL using WebView or URL launcher
}
```

### 4. Use API Methods

The plugin provides several API methods to interact with the offerwall:

```dart
// Get available offers
final offers = await OfferwallFlutter.instance.getOffers();

// Get ongoing offers
final ongoingOffers = await OfferwallFlutter.instance.getOngoingOffers();

// Get offer history
final history = await OfferwallFlutter.instance.getOfferHistory();

// Get specific offer details
final offerDetail = await OfferwallFlutter.instance.getOfferDetail('offer-id');

// Get user profile
final user = await OfferwallFlutter.instance.getUserProfile();

// Get user balance
final balance = await OfferwallFlutter.instance.getUserBalance();
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:offerwall_flutter/offerwall_flutter.dart';

class OfferwallScreen extends StatefulWidget {
  @override
  _OfferwallScreenState createState() => _OfferwallScreenState();
}

class _OfferwallScreenState extends State<OfferwallScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeOfferwall();
  }

  Future<void> _initializeOfferwall() async {
    try {
      // Initialize the plugin
      await OfferwallFlutter.instance.initialize(
        baseUrl: 'https://your-offerwall-domain.com',
      );

      // Set auth credentials (get these from your Firebase auth)
      await OfferwallFlutter.instance.setAuthCredentials(
        userId: 'user-firebase-uid',
        authToken: 'firebase-id-token',
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing offerwall: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return OfferwallWebView(
      onClose: () {
        Navigator.pop(context);
      },
      onOfferClick: (offerId) {
        print('Offer clicked: $offerId');
      },
    );
  }
}
```

## API Reference

### OfferwallFlutter

#### Methods

- `initialize({required String baseUrl})` - Initialize the plugin with base URL
- `setAuthCredentials({required String userId, required String authToken})` - Set authentication credentials
- `clearAuthCredentials()` - Clear stored credentials
- `getOfferwallUrl()` - Get the offerwall URL with auth parameters
- `getOffers()` - Get available offers
- `getOngoingOffers()` - Get ongoing offers
- `getOfferHistory()` - Get offer history
- `getOfferDetail(String offerId)` - Get specific offer details
- `getUserProfile()` - Get user profile
- `getUserBalance()` - Get user balance

#### Properties

- `baseUrl` - Get the configured base URL
- `userId` - Get current user ID
- `authToken` - Get current auth token
- `isInitialized` - Check if plugin is initialized
- `isAuthenticated` - Check if user is authenticated

### OfferwallWebView Widget

#### Parameters

- `onClose` - Callback when the offerwall is closed
- `onOfferClick` - Callback when an offer is clicked
- `initialUrl` - Optional custom initial URL
- `javaScriptEnabled` - Enable JavaScript (default: true)
- `showLoading` - Show loading indicator (default: true)

## Models

### Offer

```dart
class Offer {
  final String id;
  final String name;
  final String category;
  final String? photoUid;
  final String? photoUrl;
  final String? description;
  final int? coins;
  final int? diamonds;
}
```

### OfferDetail

```dart
class OfferDetail {
  final String id;
  final String name;
  final String category;
  final String? photoUrl;
  final String? description;
  final int? coins;
  final int? diamonds;
  final List<dynamic>? steps;
  final String? terms;
  final OfferStatus? status;
  final String url;
  final bool? isCompleted;
  final bool? isStarted;
}
```

### User

```dart
class User {
  final String uid;
  final String displayName;
  final String email;
  final bool emailVerified;
  final String? photoURL;
  final String? country;
  final String? appName;
  // ... more fields
}
```

## Error Handling

The plugin throws exceptions when:

- Plugin is not initialized before use
- User is not authenticated before API calls
- API requests fail

Always wrap API calls in try-catch blocks:

```dart
try {
  final offers = await OfferwallFlutter.instance.getOffers();
  // Handle offers
} catch (e) {
  print('Error: $e');
  // Handle error
}
```

## License

See LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
