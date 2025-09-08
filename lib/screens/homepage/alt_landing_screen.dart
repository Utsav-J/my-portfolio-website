import 'package:flutter/material.dart';
import 'package:portfolio/utils/firebase_utils.dart';

class AltLandingScreen extends StatefulWidget {
  const AltLandingScreen({super.key});

  @override
  State<AltLandingScreen> createState() => _AltLandingScreenState();
}

class _AltLandingScreenState extends State<AltLandingScreen> {
  late Future<String?> _aboutMeFuture;
  late Future<String?> _resumeFuture;

  @override
  void initState() {
    super.initState();
    _aboutMeFuture = FirebaseUtils.getAboutMeSummaryOrNull();
    _resumeFuture = FirebaseUtils.getResumeUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E0E10), Color(0xFF121214)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.phone_android, size: 20, color: Colors.white70),
                  SizedBox(width: 8),
                  Text(
                    'Optimized mobile view',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "You're seeing a mobile-optimized version tailored for smaller screens. The desktop experience includes windowed UI that doesn't translate well to phones, so this focused view ensures readability and performance.",
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: _aboutMeFuture,
                        builder: (context, snapshot) {
                          final text = snapshot.data ?? '';
                          return _Section(
                            title: 'About me',
                            child:
                                snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: LinearProgressIndicator(
                                      minHeight: 2,
                                    ),
                                  )
                                : Text(
                                    text.isEmpty ? '—' : text,
                                    style: const TextStyle(height: 1.4),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<String?>(
                        future: _resumeFuture,
                        builder: (context, snapshot) {
                          final url = snapshot.data;
                          return _Section(
                            title: 'Resume',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    (url == null || url.isEmpty)
                                        ? 'Unavailable'
                                        : url,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Note: Bypass is disabled to preserve layout integrity on small screens.',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
