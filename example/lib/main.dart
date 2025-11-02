import 'package:flutter/material.dart';
import 'package:offerwall_flutter/offerwall_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeOfferwall();
  }

  Future<void> _initializeOfferwall() async {
    try {
      setState(() {
        _status = 'Initializing plugin...';
      });

      // TODO: Replace with your actual offerwall base URL
      await OfferwallFlutter.instance.initialize(
        baseUrl: 'https://your-offerwall-domain.com',
      );

      setState(() {
        _status = 'Setting auth credentials...';
      });

      // TODO: Replace with actual Firebase auth credentials
      // In a real app, you would get these from Firebase Auth
      await OfferwallFlutter.instance.setAuthCredentials(
        userId: 'example-user-id',
        authToken: 'example-auth-token',
      );

      setState(() {
        _isInitialized = true;
        _status = 'Ready!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _openOfferwall() async {
    if (!OfferwallFlutter.instance.isInitialized ||
        !OfferwallFlutter.instance.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offerwall not initialized or authenticated'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferwallWebView(
          onClose: () {
            Navigator.pop(context);
          },
          onOfferClick: (offerId) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Offer clicked: $offerId')),
            );
          },
        ),
      ),
    );
  }

  Future<void> _testApiCalls() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching offers...')),
      );

      final offers = await OfferwallFlutter.instance.getOffers();
      final user = await OfferwallFlutter.instance.getUserProfile();
      final balance = await OfferwallFlutter.instance.getUserBalance();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('API Test Results'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Offers: ${offers.length}'),
                Text('User: ${user.displayName}'),
                Text('Balance: ${balance.toString()}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offerwall Flutter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Offerwall Flutter Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isInitialized ? Icons.check_circle : Icons.hourglass_empty,
                  size: 64,
                  color: _isInitialized ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  _status,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: _isInitialized ? _openOfferwall : null,
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Open Offerwall'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isInitialized ? _testApiCalls : null,
                  icon: const Icon(Icons.api),
                  label: const Text('Test API Calls'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_isInitialized) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Initialized: ${OfferwallFlutter.instance.isInitialized}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Authenticated: ${OfferwallFlutter.instance.isAuthenticated}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  if (OfferwallFlutter.instance.userId != null)
                    Text(
                      'User ID: ${OfferwallFlutter.instance.userId}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
