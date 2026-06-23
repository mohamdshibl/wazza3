import 'package:flutter/material.dart';
import '../../../../core/widgets/dot_grid_painter.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    
    // Invoices list data
    final invoices = [
      const _InvoiceData(customer: 'Downtown Mart', orderId: 'SO-6001', amount: 374.0, isPaid: false),
      const _InvoiceData(customer: 'Uptown Groceries', orderId: 'SO-6002', amount: 480.0, isPaid: false),
      const _InvoiceData(customer: 'City Cafe & Diner', orderId: 'SO-6003', amount: 360.0, isPaid: false),
      const _InvoiceData(customer: 'City Cafe & Diner', orderId: 'SO-6003B', amount: 200.0, isPaid: false),
      const _InvoiceData(customer: 'North Star Wholesale', orderId: 'SO-6004', amount: 424.0, isPaid: false),
      const _InvoiceData(customer: 'Beachside Kiosk', orderId: 'SO-7001', amount: 380.0, isPaid: false),
      const _InvoiceData(customer: 'Uptown Groceries', orderId: 'SO-7002', amount: 240.0, isPaid: false),
      const _InvoiceData(customer: 'Downtown Mart', orderId: 'SO-H1-1', amount: 245.0, isPaid: true),
      const _InvoiceData(customer: 'City Cafe & Diner', orderId: 'SO-H1-2', amount: 720.0, isPaid: true),
      const _InvoiceData(customer: 'Beachside Kiosk', orderId: 'SO-H1-3', amount: 350.0, isPaid: true),
      const _InvoiceData(customer: 'Uptown Groceries', orderId: 'SO-H2-1', amount: 570.0, isPaid: true),
      const _InvoiceData(customer: 'North Star Wholesale', orderId: 'SO-H2-2', amount: 408.0, isPaid: true),
      const _InvoiceData(customer: 'Downtown Mart', orderId: 'SO-H3-1', amount: 600.0, isPaid: true),
      const _InvoiceData(customer: 'City Cafe & Diner', orderId: 'SO-H3-2', amount: 840.0, isPaid: true),
      const _InvoiceData(customer: 'Beachside Kiosk', orderId: 'SO-H3-3', amount: 150.0, isPaid: true),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.7, -1),
                end: Alignment(1, 1),
                colors: [Color(0xFFAF2409), Color(0xFFE52B13)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: const CustomPaint(painter: DotGridPainter()),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.6, -0.6),
                        radius: 1.0,
                        colors: [
                          Colors.white.withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.6],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, top + 24, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Collections & Wallet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Financial custody & invoices',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Total Collected
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL COLLECTED',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '\$0.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: const Text(
                              '\$1658.00 due',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.0, // 0%
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '0% of route collected',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Body content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Physical Custody Label
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'PHYSICAL CUSTODY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                
                // Cash & Checks Grid
                const Row(
                  children: [
                    Expanded(
                      child: _CustodyCard(
                        icon: Icons.money,
                        iconBg: Color(0xFFC9F2E3),
                        iconColor: Color(0xFF0B6B54),
                        label: 'Cash',
                        value: '\$0.00',
                        caption: 'Physical notes held',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _CustodyCard(
                        icon: Icons.credit_card,
                        iconBg: Color(0xFFDBEAFE),
                        iconColor: Color(0xFF2563EB),
                        label: 'Checks',
                        value: '\$0.00',
                        caption: 'Checks in custody',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Total Custody Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFDEDEB8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Custody',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF374151),
                        ),
                      ),
                      Text(
                        '\$0.00',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Invoices Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'INVOICES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                
                // Invoices List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: invoices.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _InvoiceCard(data: invoices[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustodyCard extends StatelessWidget {
  const _CustodyCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDEDEB8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.data});
  final _InvoiceData data;

  @override
  Widget build(BuildContext context) {
    final formattedAmount = '\$${data.amount.toStringAsFixed(2)}';
    
    final Color badgeBg = data.isPaid ? const Color(0xFFC9F2E3) : const Color(0xFFFFF0EE);
    final Color badgeFg = data.isPaid ? const Color(0xFF0B6B54) : const Color(0xFFAF2409);
    final String badgeText = data.isPaid ? 'Paid' : 'Unpaid';
    final IconData badgeIcon = data.isPaid ? Icons.check_circle_outline : Icons.error_outline;
    
    final String dueText = data.isPaid ? 'Fully paid ✓' : 'Due $formattedAmount';
    final Color dueColor = data.isPaid ? const Color(0xFF0B6B54) : const Color(0xFFE52B13);
    
    final double progressWidth = data.isPaid ? 1.0 : 0.0;
    
    final String collectedPercent = data.isPaid ? '100% collected' : '0% collected';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDEDEB8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.customer,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              color: Color(0xFF9CA3AF),
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data.orderId,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, color: badgeFg, size: 10),
                        const SizedBox(width: 3),
                        Text(
                          badgeText,
                          style: TextStyle(
                            color: badgeFg,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF9CA3AF),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Invoice: ',
                      style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(
                          text: formattedAmount,
                          style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    dueText,
                    style: TextStyle(
                      color: dueColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE52B13).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progressWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: progressWidth > 0 
                        ? const LinearGradient(colors: [Color(0xFF0B6B54), Color(0xFF0D9B72)])
                        : null,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                collectedPercent,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceData {
  const _InvoiceData({
    required this.customer,
    required this.orderId,
    required this.amount,
    required this.isPaid,
  });

  final String customer;
  final String orderId;
  final double amount;
  final bool isPaid;
}
