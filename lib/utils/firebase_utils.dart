import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves the about me summary text from Firestore
  ///
  /// Returns a Future<String> containing the summary text
  /// Throws an exception if the document or field doesn't exist
  static Future<String> getAboutMeSummary() async {
    try {
      // Get the document from the 'data' collection with ID 'aboutMe'
      DocumentSnapshot document = await _firestore
          .collection('data')
          .doc('aboutMe')
          .get();

      if (document.exists) {
        // Extract the 'summary' field from the document
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        if (data.containsKey('summary')) {
          return data['summary'] as String;
        } else {
          throw Exception('Summary field not found in aboutMe document');
        }
      } else {
        throw Exception('aboutMe document not found in data collection');
      }
    } catch (e) {
      // Re-throw the exception with more context
      throw Exception('Failed to retrieve about me summary: $e');
    }
  }

  /// Alternative method that returns null instead of throwing an exception
  /// Useful when you want to handle missing data gracefully
  static Future<String?> getAboutMeSummaryOrNull() async {
    try {
      DocumentSnapshot document = await _firestore
          .collection('data')
          .doc('aboutMe')
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return data['summary'] as String?;
      }
      return null;
    } catch (e) {
      // Log the error but return null instead of throwing
      print('Error retrieving about me summary: $e');
      return null;
    }
  }
}
