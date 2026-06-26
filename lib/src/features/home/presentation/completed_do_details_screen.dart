import 'package:flutter/material.dart';
import 'package:wazza3/l10n/app_localizations.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/style/app_text_styles.dart';

class CompletedDoData {
  final String id;
  final String date;
  final String stops;
  final int totalStops;
  final int completedStops;
  final String collected;
  final String due;
  final String value;
  final String truck;
  final String driver;
  final List<CompletedStopData> stopsList;

  const CompletedDoData({
    required this.id,
    required this.date,
    required this.stops,
    required this.totalStops,
    required this.completedStops,
    required this.collected,
    required this.due,
    required this.value,
    required this.truck,
    required this.driver,
    required this.stopsList,
  });
}

class CompletedStopData {
  final int num;
  final String name;
  final String lineId;
  final String address;
  final String time;
  final String units;
  final String amount;

  const CompletedStopData({
    required this.num,
    required this.name,
    required this.lineId,
    required this.address,
    required this.time,
    required this.units,
    required this.amount,
  });
}

class CompletedDoDetailsScreen extends StatefulWidget {
  const CompletedDoDetailsScreen({super.key});

  @override
  State<CompletedDoDetailsScreen> createState() => _CompletedDoDetailsScreenState();
}

class _CompletedDoDetailsScreenState extends State<CompletedDoDetailsScreen> {
  int _activeTab = 0; // 0 = DO Lines / Stops, 1 = Finance

