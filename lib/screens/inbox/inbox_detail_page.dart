import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/webview_bootstrap.dart';
import '../../models/inbox_message.dart';

class InboxDetailPage extends StatefulWidget {
  const InboxDetailPage({super.key, required this.message});

  final InboxMessage message;

  @override
  State<InboxDetailPage> createState() => _InboxDetailPageState();
}

class _InboxDetailPageState extends State<InboxDetailPage> {
  late final WebViewController _controller;

  bool _isOffline = false;
  bool _isLoading = true;
  bool _hasLoadedPage = false;

  @override
  void initState() {
    super.initState();
    _controller = createWebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _hasLoadedPage = true;
              _isOffline = false;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame ?? false) {
              _handleConnectionIssue();
            }
          },
        ),
      );

    _loadPage();
  }

  Future<void> _loadPage() async {
    final isConnected = await _hasInternetConnection();
    if (!isConnected) {
      if (mounted) {
        setState(() {
          _isOffline = true;
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() => _isOffline = false);
    }

    await _controller.loadRequest(Uri.parse(widget.message.url));
  }

  Future<void> _retry() async {
    setState(() => _isLoading = true);

    final isConnected = await _hasInternetConnection();
    if (!isConnected) {
      if (mounted) {
        setState(() {
          _isOffline = true;
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() => _isOffline = false);
    }

    if (_hasLoadedPage) {
      await _controller.reload();
    } else {
      await _controller.loadRequest(Uri.parse(widget.message.url));
    }
  }

  Future<bool> _hasInternetConnection() async {
    final results = await Connectivity().checkConnectivity();
    if (results.isEmpty) {
      return true;
    }

    return results.any((result) => result != ConnectivityResult.none);
  }

  void _handleConnectionIssue() {
    if (!mounted) return;
    setState(() {
      _isOffline = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _InboxConnectionErrorView(onRetry: _retry),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.message.title)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      ),
    );
  }
}

class _InboxConnectionErrorView extends StatelessWidget {
  const _InboxConnectionErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'CONNECTION ERROR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sorry, we are unable to load this content. '
                      'Please refresh or try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.45,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'RETRY',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
