import 'package:flutter/material.dart';
import '../../../../core/widgets/dot_grid_painter.dart';

// Color tokens
const _brandRed = Color(0xFFE52B13);
const _teal = Color(0xFF0B6B54);
const _tealLight = Color(0xFFC9F2E3);
const _borderBg = Color(0xFFDEDEB8);

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  int _activeTab = 0; // 0 = Truck Load, 1 = Available to Offer

  // Invoices list data for Truck Load
  final List<_InventoryItemData> _truckLoadItems = [
    const _InventoryItemData(
      name: 'Premium Water 1L',
      sku: 'WAT-1L',
      priceText: '\$2.5/Ctn',
      quantity: 200,
      totalValue: 500.0,
      remaining: 200,
      totalLoaded: 200,
      percent: 1.0,
    ),
    const _InventoryItemData(
      name: 'Sparkling Water 500ml',
      sku: 'SPK-500',
      priceText: '\$1.5/Ctn',
      quantity: 220,
      totalValue: 330.0,
      remaining: 220,
      totalLoaded: 220,
      percent: 1.0,
    ),
    const _InventoryItemData(
      name: 'Energy Drink 250ml',
      sku: 'NRG-250',
      priceText: '\$3/Ctn',
      quantity: 160,
      totalValue: 480.0,
      remaining: 160,
      totalLoaded: 160,
      percent: 1.0,
    ),
    const _InventoryItemData(
      name: 'Juice Orange 1L',
      sku: 'JCE-ORG',
      priceText: '\$4/Ctn',
      quantity: 150,
      totalValue: 600.0,
      remaining: 150,
      totalLoaded: 150,
      percent: 1.0,
    ),
    const _InventoryItemData(
      name: 'Iced Tea 500ml',
      sku: 'ICT-500',
      priceText: '\$2/Ctn',
      quantity: 127,
      totalValue: 254.0,
      remaining: 127,
      totalLoaded: 127,
      percent: 1.0,
    ),
  ];

  // Invoices list data for Available to Offer
  final List<_InventoryItemData> _availableItems = [
    const _InventoryItemData(
      name: 'Premium Water 1L',
      sku: 'WAT-1L',
      priceText: '\$2.5/Ctn',
      quantity: 40,
      totalValue: 100.0,
      remaining: 40,
      totalLoaded: 40,
      percent: 1.0,
    ),
    const _InventoryItemData(
      name: 'Sparkling Water 500ml',
      sku: 'SPK-500',
      priceText: '\$1.5/Ctn',
      quantity: 100,
      totalValue: 150.0,
      remaining: 100,
      totalLoaded: 100,
      percent: 1.0,
    ),
    const _InventoryItemData(
      name: 'Juice Orange 1L',
      sku: 'JCE-ORG',
      priceText: '\$4/Ctn',
      quantity: 25,
      totalValue: 100.0,
      remaining: 25,
      totalLoaded: 25,
      percent: 1.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final displayedItems = _activeTab == 0 ? _truckLoadItems : _availableItems;

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
                // dot grid
                const Positioned.fill(
                  child: CustomPaint(painter: DotGridPainter(spacing: 18.0, dotColor: Color(0x10FFFFFF))),
                ),
                // radial glow
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.8, -0.4),
                        radius: 1.1,
                        colors: [
                          Colors.white.withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.60],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, top + 24, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titles
                      const Text(
                        'Virtual Warehouse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Goods loaded on your truck',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Stats boxes
                      Row(
                        children: [
                          Expanded(
                            child: _HeaderStatBox(
                              title: 'Truck Load',
                              units: 857,
                              value: '\$2,164 value',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _HeaderStatBox(
                              title: 'Available',
                              units: 165,
                              value: '\$400 value',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tab controller
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _ToggleTabBtn(
                              label: 'Truck Load',
                              icon: Icons.grid_view_outlined,
                              active: _activeTab == 0,
                              onTap: () => setState(() => _activeTab = 0),
                            ),
                            _ToggleTabBtn(
                              label: 'Available to Offer',
                              icon: Icons.manage_search_outlined,
                              active: _activeTab == 1,
                              onTap: () => setState(() => _activeTab = 1),
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
          
          // Body content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: displayedItems.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _InventoryCard(data: displayedItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStatBox extends StatelessWidget {
  const _HeaderStatBox({
    required this.title,
    required this.units,
    required this.value,
  });

  final String title;
  final int units;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: '$units ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: const [
                TextSpan(
                  text: 'units',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTabBtn extends StatelessWidget {
  const _ToggleTabBtn({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 13,
                color: active ? _brandRed : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: active ? _brandRed : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.data});
  final _InventoryItemData data;

  @override
  Widget build(BuildContext context) {
    final formattedValue = '\$${data.totalValue.toStringAsFixed(2)}';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderBg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Package Icon Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _tealLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: _teal,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                // Title + SKU
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SKU: ${data.sku} · ${data.priceText}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Quantity + Total Value
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${data.quantity} ',
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Ctns',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formattedValue,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress Bar Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.remaining} remaining of ${data.totalLoaded} loaded',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  '${(data.percent * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Progress indicator bar with red gradient
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: _brandRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: data.percent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE52B13), Color(0xFFAF2409)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryItemData {
  const _InventoryItemData({
    required this.name,
    required this.sku,
    required this.priceText,
    required this.quantity,
    required this.totalValue,
    required this.remaining,
    required this.totalLoaded,
    required this.percent,
  });

  final String name;
  final String sku;
  final String priceText;
  final int quantity;
  final double totalValue;
  final int remaining;
  final int totalLoaded;
  final double percent;
}
