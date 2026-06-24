import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/dot_grid_painter.dart';

// Color tokens
const _teal = Color(0xFF0B6B54);
const _tealDark = Color(0xFF063527);
const _tealMid = Color(0xFF0B4A38);
const _tealLight = Color(0xFFC9F2E3);
const _tealBorder = Color(0x260B6B54);
const _tealProgress = Color(0x2E0B6B54);
const _brandRed = Color(0xFFE52B13);
const _navBg = Color(0xFFEAEAE4);
const _cardBg = Color(0xFFFFFFFF);
const _doneBadgeBg = Color(0xFFA9D7CD);
const _doneBadgeFg = Color(0xFF0B4A38);

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.driverName,
    required this.onLogout,
  });

  final String driverName;
  final VoidCallback onLogout;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _routeTab = 0; // 0=Upcoming 1=Map 2=Completed

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _Header(driverName: widget.driverName, onLogout: widget.onLogout),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatsRow(),
                const SizedBox(height: 12),
                _RouteSection(
                  tabIndex: _routeTab,
                  onTabChanged: (i) => setState(() => _routeTab = i),
                ),
                const SizedBox(height: 12),
                const _PreviousOrdersSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({required this.driverName, required this.onLogout});
  final String driverName;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
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
            child: CustomPaint(painter: DotGridPainter()),
          ),
          // radial glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.7, 0.2),
                  radius: 1.1,
                  colors: [
                    Colors.white.withValues(alpha: 0.13),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.55],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // logo row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.30), width: 1.5),
                      ),
                      child: const Icon(Icons.local_shipping_outlined, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Evening 👋',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            driverName,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                      onPressed: onLogout,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // action buttons
                Row(
                  children: [
                    Expanded(
                      child: _HeaderButton(
                        icon: Icons.shopping_cart_outlined,
                        label: 'New Order',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.newOrderDraft);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeaderButton(
                        icon: Icons.person_add_outlined,
                        label: 'New Customer',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.addCustomer);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 13),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Row ─────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_shipping_outlined,
            title: 'Custody',
            value: '857',
            sub: 'items on truck',
            dot1Label: '0 done',
            dot2Label: '753 left',
            progress: 0.0,
            bgSvgString: AppIcons.truck,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Collected',
            value: '\$0',
            sub: 'of \$1,658',
            dot1Label: '\$1,915 cash',
            dot2Label: '\$0 chk',
            progress: 0.0,
            bgSvgString: AppIcons.wallet,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.alt_route,
            title: 'Stops',
            value: '0',
            valueSuffix: '/4',
            sub: 'of 4 stops',
            dot1Label: '0 done',
            dot2Label: '4 left',
            progress: 0.0,
            bgSvgString: AppIcons.route,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.valueSuffix,
    required this.sub,
    required this.dot1Label,
    required this.dot2Label,
    required this.progress,
    required this.bgSvgString,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? valueSuffix;
  final String sub;
  final String dot1Label;
  final String dot2Label;
  final double progress;
  final String bgSvgString;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _tealLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _tealBorder, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              bottom: -8,
              right: -8,
              child: Opacity(
                opacity: 0.10,
                child: AppIcons.asset(
                  bgSvgString,
                  width: 80,
                  height: 80,
                  color: _teal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          color: _teal.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(icon, color: _teal, size: 13),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(title, style: const TextStyle(color: _tealMid, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: value,
                      style: const TextStyle(color: _tealDark, fontSize: 24, fontWeight: FontWeight.bold),
                      children: valueSuffix != null
                          ? [TextSpan(text: valueSuffix, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500))]
                          : [],
                    ),
                  ),
                  Text(sub, style: const TextStyle(color: _teal, fontSize: 10), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  _DotRow(color: _teal, label: dot1Label),
                  const SizedBox(height: 2),
                  _DotRow(color: Colors.white.withValues(alpha: 0.6), label: dot2Label, labelColor: const Color(0xFF6B7280)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: _tealProgress,
                      valueColor: const AlwaysStoppedAnimation<Color>(_brandRed),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotRow extends StatelessWidget {
  const _DotRow({required this.color, required this.label, this.labelColor = const Color(0xFF374151)});
  final Color color;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Expanded(child: Text(label, style: TextStyle(color: labelColor, fontSize: 10, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

// ─── Today's Route ─────────────────────────────────────────────────────────
class _RouteSection extends StatelessWidget {
  const _RouteSection({required this.tabIndex, required this.onTabChanged});
  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  static const _stops = [
    StopData(num: 1, name: 'Downtown Mart', address: '123 Main St, Downtown', units: 116, time: '08:30', amount: '\$374.00'),
    StopData(num: 2, name: 'Uptown Groceries', address: '456 High St, Uptown', units: 220, time: '09:15', amount: '\$480.00'),
    StopData(num: 3, name: 'City Cafe & Diner', address: '78 Park Ave, Midtown', units: 210, time: '10:00', amount: '\$560.00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Today\'s Route', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: const Row(children: [
                Text('View All', style: TextStyle(color: _brandRed, fontSize: 12, fontWeight: FontWeight.w600)),
                Icon(Icons.chevron_right, color: _brandRed, size: 14),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: _navBg, borderRadius: BorderRadius.circular(99)),
          child: Row(
            children: [
              _TabBtn(label: 'Upcoming', icon: Icons.checklist, active: tabIndex == 0, onTap: () => onTabChanged(0)),
              _TabBtn(label: 'Map', icon: Icons.map_outlined, active: tabIndex == 1, onTap: () => onTabChanged(1)),
              _TabBtn(label: 'Completed', icon: Icons.check_circle_outline, active: tabIndex == 2, onTap: () => onTabChanged(2)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (tabIndex == 0) ...[
          ...(_stops.map((s) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _StopCard(data: s)))),
          GestureDetector(
            onTap: () {},
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('View all 4 upcoming stops →', style: TextStyle(color: _brandRed, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ] else if (tabIndex == 1) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Map Area
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: 220,
                    color: const Color(0xFFDFE9C2),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _MapBackgroundPainter(),
                              ),
                            ),
                            Positioned(
                              left: w * 0.18,
                              top: h * 0.20,
                              child: const _MapPin(number: '1'),
                            ),
                            Positioned(
                              left: w * 0.66,
                              top: h * 0.08,
                              child: const _MapPin(number: '3'),
                            ),
                            Positioned(
                              left: w * 0.58,
                              top: h * 0.38,
                              child: const _MapPin(number: '2'),
                            ),
                            Positioned(
                              left: w * 0.28,
                              top: h * 0.48,
                              child: const _MapPin(number: '4'),
                            ),
                            Positioned(
                              left: w * 0.47 - 20,
                              top: h * 0.50 - 20,
                              child: const _CurrentLocationIndicator(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Text(
                        '4 upcoming stops',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE52B13),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () async {
                          final Uri url = Uri.parse(
                            'https://maps.google.com/maps/dir/123%20Main%20St%2C%20Downtown/456%20High%20St%2C%20Uptown/78%20Park%20Ave%2C%20Midtown/900%20Industrial%20Blvd%2C%20Northside'
                          );
                          try {
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          } catch (_) {}
                        },
                        icon: AppIcons.asset(
                          AppIcons.navigation,
                          width: 12,
                          height: 12,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Full Route',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcons.asset(
                    AppIcons.listChecks,
                    width: 32,
                    height: 32,
                    color: const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No stops completed yet',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Custom Painter for Map Grid and Roads ──────────────────────────────────
class _MapBackgroundPainter extends CustomPainter {
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

// ─── Map Pin Marker ─────────────────────────────────────────────────────────
class _MapPin extends StatelessWidget {
  const _MapPin({required this.number});
  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFE52B13),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Container(
          width: 2,
          height: 6,
          color: const Color(0xFF7F1D1D),
        ),
      ],
    );
  }
}

// ─── Current Location Indicator ─────────────────────────────────────────────
class _CurrentLocationIndicator extends StatefulWidget {
  const _CurrentLocationIndicator();

  @override
  State<_CurrentLocationIndicator> createState() => _CurrentLocationIndicatorState();
}

class _CurrentLocationIndicatorState extends State<_CurrentLocationIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ping circle (w-10 h-10, background: rgb(37, 99, 235), opacity: 0.20, animate-ping)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          // Inner dot (w-5 h-5, border-2 border-white shadow-lg, bg: rgb(59, 130, 246))
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            // SVG circle-dot icon of size 10 inside (lucide-circle-dot)
            child: const Icon(
              Icons.radio_button_checked,
              size: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn({required this.label, required this.icon, required this.active, required this.onTap});
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
            borderRadius: BorderRadius.circular(99),
            boxShadow: active ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 1))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: active ? _teal : const Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? _teal : const Color(0xFF6B7280))),
            ],
          ),
        ),
      ),
    );
  }
}

class StopData {
  const StopData({required this.num, required this.name, required this.address, required this.units, required this.time, required this.amount});
  final int num;
  final String name;
  final String address;
  final int units;
  final String time;
  final String amount;
}

class _StopCard extends StatelessWidget {
  const _StopCard({required this.data});
  final StopData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.stopDetails,
          arguments: data,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: const BoxDecoration(color: _navBg, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${data.num}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4B5563))),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1F2937)))),
                Text(data.amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF111827))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 11, color: _teal),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(data.address,
                      style: const TextStyle(color: _teal, fontSize: 11, decoration: TextDecoration.underline, decorationColor: _teal)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 11, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 4),
                Text('${data.units} units', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 11, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 4),
                Text(data.time, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                const Spacer(),
                Text('${data.amount} due', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _brandRed)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Previous Orders ───────────────────────────────────────────────────────
class _PreviousOrdersSection extends StatelessWidget {
  const _PreviousOrdersSection();

  static const _orders = [
    _OrderData(id: 'DO-2024', date: 'Mon, Jun 22 · 3/3 stops · \$1315 collected'),
    _OrderData(id: 'DO-2023', date: 'Sun, Jun 21 · 2/2 stops · \$978 collected'),
    _OrderData(id: 'DO-2022', date: 'Sat, Jun 20 · 3/3 stops · \$1590 collected'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Previous Orders', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: const Row(children: [
                Text('View more ', style: TextStyle(color: _brandRed, fontSize: 12, fontWeight: FontWeight.w600)),
                Icon(Icons.chevron_right, color: _brandRed, size: 14),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...(_orders.map((o) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _OrderCard(data: o)))),
      ],
    );
  }
}

class _OrderData {
  const _OrderData({required this.id, required this.date});
  final String id;
  final String date;
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.data});
  final _OrderData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: _navBg, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.check_circle_outline, color: _teal, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(data.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF374151))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: _doneBadgeBg, borderRadius: BorderRadius.circular(99)),
                      child: const Text('Done', style: TextStyle(color: _doneBadgeFg, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(data.date, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 16),
        ],
      ),
    );
  }
}
