import 'package:flutter/material.dart';
import 'package:wazza3/l10n/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import 'completed_do_details_screen.dart';

class PreviousOrdersScreen extends StatelessWidget {
  const PreviousOrdersScreen({super.key});

  static const _orders = [
    _PreviousOrderData(
      id: 'DO-2024',
      date: 'Thu, Jun 25 · 3/3 stops · \$1315 collected',
    ),
    _PreviousOrderData(
      id: 'DO-2023',
      date: 'Wed, Jun 24 · 2/2 stops · \$978 collected',
    ),
    _PreviousOrderData(
      id: 'DO-2022',
      date: 'Tue, Jun 23 · 3/3 stops · \$1590 collected',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                          AppLocalizations.of(context)!.previousOrders,
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
                          AppLocalizations.of(context)!.completedOrdersCount(_orders.length.toString()),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Text(
                        AppLocalizations.of(context)!.distributionOrders.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _orders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return _PreviousOrderCard(data: order);
                      },
                    ),
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
                        Navigator.pop(context);
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
}

class _PreviousOrderData {
  const _PreviousOrderData({required this.id, required this.date});
  final String id;
  final String date;
}

class _PreviousOrderCard extends StatelessWidget {
  const _PreviousOrderCard({required this.data});
  final _PreviousOrderData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final CompletedDoData completedDo;
        if (data.id == 'DO-2024') {
          completedDo = const CompletedDoData(
            id: 'DO-2024',
            date: 'Thursday, Jun 25, 2026',
            stops: '3/3',
            totalStops: 3,
            completedStops: 3,
            collected: '\$1,315.00',
            due: '\$0.00',
            value: '\$1,320.00',
            truck: 'ABC-1234',
            driver: 'Alex Driver',
            stopsList: [
              CompletedStopData(
                num: 1,
                name: 'Downtown Mart',
                lineId: 'DO-2024 / Line 1',
                address: '123 Main St, Downtown',
                time: '08:30',
                units: '130',
                amount: '\$245.00',
              ),
              CompletedStopData(
                num: 2,
                name: 'City Cafe & Diner',
                lineId: 'DO-2024 / Line 2',
                address: '78 Park Ave, Midtown',
                time: '09:30',
                units: '200',
                amount: '\$720.00',
              ),
              CompletedStopData(
                num: 3,
                name: 'Beachside Kiosk',
                lineId: 'DO-2024 / Line 3',
                address: '12 Shore Rd, Eastside',
                time: '10:45',
                units: '160',
                amount: '\$350.00',
              ),
            ],
          );
        } else if (data.id == 'DO-2023') {
          completedDo = const CompletedDoData(
            id: 'DO-2023',
            date: 'Wednesday, Jun 24, 2026',
            stops: '2/2',
            totalStops: 2,
            completedStops: 2,
            collected: '\$978.00',
            due: '\$0.00',
            value: '\$978.00',
            truck: 'ABC-1234',
            driver: 'Alex Driver',
            stopsList: [
              CompletedStopData(
                num: 1,
                name: 'Uptown Groceries',
                lineId: 'DO-2023 / Line 1',
                address: '456 High St, Uptown',
                time: '09:15',
                units: '220',
                amount: '\$480.00',
              ),
              CompletedStopData(
                num: 2,
                name: 'City Cafe & Diner',
                lineId: 'DO-2023 / Line 2',
                address: '78 Park Ave, Midtown',
                time: '10:00',
                units: '210',
                amount: '\$498.00',
              ),
            ],
          );
        } else {
          completedDo = const CompletedDoData(
            id: 'DO-2022',
            date: 'Tuesday, Jun 23, 2026',
            stops: '3/3',
            totalStops: 3,
            completedStops: 3,
            collected: '\$1,590.00',
            due: '\$0.00',
            value: '\$1,590.00',
            truck: 'ABC-1234',
            driver: 'Alex Driver',
            stopsList: [
              CompletedStopData(
                num: 1,
                name: 'Downtown Mart',
                lineId: 'DO-2022 / Line 1',
                address: '123 Main St, Downtown',
                time: '08:30',
                units: '130',
                amount: '\$600.00',
              ),
              CompletedStopData(
                num: 2,
                name: 'North Star Wholesale',
                lineId: 'DO-2022 / Line 2',
                address: '900 Industrial Blvd, Northside',
                time: '11:00',
                units: '207',
                amount: '\$590.00',
              ),
              CompletedStopData(
                num: 3,
                name: 'Beachside Kiosk',
                lineId: 'DO-2022 / Line 3',
                address: '12 Shore Rd, Eastside',
                time: '10:45',
                units: '160',
                amount: '\$400.00',
              ),
            ],
          );
        }

        Navigator.pushNamed(
          context,
          AppRoutes.completedDoDetails,
          arguments: completedDo,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFA9D7CD), // doneBadgeBg
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF0B4A38), // doneBadgeFg
                size: 17,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA9D7CD),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: const TextStyle(
                            color: Color(0xFF0B4A38),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFD1D5DB),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
