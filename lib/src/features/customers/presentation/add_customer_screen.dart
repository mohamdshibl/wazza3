import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/repos/customer_repository.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  String _selectedType = 'Retail'; // Retail, Wholesale, HoReCa
  
  bool _locationVerified = false;
  String _verifiedAddress = '';
  
  bool _photoTaken = false;
  String? _photoPath;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  bool get _isUnlocked => _locationVerified && _photoTaken;

  bool get _canSave {
    if (!_isUnlocked) return false;
    return _nameController.text.trim().isNotEmpty && _addressController.text.trim().isNotEmpty;
  }

  Future<void> _verifyLocation() async {
    // Open real Google Maps URL
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=24.7136,46.6753');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
    
    // Automatically set verification to true after user launches or transitions back
    setState(() {
      _locationVerified = true;
      _verifiedAddress = '456 High St, Riyadh';
      _addressController.text = '456 High St, Riyadh'; // Auto fill
    });
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _photoPath = photo.path;
          _photoTaken = true;
        });
      }
    } catch (_) {}
  }

  void _saveCustomer() {
    if (!_canSave) return;

    final customer = Customer(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : '+966 50 000 0000',
      type: _selectedType,
    );

    CustomerRepository.instance.addCustomer(customer);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9F2E3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF0B6B54),
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Customer Added!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${customer.name} has been added as a new customer successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE52B13),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Pop dialog
                    Navigator.pop(context); // Pop add customer screen
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Customer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CUSTOMER TYPE SECTION
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'CUSTOMER TYPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTypeButton('Retail')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTypeButton('Wholesale')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTypeButton('HoReCa')),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // STEP 1 — VERIFY LOCATION
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'STEP 1 — VERIFY LOCATION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _verifyLocation,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _locationVerified ? const Color(0xFFC9F2E3) : const Color(0xFFDEDEB8),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _locationVerified ? const Color(0xFFC9F2E3) : const Color(0xFFF4F4EE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.navigation,
                                color: _locationVerified ? const Color(0xFF0B6B54) : const Color(0xFF9CA3AF),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Verify Customer Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _locationVerified
                                        ? _verifiedAddress
                                        : 'Open map to pin the location',
                                    style: TextStyle(
                                      color: _locationVerified ? const Color(0xFF0B6B54) : const Color(0xFF9CA3AF),
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _locationVerified ? Icons.check_circle : Icons.location_on,
                              color: _locationVerified ? const Color(0xFF0B6B54) : const Color(0xFF9CA3AF),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // STEP 2 — SHOP PHOTO
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'STEP 2 — SHOP PHOTO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _photoTaken ? const Color(0xFFC9F2E3) : const Color(0xFFDEDEB8),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _photoTaken
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  height: 160,
                                  color: const Color(0xFFF4F4EE),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned.fill(
                                        child: _photoPath != null
                                            ? Image.file(
                                                File(_photoPath!),
                                                fit: BoxFit.cover,
                                              )
                                            : CustomPaint(
                                                painter: _MockShopImagePainter(),
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.camera_alt, color: Colors.white, size: 12),
                                              SizedBox(width: 4),
                                              Text(
                                                'Change Photo',
                                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 32),
                                color: const Color(0xFFF4F4EE),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAEAE4),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(Icons.camera_alt, color: Color(0xFF9CA3AF), size: 24),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Take a photo of the shop',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4B5563),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Tap to capture current location photo',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // LOCK ALERTS
                    if (!_isUnlocked)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFEF3C7)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock, color: Color(0xFFD97706), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Complete location verification and photo to unlock the remaining fields.',
                                style: TextStyle(
                                  color: Color(0xFFB45309),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_open, color: Color(0xFF2563EB), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Verification steps completed! You can now fill in the store details.',
                                style: TextStyle(
                                  color: Color(0xFF1D4ED8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // BUSINESS DETAILS SECTION
                    Opacity(
                      opacity: _isUnlocked ? 1.0 : 0.4,
                      child: IgnorePointer(
                        ignoring: !_isUnlocked,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Business Name
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              child: Text(
                                'Business Name *',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9CA3AF),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            TextField(
                              controller: _nameController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'e.g. Corner Store',
                                prefixIcon: const Icon(Icons.store, color: Color(0xFF9CA3AF), size: 18),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE52B13), width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Address
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              child: Text(
                                'Address *',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9CA3AF),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            TextField(
                              controller: _addressController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'e.g. 123 Main St',
                                prefixIcon: const Icon(Icons.location_on, color: Color(0xFF9CA3AF), size: 18),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE52B13), width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9CA3AF),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '+966 5X XXX XXXX',
                                prefixIcon: const Icon(Icons.phone, color: Color(0xFF9CA3AF), size: 18),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE52B13), width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Area/Zone
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              child: Text(
                                'Area / Zone',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9CA3AF),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            TextField(
                              controller: _areaController,
                              decoration: InputDecoration(
                                hintText: 'e.g. Downtown',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Color(0xFFE52B13), width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SAVE CUSTOMER BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _canSave ? 1.0 : 0.6,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _canSave ? const Color(0xFFE52B13) : const Color(0xFFE2E2D8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _canSave ? [
                      BoxShadow(
                        color: const Color(0xFFE52B13).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _canSave ? _saveCustomer : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add,
                          color: _canSave ? Colors.white : const Color(0xFF9CA3AF),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Save Customer',
                          style: TextStyle(
                            color: _canSave ? Colors.white : const Color(0xFF9CA3AF),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label) {
    final isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFDEDEB8),
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// ─── Custom Painter for Storefront Illustration (Fallback) ──────────────────
class _MockShopImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()..color = const Color(0xFFBAE6FD);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    final groundPaint = Paint()..color = const Color(0xFF94A3B8);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3), groundPaint);

    final buildingPaint = Paint()..color = const Color(0xFFF1F5F9);
    final buildingRect = Rect.fromLTRB(size.width * 0.15, size.height * 0.3, size.width * 0.85, size.height * 0.7);
    canvas.drawRect(buildingRect, buildingPaint);

    final awningPaint = Paint()..color = const Color(0xFFEF4444);
    final awningRect = Rect.fromLTRB(size.width * 0.1, size.height * 0.28, size.width * 0.9, size.height * 0.36);
    canvas.drawRect(awningRect, awningPaint);

    final stripePaint = Paint()..color = Colors.white;
    for (double x = size.width * 0.12; x < size.width * 0.88; x += size.width * 0.08) {
      canvas.drawRect(Rect.fromLTWH(x, size.height * 0.28, size.width * 0.04, size.height * 0.08), stripePaint);
    }

    final doorPaint = Paint()..color = const Color(0xFF78350F);
    final doorRect = Rect.fromLTRB(size.width * 0.45, size.height * 0.5, size.width * 0.55, size.height * 0.7);
    canvas.drawRect(doorRect, doorPaint);

    final windowPaint = Paint()..color = const Color(0xFFE0F2FE);
    final windowRect1 = Rect.fromLTRB(size.width * 0.22, size.height * 0.44, size.width * 0.38, size.height * 0.58);
    final windowRect2 = Rect.fromLTRB(size.width * 0.62, size.height * 0.44, size.width * 0.78, size.height * 0.58);
    canvas.drawRect(windowRect1, windowPaint);
    canvas.drawRect(windowRect2, windowPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(windowRect1, borderPaint);
    canvas.drawRect(windowRect2, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
