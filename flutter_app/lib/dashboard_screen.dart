import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onWebThemeChanged;

  const DashboardScreen({Key? key, required this.isDark, required this.onWebThemeChanged})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  String _buildUrl(bool isDark) {
    return 'http://10.0.2.2:4200?theme=${isDark ? 'dark' : 'light'}';
  }

  @override
  void initState() {
    super.initState();
    _createController(widget.isDark);
  }

  Future<void> _createController(bool isDark) async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('ThemeChannel', onMessageReceived: (msg) async {
        final payload = msg.message; // expected 'dark' or 'light'
        final bool newDark = payload == 'dark';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('darkMode', newDark);
        // inform parent so it can update MaterialApp theme
        widget.onWebThemeChanged(newDark);
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(_buildUrl(isDark)));

    setState(() => _controller = controller);
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if Flutter's theme changed, reload the webview with the new param
    if (oldWidget.isDark != widget.isDark && _controller != null) {
      _controller!.loadRequest(Uri.parse(_buildUrl(widget.isDark)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          if (_controller != null)
            WebViewWidget(controller: _controller!)
          else
            const Center(child: CircularProgressIndicator()),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
