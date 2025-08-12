import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/config/app_design.dart';

class Education {
  final String course;
  final String grades;
  final String image;
  final String location;
  final String name;

  Education({
    required this.course,
    required this.grades,
    required this.image,
    required this.location,
    required this.name,
  });

  factory Education.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Education(
      course: data['course'] ?? '',
      grades: data['grades'] ?? '',
      image: data['image'] ?? '',
      location: data['location'] ?? '',
      name: data['name'] ?? '',
    );
  }
}

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<Education> _educationList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEducation();
  }

  Future<void> _loadEducation() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Define the order we want to display
      final List<String> order = ['university', 'highschool', 'school'];
      List<Education> educationData = [];

      // Fetch documents in the specified order
      for (String docId in order) {
        try {
          final DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('education')
              .doc(docId)
              .get();

          if (doc.exists) {
            educationData.add(Education.fromFirestore(doc));
          }
        } catch (e) {
          print('Error fetching document $docId: $e');
        }
      }

      if (mounted) {
        setState(() {
          _educationList = educationData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load education: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Education',
                        style: AppDesign.largeTitle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'My academic journey',
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats in a compact row
                Row(
                  children: [
                    _buildCompactStat(
                      'Institutions',
                      _educationList.length.toString(),
                    ),
                    const SizedBox(width: 12),
                    _buildCompactStat(
                      'Levels',
                      _educationList.length.toString(),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Blue separator line
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: AppDesign.systemBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 12),

            // Refresh button
            Align(
              alignment: Alignment.centerRight,
              child: _buildCompactRefreshButton(),
            ),

            const SizedBox(height: 12),

            // Education content
            Expanded(child: _buildEducationContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppDesign.title1.copyWith(
            color: AppDesign.systemBlue,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: AppDesign.body.copyWith(
            color: Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.systemBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: _loadEducation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Refresh',
                  style: AppDesign.buttonText(
                    color: Colors.white,
                  ).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppDesign.systemBlue),
              strokeWidth: 2,
            ),
            SizedBox(height: 12),
            Text(
              'Loading education...',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'Error loading education',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _error!,
              style: AppDesign.body.copyWith(
                color: Colors.black54,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildCompactRefreshButton(),
          ],
        ),
      );
    }

    if (_educationList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'No education data found',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add education data to your Firestore collection',
              style: AppDesign.body.copyWith(
                color: Colors.black54,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Horizontal scrolling list
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _educationList.map((education) {
          return _buildEducationCard(education);
        }).toList(),
      ),
    );
  }

  Widget _buildEducationCard(Education education) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(education.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Institution name
                Text(
                  education.name,
                  style: AppDesign.title2.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Course
                Text(
                  education.course,
                  style: AppDesign.headline.copyWith(
                    color: AppDesign.systemBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey[600],
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        education.location,
                        style: AppDesign.body.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Grades
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppDesign.systemGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppDesign.systemGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    education.grades,
                    style: AppDesign.body.copyWith(
                      color: AppDesign.systemGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
