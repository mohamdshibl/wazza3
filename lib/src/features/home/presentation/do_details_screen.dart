import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/routing/app_routes.dart';
import 'widgets/home_view.dart'; // To access the StopData class

class _StopItem {
  final StopData data;
  final String alert;
  final int? soCount;

  const _StopItem({required this.data, required this.alert, this.soCount});
}

class DoDetailsScreen extends StatefulWidget {
  const DoDetailsScreen({super.key});

  @override
  State<DoDetailsScreen> createState() => _DoDetailsScreenState();
}

class _DoDetailsScreenState extends State<DoDetailsScreen> {
  bool _isLoaded = false;
  int _activeTab = 0; // 0 = DO Lines / Stops, 1 = Finance

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

  static const String _banknoteSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="12" x="2" y="6" rx="2"></rect><circle cx="12" cy="12" r="2"></circle><path d="M6 12h.01M18 12h.01"></path></svg>
''';

  static const String _truckSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"></path><path d="M15 18H9"></path><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"></path><circle cx="17" cy="18" r="2"></circle><circle cx="7" cy="18" r="2"></circle></svg>
''';

  static const String _fileTextSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"></path><path d="M14 2v4a2 2 0 0 0 2 2h4"></path><path d="M10 9H8"></path><path d="M16 13H8"></path><path d="M16 17H8"></path></svg>
''';

  static const String _clockSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
''';

  static const String _chevronRightSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"></path></svg>
''';

  static const String _trendingUpSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"></polyline><polyline points="16 7 22 7 22 13"></polyline></svg>
''';

  static const String _circleAlertSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
''';

  static const String _circleCheckSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><path d="m9 12 2 2 4-4"></path></svg>
''';

  final List<_StopItem> _stops = const [
    _StopItem(
      data: StopData(num: 1, name: 'Downtown Mart', address: '123 Main St, Downtown', units: 116, time: '08:30', amount: '\$374.00'),
      alert: 'Ask for back entrance. Park on side street.',
    ),
    _StopItem(
      data: StopData(num: 2, name: 'Uptown Groceries', address: '456 High St, Uptown', units: 220, time: '09:15', amount: '\$480.00'),
      alert: 'Ring bell at gate. Contact: Mr. Sam.',
    ),
    _StopItem(
      data: StopData(num: 3, name: 'City Cafe & Diner', address: '78 Park Ave, Midtown', units: 210, time: '10:00', amount: '\$560.00'),
      alert: 'Deliver to kitchen entrance. Avoid main entrance. Ask for Chef Marco.',
      soCount: 2,
    ),
    _StopItem(
      data: StopData(num: 4, name: 'North Star Wholesale', address: '900 Industrial Blvd, Northside', units: 207, time: '11:00', amount: '\$424.00'),
      alert: 'Large delivery. Forklift available on site. Check in at security gate.',
    ),
  ];

