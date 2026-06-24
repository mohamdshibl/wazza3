import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/routing/app_routes.dart';

class SessionStartScreen extends StatefulWidget {
  const SessionStartScreen({super.key});

  @override
  State<SessionStartScreen> createState() => _SessionStartScreenState();
}

class _SessionStartScreenState extends State<SessionStartScreen> {
  // Checklist item checked states
  final List<bool> _checklist = [false, false, false, false];

  static const String _wazzaLogoSvg = '''
<svg fill="none" viewBox="0 0 565 408"><path d="M129.518 408C143.302 408 154.476 396.819 154.476 383.026C154.476 369.233 143.302 358.052 129.518 358.052C115.734 358.052 104.56 369.233 104.56 383.026C104.56 396.819 115.734 408 129.518 408Z" fill="#FFFFFF"></path><path d="M426.543 408C440.327 408 451.501 396.819 451.501 383.026C451.501 369.233 440.327 358.052 426.543 358.052C412.759 358.052 401.585 369.233 401.585 383.026C401.585 396.819 412.759 408 426.543 408Z" fill="#FFFFFF"></path><path d="M565 132.367V281.88C565 316.091 537.186 343.963 503.01 343.963H354.259C320.07 343.963 292.216 316.078 292.216 281.88V209.217C292.216 202.066 286.412 196.258 279.266 196.258C272.12 196.258 266.315 202.066 266.315 209.217V281.88C266.315 316.091 238.502 343.963 204.326 343.963H61.9897C27.8137 343.976 0 316.091 0 281.88V62.03C0 27.8318 27.8137 0 61.9897 0H193.699V213.164C193.699 226.695 182.715 237.726 169.153 237.726C155.592 237.726 144.607 226.681 144.607 213.164V7.61586H61.9897C54.8437 7.61586 49.0392 13.4241 49.0392 20.5748V323.348C49.0392 330.499 54.8437 336.307 61.9897 336.307H204.312C211.458 336.307 217.263 330.499 217.263 323.348V250.685C217.263 216.434 245.076 188.602 279.252 188.602C313.442 188.602 341.295 216.434 341.295 250.685V323.348C341.295 330.499 347.1 336.307 354.246 336.307H503.01C510.156 336.307 515.961 330.499 515.961 323.348V90.8985C515.961 83.801 510.156 77.9396 503.01 77.9396H413.924V223.784C413.924 230.935 419.729 236.743 426.875 236.743H464.371C469.193 236.743 473.696 238.138 477.481 240.584C473.696 242.963 469.193 244.372 464.371 244.372H426.875C392.685 244.372 364.885 216.54 364.885 182.342V70.3237H503.01C537.2 70.3237 565 98.1555 565 132.367Z" fill="rgba(255,255,255,0.88)"></path></svg>
''';

  static const String _routeSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="19" r="3"></circle><path d="M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15"></path><circle cx="18" cy="5" r="3"></circle></svg>
''';

  static const String _mapPinSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"></path><circle cx="12" cy="10" r="3"></circle></svg>
''';

  static const String _packageSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"></path><path d="M12 22V12"></path><polyline points="3.29 7 12 12 20.71 7"></polyline><path d="m7.5 4.27 9 5.15"></path></svg>
''';

  static const String _dollarSignSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" x2="12" y1="2" y2="22"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
''';

  int get _checkedCount => _checklist.where((x) => x).length;
  bool get _isComplete => _checkedCount == 4;