  @override
  Widget build(BuildContext context) {
    final CompletedDoData data = ModalRoute.of(context)!.settings.arguments as CompletedDoData;
    final bottomPad = MediaQuery.of(context).padding.bottom;

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
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.15),
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
                          data.id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Status Badge: Completed
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA9D7CD),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.completedTab,
                      style: const TextStyle(
                        color: Color(0xFF0B4A38),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Scrollable Contents ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 3-Column Grid Cards
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Stops Card
                            Expanded(
                              child: _buildMetricCard(
                                svgString: AppIcons.route,
                                iconColor: const Color(0xFFE52B13),
                                label: AppLocalizations.of(context)!.stopsLabel,
                                valueWidget: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                    children: [
                                      TextSpan(text: '${data.completedStops}'),
                                      TextSpan(
                                        text: '/${data.totalStops}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                extraWidget: Container(
                                  width: double.infinity,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE52B13).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: data.completedStops / data.totalStops,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
                                        ),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Collected Card
                            Expanded(
                              child: _buildMetricCard(
                                svgString: AppIcons.banknote,
                                iconColor: const Color(0xFF0B6B54),
                                label: AppLocalizations.of(context)!.collected,
                                valueWidget: Text.rich(
                                  buildCurrencyTextSpan(
                                    data.collected,
                                    const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0B6B54),
                                    ),
                                  ),
                                ),
                                extraWidget: Text.rich(
                                  buildCurrencyTextSpan(
                                    AppLocalizations.of(context)!.amountDue(data.due),
                                    const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Value Card
                            Expanded(
                              child: _buildMetricCard(
                                svgString: AppIcons.dollarSign,
                                iconColor: const Color(0xFFE52B13),
                                label: AppLocalizations.of(context)!.valueLabel,
                                valueWidget: Text.rich(
                                  buildCurrencyTextSpan(
                                    data.value,
                                    const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ),
                                extraWidget: Text(
                                  AppLocalizations.of(context)!.totalInvoiced,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Vehicle & Driver Banner Card
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              AppIcons.asset(
                                AppIcons.truck,
                                width: 15,
                                height: 15,
                                color: const Color(0xFFE52B13),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data.truck,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              const Text(
                                '👤',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data.driver,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tab Selector: DO Lines / Stops | Finance
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEAE4),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _activeTab = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _activeTab == 0 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(99),
                                  boxShadow: _activeTab == 0
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
                                  AppLocalizations.of(context)!.doLinesStops,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _activeTab == 0 ? const Color(0xFF0B6B54) : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _activeTab = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _activeTab == 1 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(99),
                                  boxShadow: _activeTab == 1
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
                                  AppLocalizations.of(context)!.finance,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _activeTab == 1 ? const Color(0xFF0B6B54) : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab contents
                    if (_activeTab == 0) ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: data.stopsList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final stop = data.stopsList[index];
                          return _buildCompletedStopCard(stop);
                        },
                      ),
                    ] else ...[
                      _buildFinanceTab(data),
                    ],
                  ],
                ),
              ),
            ),

            // ─── Custom Bottom Navigation Bar ────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -1),
                  )
                ],
              ),
              child: Row(
                children: List.generate(4, (i) {
                  final active = i == 0; // standard Home state
                  final labels = [
                    AppLocalizations.of(context)!.homeTab,
                    AppLocalizations.of(context)!.inventoryTab,
                    AppLocalizations.of(context)!.walletTab,
                    AppLocalizations.of(context)!.profileTab,
                  ];
                  final icons = [
                    Icons.home_outlined,
                    Icons.inventory_2_outlined,
                    Icons.account_balance_wallet_outlined,
                    Icons.person_outline
                  ];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Pop back to dashboard
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: bottomPad + 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[i],
                              size: 21,
                              color: active
                                  ? const Color(0xFFE52B13)
                                  : const Color(0xFF9CA3AF),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              labels[i],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? const Color(0xFFE52B13)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String svgString,
    required Color iconColor,
    required String label,
    required Widget valueWidget,
    required Widget extraWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcons.asset(
                svgString,
                width: 13,
                height: 13,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          valueWidget,
          const Spacer(),
          extraWidget,
        ],
      ),
    );
  }

  Widget _buildCompletedStopCard(CompletedStopData stop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Done Indicator Column
            Container(
              width: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFA9D7CD), // Done badge bg
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF0B4A38), // Done badge fg
                    size: 16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${stop.num}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B4A38),
                    ),
                  ),
                ],
              ),
            ),

            // Right Content Block
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stop.lineId,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Address and time row
                          Row(
                            children: [
                              AppIcons.asset(
                                AppIcons.mapPin,
                                width: 12,
                                height: 12,
                                color: const Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  stop.address,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AppIcons.asset(
                                AppIcons.clock,
                                width: 12,
                                height: 12,
                                color: const Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                stop.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Units row
                          Row(
                            children: [
                              AppIcons.asset(
                                AppIcons.package,
                                width: 12,
                                height: 12,
                                color: const Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.unitsCount(stop.units),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          buildCurrencyTextSpan(
                            stop.amount,
                            const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.paid,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B6B54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFD1D5DB),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceTab(CompletedDoData data) {
    // Parse values to double to compute outstanding and progress factor
    final collectedClean = data.collected.replaceAll('\$', '').replaceAll(',', '');
    final valueClean = data.value.replaceAll('\$', '').replaceAll(',', '');
    final collectedDouble = double.tryParse(collectedClean) ?? 0.0;
    final valueDouble = double.tryParse(valueClean) ?? 0.0;
    final diff = valueDouble - collectedDouble;
    final progressFactor = valueDouble > 0 ? (collectedDouble / valueDouble).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          // Financial Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFA9D7CD),
              border: Border.all(color: const Color(0xFF0B6B54).withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppIcons.asset(
                      AppIcons.trendingUp,
                      width: 12,
                      height: 12,
                      color: const Color(0xFF0B4A38),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.financialSummary,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Color(0xFF0B4A38),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalInvoiced,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0B4A38)),
                    ),
                    Text(
                      data.value,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.collected,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0B4A38)),
                    ),
                    Text(
                      data.collected,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF063527)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: const Color(0xFF0B6B54).withValues(alpha: 0.2)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.outstanding,
                        style: const TextStyle(fontSize: 14, color: Color(0xFFAF2409)),
                      ),
                      Text(
                        '\$${diff.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFAF2409)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE52B13).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progressFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
                        ),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stop lists financial cards
          ...data.stopsList.map((stop) => _buildFinanceStopCard(stop)),
        ],
      ),
    );
  }

  Widget _buildFinanceStopCard(CompletedStopData stop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stop.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '#${stop.num}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.invoice,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              Text.rich(
                buildCurrencyTextSpan(
                  stop.amount,
                  const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.collected,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0B6B54)),
              ),
              Text.rich(
                buildCurrencyTextSpan(
                  stop.amount,
                  const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0B6B54),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.due,
                style: const TextStyle(fontSize: 12, color: Color(0xFFE52B13)),
              ),
              Text.rich(
                buildCurrencyTextSpan(
                  '\$0.00',
                  const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE52B13),
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