  void _confirmLoading() {
    setState(() {
      _isLoaded = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF0B6B54),
        content: Text('Quantities loaded successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      body: Column(
        children: [
          // ─── Header ────────────────────────────────────────────────────────
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
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DO-2025',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Wednesday, Jun 24, 2026',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isLoaded ? const Color(0xFFC9F2E3) : const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    _isLoaded ? 'Loaded' : 'Loading',
                    style: TextStyle(
                      color: _isLoaded ? const Color(0xFF0B4A38) : const Color(0xFF1D4ED8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Scrollable Contents ───────────────────────────────────────────
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
                          // Stops
                          Expanded(
                            child: _buildMetricCard(
                              svgString: _routeSvg,
                              iconColor: const Color(0xFFE52B13),
                              label: 'Stops',
                              valueWidget: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                  children: [
                                    TextSpan(text: _isLoaded ? '0' : '0'),
                                    const TextSpan(
                                      text: '/4',
                                      style: TextStyle(
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
                                  widthFactor: 0.0,
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

                          // Collected
                          Expanded(
                            child: _buildMetricCard(
                              svgString: _banknoteSvg,
                              iconColor: const Color(0xFF0B6B54),
                              label: 'Collected',
                              valueWidget: const Text(
                                '\$0',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B6B54),
                                ),
                              ),
                              extraWidget: const Text(
                                '\$1838 due',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Value
                          Expanded(
                            child: _buildMetricCard(
                              svgString: _dollarSignSvg,
                              iconColor: const Color(0xFFE52B13),
                              label: 'Value',
                              valueWidget: const Text(
                                '\$1,658',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              extraWidget: const Text(
                                'total invoiced',
                                style: TextStyle(
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

                  // Vehicle & Driver Row Card
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
                            SvgPicture.string(
                              _truckSvg,
                              width: 15,
                              height: 15,
                              colorFilter: const ColorFilter.mode(Color(0xFFE52B13), BlendMode.srcIn),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'ABC-1234',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Row(
                          children: [
                            Text(
                              '👤',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Alex Driver',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Handle juice cartons alert box
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.string(
                          _fileTextSvg,
                          colorFilter: const ColorFilter.mode(Color(0xFFD97706), BlendMode.srcIn),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Handle juice cartons carefully – fragile. Cold chain maintained.',
                            style: TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Warehouse loading progress banner
                  if (!_isLoaded)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBFDBFE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.string(
                                  _truckSvg,
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(Color(0xFF1D4ED8), BlendMode.srcIn),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Loading in progress…',
                                      style: TextStyle(
                                        color: Color(0xFF1E3A8A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Warehouse is loading your truck. Confirm when done.',
                                      style: TextStyle(
                                        color: Color(0xFF1D4ED8),
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _confirmLoading,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size(double.infinity, 0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  _circleCheckSvg,
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Confirm Quantities Loaded',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Tab selector: DO Lines / Stops | Finance
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
                                'DO Lines / Stops',
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
                                'Finance',
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

                  // Tab Contents (DO Lines or Finance)
                  if (_activeTab == 0) ...[
                    // DO Lines / Stops list
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: _stops.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final stop = _stops[index];
                        return _buildStopCard(stop);
                      },
                    ),
                  ] else ...[
                    // Finance Tab Content
                    _buildFinanceTab(),
                  ],
                ],
              ),
            ),
          ),


        ],
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
              SvgPicture.string(
                svgString,
                width: 13,
                height: 13,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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

  Widget _buildStopCard(_StopItem stop) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.stopDetails,
          arguments: stop.data,
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Gray Indicator Column
                  Container(
                    width: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAEAE4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          _clockSvg,
                          colorFilter: const ColorFilter.mode(Color(0xFF6B7280), BlendMode.srcIn),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${stop.data.num}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Content Block
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stop.data.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'DO-2025 / Line ${stop.data.num}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SvgPicture.string(
                                _chevronRightSvg,
                                colorFilter: const ColorFilter.mode(Color(0xFFD1D5DB), BlendMode.srcIn),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Map & Time Row
                          Row(
                            children: [
                              SvgPicture.string(
                                _mapPinSvg,
                                width: 10,
                                height: 10,
                                colorFilter: const ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  stop.data.address,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.string(
                                _clockSvg,
                                width: 10,
                                height: 10,
                                colorFilter: const ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                stop.data.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Package quantity & price row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.string(
                                    _packageSvg,
                                    width: 11,
                                    height: 11,
                                    colorFilter: const ColorFilter.mode(Color(0xFF6B7280), BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${stop.data.units} units',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  if (stop.soCount != null) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAEAE4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${stop.soCount} SOs',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF6B7280),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    stop.data.amount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Due ${stop.data.amount}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE52B13),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lower Amber Subcard for Alerts
          Container(
            margin: const EdgeInsets.only(top: 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBEB),
              border: Border(
                left: BorderSide(color: Color(0xFFFDE68A)),
                right: BorderSide(color: Color(0xFFFDE68A)),
                bottom: BorderSide(color: Color(0xFFFDE68A)),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.string(
                  _circleAlertSvg,
                  colorFilter: const ColorFilter.mode(Color(0xFFD97706), BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    stop.alert,
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontSize: 10,
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

  Widget _buildFinanceTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          // ─── Financial Summary Card ──────────────────────────────────────────
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
                    SvgPicture.string(
                      _trendingUpSvg,
                      colorFilter: const ColorFilter.mode(Color(0xFF0B4A38), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'FINANCIAL SUMMARY',
                      style: TextStyle(
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
                  children: const [
                    Text(
                      'Total Invoiced',
                      style: TextStyle(fontSize: 14, color: Color(0xFF0B4A38)),
                    ),
                    Text(
                      '\$1658.00',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Collected',
                      style: TextStyle(fontSize: 14, color: Color(0xFF0B4A38)),
                    ),
                    Text(
                      '\$0.00',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF063527)),
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
                    children: const [
                      Text(
                        'Outstanding',
                        style: TextStyle(fontSize: 14, color: Color(0xFFAF2409)),
                      ),
                      Text(
                        '\$1838.00',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFAF2409)),
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
                    widthFactor: 0.0,
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

          // ─── Stops List ──────────────────────────────────────────────────────
          ..._stops.map((stop) => _buildFinanceStopCard(stop)),
        ],
      ),
    );
  }

  Widget _buildFinanceStopCard(_StopItem stop) {
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
                stop.data.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '#${stop.data.num}',
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
              const Text(
                'Invoice',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              Text(
                stop.data.amount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Collected',
                style: TextStyle(fontSize: 12, color: Color(0xFF0B6B54)),
              ),
              Text(
                '\$0.00',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B6B54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Due',
                style: TextStyle(fontSize: 12, color: Color(0xFFE52B13)),
              ),
              Text(
                stop.data.amount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE52B13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
