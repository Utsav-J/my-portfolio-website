import 'dart:ui_web' as ui;
import "package:web/web.dart" as html;
import 'package:flutter/material.dart';

class GitHubStatsHtml extends StatefulWidget {
  final String username;

  const GitHubStatsHtml({super.key, required this.username});

  @override
  _GitHubStatsHtmlState createState() => _GitHubStatsHtmlState();
}

class _GitHubStatsHtmlState extends State<GitHubStatsHtml> {
  late String streakViewType;
  late String langViewType;

  @override
  void initState() {
    super.initState();
    streakViewType =
        'github-streak-${widget.username}-${DateTime.now().millisecondsSinceEpoch}';
    langViewType =
        'github-lang-${widget.username}-${DateTime.now().millisecondsSinceEpoch}';
    _registerViews();
  }

  void _registerViews() {
    // Register streak stats view
    ui.platformViewRegistry.registerViewFactory(streakViewType, (int viewId) {
      final img = html.HTMLImageElement()
        ..src =
            'https://nirzak-streak-stats.vercel.app/?user=${widget.username}&theme=tokyonight&hide_border=true'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'contain'
        ..style.border = 'none';

      return img;
    });
    // Register language stats view
    ui.platformViewRegistry.registerViewFactory(langViewType, (int viewId) {
      final img = html.ImageElement()
        ..src =
            'https://github-readme-stats.vercel.app/api/top-langs/?username=${widget.username}&theme=tokyonight&hide_border=true&include_all_commits=true&count_private=true&layout=compact'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'contain'
        ..style.border = 'none';

      return img;
    });
  }

  void refresh() {
    setState(() {
      streakViewType =
          'github-streak-${widget.username}-${DateTime.now().millisecondsSinceEpoch}';
      langViewType =
          'github-lang-${widget.username}-${DateTime.now().millisecondsSinceEpoch}';
      _registerViews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: 495,
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: HtmlElementView(viewType: streakViewType),
          ),
        ),

        // Language Stats
        Container(
          width: 300,
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: HtmlElementView(viewType: langViewType),
          ),
        ),
      ],
    );
  }
}
