import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_text_styles.dart';
import '../theme/flat_nest_theme.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({super.key, required this.title, required this.url});

  static Future<void> open(BuildContext context, {required String title, required String url}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewScreen(title: title, url: url),
      ),
    );
  }

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() { _loading = true; _hasError = false; }),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (_) => setState(() { _loading = false; _hasError = true; }),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: t.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: t.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: _loading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(
                  color: t.primary,
                  backgroundColor: t.borderSoft,
                  minHeight: 2,
                ),
              )
            : null,
      ),
      body: _hasError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 40, color: t.inkSoft),
                  const SizedBox(height: 12),
                  Text(
                    'Could not load the page',
                    style: AppTextStyles.bodyMedium.copyWith(color: t.inkMid),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() { _loading = true; _hasError = false; });
                      _controller.loadRequest(Uri.parse(widget.url));
                    },
                    child: Text('Retry', style: TextStyle(color: t.primary)),
                  ),
                ],
              ),
            )
          : WebViewWidget(controller: _controller),
    );
  }
}
