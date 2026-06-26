import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/routing/app_routes.dart';

class SessionStartScreen extends StatefulWidget {
  const SessionStartScreen({super.key});

  @override
  State<SessionStartScreen> createState() => _SessionStartScreenState();
}

class _SessionStartScreenState extends State<SessionStartScreen> {
  // Checklist item checked states
  final List<bool> _checklist = [false, false, false, false];

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
                          child: AppIcons.asset(
                            AppIcons.logo,
                            width: 32,
                            height: 23,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.wazza3Distribution,
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
                    Text(AppLocalizations.of(context)!.goodEvening2,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!.driver,
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
                    Text(
                      AppLocalizations.of(context)!.readyToStartRoute,
                      style: const TextStyle(
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
                                    child: AppIcons.asset(
                                      AppIcons.route,
                                      width: 15,
                                      height: 15,
                                      color: const Color(0xFFE52B13),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
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
                                        AppLocalizations.of(context)!.todaysDo,
                                        style: const TextStyle(
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
                                child: Text(AppLocalizations.of(context)!.awaitingApproval,
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
                                _buildMetricItem(AppIcons.mapPin, '4', AppLocalizations.of(context)!.stopsLabel),
                                _buildVerticalDivider(),
                                _buildMetricItem(AppIcons.package, '857', AppLocalizations.of(context)!.itemsLabel),
                                _buildVerticalDivider(),
                                _buildMetricItem(AppIcons.dollarSign, '\$1.7k', AppLocalizations.of(context)!.valueLabel),
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
                                child: Row(
                                  children: [
                                    Text(AppLocalizations.of(context)!.viewDo,
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.description_outlined, color: Color(0xFFF59E0B), size: 14),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(AppLocalizations.of(context)!.handleJuiceCartonsCarefullyFragileColdChainMaintained,
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
                            Row(
                              children: [
                                Icon(Icons.warehouse_outlined, color: Color(0xFF0B6B54), size: 16),
                                SizedBox(width: 8),
                                Text(AppLocalizations.of(context)!.truckLoad,
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
                              child: Text(AppLocalizations.of(context)!.num5Skus,
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
                        Builder(
                          builder: (context) {
                            final fullText = AppLocalizations.of(context)!.unitsLoadedCount('857');
                            final parts = fullText.split('857');
                            final prefix = parts.isNotEmpty ? parts[0] : '';
                            final suffix = parts.length > 1 ? parts[1] : '';
                            return RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                                children: [
                                  if (prefix.isNotEmpty) TextSpan(text: prefix, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
                                  const TextSpan(
                                    text: '857',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0B6B54),
                                    ),
                                  ),
                                  if (suffix.isNotEmpty) TextSpan(text: suffix, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
                                ],
                              ),
                            );
                          }
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
                              Text(AppLocalizations.of(context)!.preRouteChecklist,
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
                        _buildChecklistItem(0, AppLocalizations.of(context)!.checklistTruckLoaded),
                        _buildChecklistItem(1, AppLocalizations.of(context)!.checklistRouteSheet),
                        _buildChecklistItem(2, AppLocalizations.of(context)!.checklistPhoneCharged),
                        _buildChecklistItem(3, AppLocalizations.of(context)!.checklistColdChain),
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
                        Builder(
                          builder: (context) {
                            final fullText = AppLocalizations.of(context)!.firstStopEta('08:30');
                            final parts = fullText.split('08:30');
                            final prefix = parts.isNotEmpty ? parts[0] : '';
                            final suffix = parts.length > 1 ? parts[1] : '';
                            return RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                                children: [
                                  if (prefix.isNotEmpty) TextSpan(text: prefix),
                                  const TextSpan(
                                    text: '08:30',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                                  ),
                                  if (suffix.isNotEmpty) TextSpan(text: suffix),
                                ],
                              ),
                            );
                          }
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
                Text(AppLocalizations.of(context)!.completeTheChecklistToStartYourSession,
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
                        Text(AppLocalizations.of(context)!.startDaySession,
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

  Widget _buildMetricItem(String svgRaw, String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            AppIcons.asset(
              svgRaw,
              width: 12,
              height: 12,
              color: const Color(0xFFE52B13),
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
