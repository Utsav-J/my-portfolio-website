import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'spotify_iframe_stub.dart'
    if (dart.library.html) 'spotify_iframe_web.dart'
    as iframe;

class SpotifyMusicFrame extends StatefulWidget {
  const SpotifyMusicFrame({super.key, this.trackUrl});

  final String? trackUrl;

  @override
  State<SpotifyMusicFrame> createState() => _SpotifyMusicFrameState();
}

class _SpotifyMusicFrameState extends State<SpotifyMusicFrame> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _iframeUrl;
  Widget? _embed;

  Future<String?> _getRandomTrackUrlFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('spotify')
          .get();
      if (snapshot.docs.isEmpty) return null;
      final randomIndex = Random().nextInt(snapshot.docs.length);
      final data = snapshot.docs[randomIndex].data();
      final trackUrl = data['track_url'];
      if (trackUrl is String && trackUrl.isNotEmpty) return trackUrl;
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOEmbed();
  }

  Future<void> _fetchOEmbed() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? trackUrl = widget.trackUrl;

    trackUrl ??= await _getRandomTrackUrlFromFirestore();

    trackUrl ??= 'https://open.spotify.com/track/4PTG3Z6ehGkBFwjybzWkR8';
    final uri = Uri.parse(
      'https://open.spotify.com/oembed?url=${Uri.encodeComponent(trackUrl)}',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final iframeUrl = data['iframe_url'] as String?;

      if (iframeUrl == null || iframeUrl.isEmpty) {
        throw Exception('Missing iframe_url in response');
      }

      final embed = kIsWeb ? iframe.buildSpotifyIFrame(iframeUrl) : null;

      if (!mounted) return;
      setState(() {
        _iframeUrl = iframeUrl;
        _embed = embed;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load Spotify embed';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: _buildContent()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: Text(
                "here's a song recommendation",
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (kIsWeb && _iframeUrl != null && _embed != null) {
      return SizedBox.expand(child: _embed);
    }

    // Non-web fallback message
    return const Center(
      child: Text(
        'Spotify embed is available on this web builds',
        style: TextStyle(color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    );
  }
}
