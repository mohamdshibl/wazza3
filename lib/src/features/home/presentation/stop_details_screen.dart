import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/style/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/routing/app_routes.dart';
import 'widgets/home_view.dart'; // To access the StopData class

class StopDetailsScreen extends StatefulWidget {
  const StopDetailsScreen({super.key, required this.stopData});
  final StopData stopData;

  @override
  State<StopDetailsScreen> createState() => _StopDetailsScreenState();
}

class _StopDetailsScreenState extends State<StopDetailsScreen> {
  int _activeTab = 0; // 0: Summary, 1: Sales Orders, 2: Finance
  final Set<String> _expandedSkus = {};
  final Map<String, int> _confirmedOffloaded = {};
  final Map<String, TextEditingController> _offloadControllers = {};

  @override
  void dispose() {
    for (final controller in _offloadControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stop = widget.stopData;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      body: SafeArea(
        top: false, // Let header gradient stretch to top
        child: Column(
          children: [
            // ─── Header Gradient ─────────────────────────────────────────────
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                bottom: 12,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title / Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DO-2025 / Line ${stop.num}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          stop.name,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Pending Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAE4),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFF6B6B6B),
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.pending,
                          style: TextStyle(
                            color: Color(0xFF6B6B6B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ─── Scrollable Content ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stop info card with contact buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111827),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri url = Uri.parse('https://maps.google.com/maps?q=${Uri.encodeComponent(stop.address)}');
                                      try {
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      } catch (_) {}
                                    },
                                    child: Text(
                                      stop.address,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                        decoration: TextDecoration.underline,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Call Action Button
                            GestureDetector(
                              onTap: () async {
                                final Uri telUri = Uri.parse('tel:+15550101');
                                try {
                                  if (await canLaunchUrl(telUri)) {
                                    await launchUrl(telUri);
                                  }
                                } catch (_) {}
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA9D7CD),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: AppIcons.asset(
                                  AppIcons.phone,
                                  color: const Color(0xFF0B6B54),
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Message Action Button
                            GestureDetector(
                              onTap: () async {
                                final Uri smsUri = Uri.parse('sms:+15550101');
                                try {
                                  if (await canLaunchUrl(smsUri)) {
                                    await launchUrl(smsUri);
                                  }
                                } catch (_) {}
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA9D7CD),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: AppIcons.asset(
                                  AppIcons.messageCircle,
                                  color: const Color(0xFF0B6B54),
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tab selector (Summary, Sales Orders, Finance)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEAE4),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          children: [
                            _buildTabItem(0, 'Summary'),
                            _buildTabItem(1, 'Sales Orders'),
                            _buildTabItem(2, 'Finance'),
                          ],
                        ),
                      ),
                    ),

                    // Tab contents
                    if (_activeTab == 0) ...[
                      // Map Card View
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Map Grid Area
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                child: Container(
                                  height: 220,
                                  color: const Color(0xFFDFE9C2),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: _StopDetailsMapPainter(),
                                        ),
                                      ),
                                      // Central Pin Marker
                                      const Align(
                                        alignment: Alignment.center,
                                        child: _DetailsMapPin(),
                                      ),
                                      // ETA Top-Right box
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.95),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                color: Color(0xFFE52B13),
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                AppLocalizations.of(context)!.etaWithTime(stop.time),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF374151),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Bottom bar of Map Card
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        stop.address,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF374151),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Navigate Button
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE52B13),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(99),
                                        ),
                                        elevation: 0,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () async {
                                        final Uri url = Uri.parse('https://maps.google.com/maps?q=${Uri.encodeComponent(stop.address)}');
                                        try {
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url, mode: LaunchMode.externalApplication);
                                          }
                                        } catch (_) {}
                                      },
                                      icon: AppIcons.asset(
                                        AppIcons.navigation,
                                        width: 10,
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                      label: Text(AppLocalizations.of(context)!.navigate,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Amber warning Note Card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFFEF3C7)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFFF59E0B),
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(AppLocalizations.of(context)!.askForBackEntranceParkOnSideStreet,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Goods to Deliver Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.goodsToDeliver,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9CA3AF),
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildGoodsCard('Sparkling Water 500ml', 'SPK-500', 1.5, 120),
                            const SizedBox(height: 8),
                            _buildGoodsCard('Energy Drink 250ml', 'NRG-250', 3.0, 100),
                            const SizedBox(height: 12),
                            _buildDeliverySummaryCard(context),
                          ],
                        ),
                      ),
                    ] else if (_activeTab == 1) ...[
                      // Sales Orders Tab View
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.salesOrderDetails,
                                arguments: stop,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top row: ID, units, price
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              AppIcons.asset(
                                                AppIcons.receipt,
                                                width: 13,
                                                height: 13,
                                                color: const Color(0xFF9CA3AF),
                                              ),
                                              const SizedBox(width: 6),
                                              const Text(
                                                'SO-6001',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Color(0xFF1F2937),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(AppLocalizations.of(context)!.num2Lines116Units,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text.rich(
                                        buildCurrencyTextSpan(
                                          stop.amount,
                                          const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF111827),
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Items list
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Premium Water 1L',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                      const Text(
                                        '×60',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Juice Orange 1L',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                      const Text(
                                        '×56',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Bottom link
                                  Row(
                                    children: [
                                      Text(AppLocalizations.of(context)!.viewSalesOrderDetails,
                                        style: TextStyle(
                                          color: Color(0xFF0B6B54),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFF0B6B54),
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else if (_activeTab == 2) ...[
                      // Finance Tab View
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          children: [
                            // Card 1: Collection Overview
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Row 1: Total Invoice
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppLocalizations.of(context)!.totalInvoice,
                                          style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                                        ),
                                        Text.rich(
                                          buildCurrencyTextSpan(
                                            stop.amount,
                                            const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Row 2: Collected
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            AppIcons.asset(
                                              AppIcons.banknote,
                                              width: 14,
                                              height: 14,
                                              color: const Color(0xFF0B6B54),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(AppLocalizations.of(context)!.collected,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF0B6B54),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Text(
                                          '\$0.00',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0B6B54),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Row 3: Outstanding
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Color(0xFFE52B13),
                                            ),
                                            SizedBox(width: 6),
                                            Text(AppLocalizations.of(context)!.outstanding,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFE52B13),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text.rich(
                                          buildCurrencyTextSpan(
                                            stop.amount,
                                            const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE52B13),
                                          ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Collection progress bar
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)!.collectionProgress,
                                              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                                            ),
                                            Text(
                                              '0%',
                                              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          width: double.infinity,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE52B13).withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(99),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 0,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
                                              ),
                                              borderRadius: BorderRadius.circular(99),
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
                            // Card 2: Order Payments
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          AppIcons.asset(
                                            AppIcons.receipt,
                                            width: 13,
                                            height: 13,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'SO-600${stop.num}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text.rich(
                                        buildCurrencyTextSpan(
                                          stop.amount,
                                          const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF111827),
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(AppLocalizations.of(context)!.paid,
                                        style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                                      ),
                                      Text(
                                        '\$0.00',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0B6B54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Sales Orders or Finance empty tabs view
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Text(AppLocalizations.of(context)!.noDetailsAvailable,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // ─── Bottom Navigation Hint Bar ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade100, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.navigateToTheStopToBegin,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF0B6B54) : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoodsCard(String title, String sku, double price, int qty) {
    final isExpanded = _expandedSkus.contains(sku);
    final offloadedQty = _confirmedOffloaded[sku];
    final controller = _offloadControllers.putIfAbsent(
      sku,
      () => TextEditingController(text: offloadedQty != null ? offloadedQty.toString() : ''),
    );

    final hasOffloaded = offloadedQty != null && offloadedQty > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text.rich(
                            buildCurrencyTextSpan(
                              'SKU: $sku · \$$price/Ctn',
                              const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                          if (hasOffloaded)
                            Text(
                              '✓ $offloadedQty/$qty offloaded',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0B6B54),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '×$qty',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        if (hasOffloaded) ...[
                          const SizedBox(height: 2),
                          Text(
                            offloadedQty >= qty ? 'Full' : '${qty - offloadedQty} short',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: offloadedQty >= qty
                                  ? const Color(0xFF0B6B54)
                                  : const Color(0xFFE52B13),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: 12),
                    if (hasOffloaded)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedSkus.remove(sku);
                            } else {
                              _expandedSkus.add(sku);
                            }
                          });
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFA9D7CD),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF0B6B54),
                            size: 15,
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE52B13),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                          elevation: 0,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedSkus.remove(sku);
                            } else {
                              _expandedSkus.add(sku);
                            }
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.offload,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.quantityOffloaded.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B7280),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 38,
                              child: ListenableBuilder(
                                listenable: controller,
                                builder: (context, _) {
                                  return TextField(
                                    controller: controller,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                      hintText: '0–$qty',
                                      hintStyle: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFD1D5DB),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFFE52B13), width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '/ $qty',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      final val = int.tryParse(controller.text);
                      final isValid = val != null && val >= 0;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B6B54),
                          disabledBackgroundColor: const Color(0xFF0B6B54).withValues(alpha: 0.4),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: isValid
                            ? () {
                                setState(() {
                                  _confirmedOffloaded[sku] = val;
                                  _expandedSkus.remove(sku);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF0B6B54),
                                    content: Text(
                                      AppLocalizations.of(context)!.offloadSuccess(
                                        val.toString(),
                                        title,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Text(AppLocalizations.of(context)!.confirm,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliverySummaryCard(BuildContext context) {
    final spkOffloaded = _confirmedOffloaded['SPK-500'] ?? 0;
    final nrgOffloaded = _confirmedOffloaded['NRG-250'] ?? 0;
    final totalOffloaded = spkOffloaded + nrgOffloaded;
    final totalInvoice = (120 * 1.5) + (100 * 3.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFA9D7CD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF0B6B54).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: Color(0xFF0B4A38),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'DELIVERY SUMMARY',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B4A38),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$totalOffloaded',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF063527),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Units Offloaded',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0B6B54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF063527),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Total SKUs',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0B6B54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '0%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF063527),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Collected',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0B6B54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Invoice',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B4A38),
                ),
              ),
              Text.rich(
                buildCurrencyTextSpan(
                  '\$${totalInvoice.toStringAsFixed(2)}',
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF063527),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Custom Painter for Stop Details Map Grid ──────────────────────────────
class _StopDetailsMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Roads
    // Vertical thick road (at 1/4 width)
    final verticalThickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.60)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), verticalThickPaint);

    // Vertical thin road (at 2/3 width)
    final verticalThinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.40)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.66, 0), Offset(size.width * 0.66, size.height), verticalThinPaint);

    // Horizontal thick road (at 2/5 height)
    final horizontalThickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.60)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), horizontalThickPaint);

    // Horizontal thin road (at 2/3 height)
    final horizontalThinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.40)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.66), Offset(size.width, size.height * 0.66), horizontalThinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Details Map Pin Marker Widget ──────────────────────────────────────────
class _DetailsMapPin extends StatelessWidget {
  const _DetailsMapPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pin head (teardrop/circle with location pin icon inside)
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE52B13),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 18,
          ),
        ),
        // Pin stem (dark red line)
        Container(
          width: 2.5,
          height: 8,
          color: const Color(0xFF7F1D1D),
        ),
        // Shadow base
        Container(
          width: 8,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF7F1D1D).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}
