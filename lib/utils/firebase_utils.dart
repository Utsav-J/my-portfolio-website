import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/models/models.dart';

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

  /// Retrieves the profile image URL from Firestore
  ///
  /// Returns a Future<String> containing the image URL
  /// Returns empty string if document doesn't exist or URL is not found
  static Future<String> getProfileImageUrl() async {
    try {
      final DocumentSnapshot profileImage = await _firestore
          .collection('images')
          .doc('aboutme')
          .get();
      if (profileImage.exists && profileImage.data() != null) {
        final Map<String, dynamic> data =
            profileImage.data() as Map<String, dynamic>;
        final String? imageUrl = data['url'] as String?;
        return imageUrl ?? "";
      }
      return "";
    } catch (e) {
      print('Error fetching profile image: $e');
      return "";
    }
  }

  /// Retrieves the resume URL from Firestore
  ///
  /// Returns a Future<String?> containing the resume URL
  /// Returns null if document doesn't exist or URL is not found
  static Future<String?> getResumeUrl() async {
    try {
      final DocumentSnapshot resumeDoc = await _firestore
          .collection('data')
          .doc('resume')
          .get();

      if (resumeDoc.exists && resumeDoc.data() != null) {
        final Map<String, dynamic> data =
            resumeDoc.data() as Map<String, dynamic>;
        final String? resumeUrl = data['url'] as String?;
        return resumeUrl;
      }
      return null;
    } catch (e) {
      print('Error fetching resume URL: $e');
      return null;
    }
  }

  /// Retrieves all projects from Firestore
  ///
  /// Returns a Future<List<Project>> containing all projects sorted by rank
  /// Throws an exception if the collection doesn't exist or data is invalid
  static Future<List<Project>> getProjects() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('projects')
          .get();

      List<Project> projects = querySnapshot.docs
          .map((doc) => Project.fromFirestore(doc))
          .toList();

      // Sort by rank (ascending)
      projects.sort((a, b) => a.rank.compareTo(b.rank));

      return projects;
    } catch (e) {
      throw Exception('Failed to retrieve projects: $e');
    }
  }

  /// Retrieves all education records from Firestore
  ///
  /// Returns a Future<List<Education>> containing education records in specified order
  /// Returns empty list if no documents are found
  static Future<List<Education>> getEducation() async {
    try {
      // Define the order we want to display
      final List<String> order = ['university', 'highschool', 'school'];
      List<Education> educationData = [];

      // Fetch documents in the specified order
      for (String docId in order) {
        try {
          final DocumentSnapshot doc = await _firestore
              .collection('education')
              .doc(docId)
              .get();

          if (doc.exists) {
            educationData.add(Education.fromFirestore(doc));
          }
        } catch (e) {
          print('Error fetching education document $docId: $e');
        }
      }

      return educationData;
    } catch (e) {
      throw Exception('Failed to retrieve education: $e');
    }
  }

  /// Retrieves all experience records from Firestore
  ///
  /// Returns a Future<List<Experience>> containing experience records sorted by start date
  /// Throws an exception if the collection doesn't exist or data is invalid
  static Future<List<Experience>> getExperiences() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('experience')
          .get();

      List<Experience> experiences = querySnapshot.docs
          .map((doc) => Experience.fromFirestore(doc))
          .toList();

      // Sort by start date (newest first)
      experiences.sort((a, b) {
        final aDate = a.startDateTime;
        final bDate = b.startDateTime;

        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;

        return bDate.compareTo(aDate); // Newest first
      });

      return experiences;
    } catch (e) {
      throw Exception('Failed to retrieve experiences: $e');
    }
  }

  /// Retrieves certifications from Firestore
  ///
  /// Returns a Future<List<Certification>> containing certifications
  /// Throws an exception if the collection doesn't exist or data is invalid
  static Future<List<Certification>> getCertifications({int? limit}) async {
    try {
      Query query = _firestore.collection('certifications');

      if (limit != null) {
        query = query.limit(limit);
      }

      final QuerySnapshot snapshot = await query.get();

      final List<Certification> items = snapshot.docs
          .map((doc) => Certification.fromFirestore(doc))
          .toList();

      return items;
    } catch (e) {
      throw Exception('Failed to retrieve certifications: $e');
    }
  }

  /// Retrieves notes from Firestore
  ///
  /// Returns a Future<List<Map<String, dynamic>>> containing notes data
  /// Throws an exception if the collection doesn't exist
  static Future<List<Map<String, dynamic>>> getNotes(
    String collectionName,
  ) async {
    try {
      final notes = await _firestore.collection(collectionName).get();
      return notes.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to retrieve notes from $collectionName: $e');
    }
  }

  /// Retrieves the location image URL from Firestore
  ///
  /// Returns a Future<String> containing the map image URL
  /// Returns empty string if document doesn't exist or URL is not found
  static Future<String> getLocationImageUrl() async {
    try {
      final DocumentSnapshot documentSnapshot = await _firestore
          .collection('data')
          .doc('location')
          .get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        return data['mapImageUrl'] as String? ?? "";
      }
      return "";
    } catch (e) {
      print('Error fetching location image URL: $e');
      return "";
    }
  }

  /// Retrieves a random Spotify track URL from Firestore
  ///
  /// Returns a Future<String?> containing a random track URL
  /// Returns null if no tracks are found or an error occurs
  static Future<String?> getRandomSpotifyTrack() async {
    try {
      final snapshot = await _firestore.collection('spotify').get();
      if (snapshot.docs.isEmpty) return null;

      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % snapshot.docs.length;
      final data = snapshot.docs[randomIndex].data();
      final trackUrl = data['track_url'];

      if (trackUrl is String && trackUrl.isNotEmpty) return trackUrl;
      return null;
    } catch (e) {
      print('Error fetching random Spotify track: $e');
      return null;
    }
  }

  /// Sends a message to Firestore
  ///
  /// Returns a Future<void>
  /// Throws an exception if the message cannot be saved
  static Future<void> sendMessage(Map<String, dynamic> messageData) async {
    try {
      await _firestore.collection('messages').add(messageData);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
