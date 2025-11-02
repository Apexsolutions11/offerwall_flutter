import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../offerwall_flutter.dart';

/// A widget that displays the offerwall in a WebView
class OfferwallWebView extends StatefulWidget {
  /// Callback when the offerwall is closed
  final VoidCallback? onClose;

  /// Callback when an offer is clicked
  final Function(String offerId)? onOfferClick;

  /// Initial URL override (optional, will use offerwall URL if not provided)
  final String? initialUrl;

  /// Enable JavaScript (default: true)
  final bool javaScriptEnabled;

  /// Show loading indicator (default: true)
  final bool showLoading;

  const OfferwallWebView({
    super.key,
    this.onClose,
    this.onOfferClick,
    this.initialUrl,
    this.javaScriptEnabled = true,
    this.showLoading = true,
  });

  @override
  State<OfferwallWebView> createState() => _OfferwallWebViewState();
}

class _OfferwallWebViewState extends State<OfferwallWebView> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  double _loadingProgress = 0.0;

  String? get _url {
    return widget.initialUrl ?? OfferwallFlutter.instance.getOfferwallUrl();
  }

  @override
  Widget build(BuildContext context) {
    final url = _url;

    if (url == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Offerwall'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Offerwall not initialized',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Please initialize the plugin and set authentication credentials',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offerwall'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onClose?.call();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: widget.javaScriptEnabled,
              domStorageEnabled: true,
              useHybridComposition: true,
              thirdPartyCookiesEnabled: true,
              allowsInlineMediaPlayback: true,
              mediaPlaybackRequiresUserGesture: false,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
                _loadingProgress = 0.0;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _loadingProgress = progress / 100;
                if (progress >= 100) {
                  _isLoading = false;
                }
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
            },
            onReceivedError: (controller, request, error) {
              debugPrint('WebView error: ${error.description}');
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri != null) {
                final uriString = uri.toString();
                // Handle offer clicks
                if (uriString.contains('/') && uriString != url) {
                  // Extract offer ID from URL if possible
                  final segments = uri.pathSegments;
                  if (segments.isNotEmpty) {
                    final offerId = segments.last;
                    if (offerId.isNotEmpty && offerId != 'offers') {
                      widget.onOfferClick?.call(offerId);
                    }
                  }
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (widget.showLoading && _isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _loadingProgress,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Loading... ${(_loadingProgress * 100).toInt()}%',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
