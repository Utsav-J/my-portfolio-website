import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationSquare extends StatefulWidget {
  const LocationSquare({super.key});

  @override
  State<LocationSquare> createState() => _LocationSquareState();
}

class _LocationSquareState extends State<LocationSquare> {
  late Future<String> imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = _retrieveImageUrl();
  }

  Future<String> _retrieveImageUrl() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot documentSnapshot = await firestore
        .collection('data')
        .doc('location')
        .get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return data['mapImageUrl'] as String;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: imageUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading image'));
        } else if (snapshot.hasData) {
          return Image.network(snapshot.data as String);
        }
        return const Center(child: Text('Error loading image'));
      },
    );
  }
}
