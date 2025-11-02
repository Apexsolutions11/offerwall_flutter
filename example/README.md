# Offerwall Flutter Example

This is an example Flutter app demonstrating how to use the `offerwall_flutter` plugin.

## Setup

1. Update the base URL in `lib/main.dart`:
   ```dart
   await OfferwallFlutter.instance.initialize(
     baseUrl: 'https://your-offerwall-domain.com',
   );
   ```

2. Update the authentication credentials:
   ```dart
   await OfferwallFlutter.instance.setAuthCredentials(
     userId: 'your-firebase-user-id',
     authToken: 'your-firebase-id-token',
   );
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Features Demonstrated

- Plugin initialization
- Setting authentication credentials
- Opening the offerwall in a WebView
- Testing API calls (getOffers, getUserProfile, getUserBalance)