  void _toggleCheck(int index) {
    setState(() {
      _checklist[index] = !_checklist[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      body: Column(
        children: [
          // ─── Header Section with Dot Grid and Glow ────────────────────────
          Stack(
            children: [
              // Gradient base
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24,
                  bottom: 28,
                  left: 20,
                  right: 20,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFAF2409), Color(0xFFE52B13)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Wazza3 Logo and Date info
                    Row(
                      children: [
                        // Corporate logo frame
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.string(
                            _wazzaLogoSvg,
                            width: 32,
                            height: 23,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WAZZA3 DISTRIBUTION',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Wednesday, June 24, 2026',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Greeting text
                    const Text(
                      'Good Evening,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Row(
                      children: [
                        Text(
                          'Driver',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '👋',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ready to start your day\'s route?',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Decorative glow overlay (radial style simulation)
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),

              // Dot pattern overlay using CustomPaint
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DotGridPainter(),
                  ),
                ),
              ),
            ],
          ),

          // ─── Scrollable Checklist & Overview Contents ──────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  // Card 1: Distribution Order Overview
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF0EE),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.string(
                                      _routeSvg,
                                      width: 15,
                                      height: 15,
                                      colorFilter: const ColorFilter.mode(Color(0xFFE52B13), BlendMode.srcIn),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DO-2025',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Today\'s distribution order',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  'Awaiting Approval',
                                  style: TextStyle(
                                    color: Color(0xFFB45309),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 3 Column Grid
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFF3F4F6)),
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildMetricItem(_mapPinSvg, '4', 'Stops'),
                              _buildVerticalDivider(),
                              _buildMetricItem(_packageSvg, '857', 'Items'),
                              _buildVerticalDivider(),
                              _buildMetricItem(_dollarSignSvg, '\$1.7k', 'Value'),
                            ],
                          ),
                        ),
                        // Footer: Vehicle & Driver details
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9FAEC),
                            border: Border(
                              top: BorderSide(color: Color(0xFFF3F4F6)),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, color: Color(0xFFE52B13), size: 14),
                              const SizedBox(width: 4),
                              const Text(
                                'ABC-1234',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.person_outline, color: Color(0xFF9CA3AF), size: 14),
                              const SizedBox(width: 4),
                              const Text(
                                'Alex Driver',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.doDetails);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'View DO',
                                      style: TextStyle(
                                        color: Color(0xFFE52B13),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.chevron_right, color: Color(0xFFE52B13), size: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Warning note details
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.description_outlined, color: Color(0xFFF59E0B), size: 14),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Handle juice cartons carefully – fragile. Cold chain maintained.',
                                  style: TextStyle(
                                    color: Color(0xFF92400E),
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card 2: Truck Load Status
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warehouse_outlined, color: Color(0xFF0B6B54), size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Truck Load',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC9F2E3),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: const Text(
                                '5 SKUs',
                                style: TextStyle(
                                  color: Color(0xFF0B4A38),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '857',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0B6B54),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'units loaded',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Loading progress indicator (100% full)
                        Container(
                          width: double.infinity,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B6B54).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0B6B54), Color(0xFF0D9B72)],
                              ),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card 3: Pre-Route Checklist
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Checklist Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Color(0xFFE52B13), size: 15),
                              const SizedBox(width: 8),
                              const Text(
                                'Pre-Route Checklist',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$_checkedCount/4',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        // Checklist items
                        _buildChecklistItem(0, 'Truck loaded and sealed'),
                        _buildChecklistItem(1, 'Route sheet reviewed'),
                        _buildChecklistItem(2, 'Phone & devices charged'),
                        _buildChecklistItem(3, 'Cold chain items checked'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card 4: First stop ETA card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE52B13).withValues(alpha: 0.06),
                      border: Border.all(color: const Color(0xFFE52B13).withValues(alpha: 0.12)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFFE52B13), size: 15),
                        const SizedBox(width: 8),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                            children: [
                              TextSpan(text: 'First stop ETA: '),
                              TextSpan(
                                text: '08:30',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Footer with Start Day Session Button ──────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Complete the checklist to start your session',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _isComplete
                      ? () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.dashboard,
                            (route) => false,
                          );
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: _isComplete
                          ? const LinearGradient(
                              colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF9B9B98), Color(0xFF7A7A78)],
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          color: _isComplete ? Colors.white : Colors.white70,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Start Day Session',
                          style: TextStyle(
                            color: _isComplete ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
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

  Widget _buildVerticalDivider() {
    return Container(
      height: 36,
      width: 1,
      color: const Color(0xFFF3F4F6),
    );
  }

  Widget _buildMetricItem(String svgString, String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            SvgPicture.string(
              svgString,
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(Color(0xFFE52B13), BlendMode.srcIn),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(int index, String title) {
    final isChecked = _checklist[index];
    return GestureDetector(
      onTap: () => _toggleCheck(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF9FAEC))),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? const Color(0xFF0B6B54) : Colors.white,
                border: Border.all(
                  color: isChecked ? const Color(0xFF0B6B54) : const Color(0xFFDEDED8),
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isChecked ? const Color(0xFF9CA3AF) : const Color(0xFF374151),
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dot Grid Painter ────────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    const double spacing = 20.0;
    const double radius = 1.0;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
