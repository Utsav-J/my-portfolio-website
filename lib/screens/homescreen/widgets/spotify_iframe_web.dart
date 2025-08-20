// Web implementation for building a Spotify iframe using HtmlElementView
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui;
import 'package:flutter/widgets.dart';

Widget buildSpotifyIFrame(String iframeUrl) {
  final viewTypeId = 'spotify-iframe-${DateTime.now().millisecondsSinceEpoch}';
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewTypeId, (int viewId) {
    final element = web.document.createElement('iframe') as web.HTMLIFrameElement
      ..src = iframeUrl
      ..style.border = '0'
      ..style.borderRadius = '12px'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      ..style.right = '0'
      ..style.bottom = '0'
      ..allow =
          'autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture'
      ..allowFullscreen = true
      ..loading = 'lazy';
    return element;
  });

  return HtmlElementView(viewType: viewTypeId);
}
