import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:portfolio/config/app_design.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/utils/firebase_utils.dart';

class CertificationsScreen extends StatefulWidget {
  const CertificationsScreen({super.key});

  @override
  State<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends State<CertificationsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Certification> _certifications = [];

  @override
  void initState() {
    super.initState();
    _loadCertifications();
  }

  Future<void> _loadCertifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final List<Certification> items = await FirebaseUtils.getCertifications(
        limit: 4,
      );

      if (!mounted) return;
      setState(() {
        _certifications = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load certifications: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Certifications',
                        style: AppDesign.largeTitle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selected achievements and credentials',
                        style: AppDesign.body.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRefreshButton(),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: AppDesign.systemBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
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
              'Loading certifications...',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: Colors.red[400],
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              'Could not fetch data',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _errorMessage!,
              style: AppDesign.body.copyWith(
                color: Colors.black54,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _buildRefreshButton(),
          ],
        ),
      );
    }

    if (_certifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.rosette, color: Colors.grey[400], size: 28),
            const SizedBox(height: 8),
            Text(
              'No certifications found',
              style: AppDesign.title1.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add certification documents under the certifications collection',
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

    // 2x2 grid
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: _certifications.length,
      itemBuilder: (context, index) {
        return _buildCertificationCard(_certifications[index]);
      },
    );
  }

  Widget _buildCertificationCard(Certification cert) {
    Brand certIcon;
    switch (cert.company) {
      case "MongoDB University":
        certIcon = Brand(Brands.mongodb);
        break;
      case "Oracle":
        certIcon = Brand(Brands.oracle_logo);
        break;
      default:
        certIcon = Brand(Brands.instagram_verification_badge);
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppDesign.systemBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: certIcon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cert.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: AppDesign.title3.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _metaRow(CupertinoIcons.calendar, cert.date),
            const SizedBox(height: 6),
            _metaRow(CupertinoIcons.building_2_fill, cert.company),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppDesign.systemBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppDesign.systemBlue.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Verified',
                  style: AppDesign.caption1.copyWith(
                    color: AppDesign.systemBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppDesign.body.copyWith(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.systemBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: _loadCertifications,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, color: Colors.white, size: 14),
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
}
