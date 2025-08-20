import 'package:flutter/material.dart';

class UtsavMemoji extends StatelessWidget {
  const UtsavMemoji({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      ],
    );
  }
}
