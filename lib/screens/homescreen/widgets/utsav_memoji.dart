import 'package:flutter/material.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/screens/overlays/send_message_overlay.dart';

class UtsavMemoji extends StatelessWidget {
  const UtsavMemoji({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.transparent,
            builder: (context) => SendMessageOverlay(
              onSendMessage: (String message) async {
                // Handle the message
                print('Message: $message');
              },
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black12, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Image.asset("assets/images/memoji-removebg.png"),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'say hi',
                  style: AppDesign.caption1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1), // slight right & down
                        blurRadius: 3, // soft blur
                        color: Colors.black54, // semi-transparent black
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
