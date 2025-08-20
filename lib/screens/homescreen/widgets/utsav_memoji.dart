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
              colors: [Colors.white12, Colors.white70],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 0.5),
          ),
        ),
        Image.asset("assets/images/memoji-removebg.png"),
      ],
    );
  }
}
