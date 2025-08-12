import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portfolio/config/app_design.dart';

class Experience {
  final String companyName;
  final List<String> description;
  final String duration;
  final String endDate;
  final String role;
  final String startDate;

  Experience({
    required this.companyName,
    required this.description,
    required this.duration,
    required this.endDate,
    required this.role,
    required this.startDate,
  });

  factory Experience.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final dynamic rawDescription = data['description'];
    List<String> parsedDescription = [];
    if (rawDescription is List) {
      parsedDescription = rawDescription.whereType<String>().toList();
    } else if (rawDescription is String) {
      final String trimmed = rawDescription.trim();
      if (trimmed.isNotEmpty) {
        parsedDescription = [trimmed];
      }
    }
    return Experience(
      companyName: data['companyName'] ?? '',
      description: parsedDescription,
      duration: data['duration'] ?? '',
      endDate: data['endDate'] ?? '',
      role: data['role'] ?? '',
      startDate: data['startDate'] ?? '',
    );
  }

  DateTime? get startDateTime {
    try {
      // Parse dates like "June, 2025" to DateTime
      final months = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      final parts = startDate.split(', ');
      if (parts.length == 2) {
        final month = months[parts[0]];
        final year = int.tryParse(parts[1]);
        if (month != null && year != null) {
          return DateTime(year, month);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  List<Experience> _experiences = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  Future<void> _loadExperiences() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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

      if (mounted) {
        setState(() {
          _experiences = experiences;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load experiences: $e';
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
        padding: const EdgeInsets.all(16.0),
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
                        'Experience',
                        style: AppDesign.largeTitle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'My professional journey',
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats in a compact row
                Row(
                  children: [
                    _buildCompactStat('Roles', _experiences.length.toString()),
                    const SizedBox(width: 16),
                    _buildCompactStat(
                      'Companies',
                      _experiences
                          .map((e) => e.companyName)
                          .toSet()
                          .length
                          .toString(),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Blue separator line
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: AppDesign.systemBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 16),

            // Refresh button
            Align(
              alignment: Alignment.centerRight,
              child: _buildCompactRefreshButton(),
            ),

            const SizedBox(height: 16),

            // Experience list
            Expanded(child: _buildExperienceContent()),
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
          onTap: _loadExperiences,
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

  Widget _buildExperienceContent() {
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
              'Loading experiences...',
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
              'Error loading experiences',
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

    if (_experiences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'No experiences found',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add some experience data to your Firestore collection',
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

    return ListView.builder(
      itemCount: _experiences.length,
      itemBuilder: (context, index) {
        return _buildCompactExperienceCard(_experiences[index]);
      },
    );
  }

  Widget _buildCompactExperienceCard(Experience experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Company icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppDesign.systemBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.business,
                    color: AppDesign.systemBlue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),

                // Company and role info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.companyName,
                        style: AppDesign.title1.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        experience.role,
                        style: AppDesign.body.copyWith(
                          color: AppDesign.systemBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Duration badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppDesign.systemBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppDesign.systemBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    experience.duration,
                    style: AppDesign.body.copyWith(
                      color: AppDesign.systemBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date range
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 12),
                const SizedBox(width: 4),
                Text(
                  '${experience.startDate} - ${experience.endDate}',
                  style: AppDesign.body.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Description paragraphs
            if (experience.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: experience.description
                    .map(
                      (String item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          item,
                          style: AppDesign.body.copyWith(
                            color: Colors.black87,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
