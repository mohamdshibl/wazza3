import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/routing/app_routes.dart';

import '../../auth/logic/controllers/auth_cubit.dart';

const String _truckSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-truck"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"></path><path d="M15 18H9"></path><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"></path><circle cx="17" cy="18" r="2"></circle><circle cx="7" cy="18" r="2"></circle></svg>
''';

const String _walletSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-wallet"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"></path><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"></path></svg>
''';

const String _routeSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-route"><circle cx="6" cy="19" r="3"></circle><path d="M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15"></path><circle cx="18" cy="5" r="3"></circle></svg>
''';

// ─── Color tokens from HTML ────────────────────────────────────────────────
const _bgPage = Color(0xFFF9FAEC);
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

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  int _navIndex = 0;
  int _routeTab = 0; // 0=Upcoming 1=Map 2=Completed

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state;
    final driverName = user?.name ?? 'Driver';
    final bottomPad = MediaQuery.of(context).padding.bottom;

    Widget body;
    if (_navIndex == 3) {
      body = _ProfileView(driverName: driverName, onLogout: _logout);
    } else if (_navIndex == 0) {
      body = SingleChildScrollView(
        child: Column(
          children: [
            _Header(driverName: driverName, onLogout: _logout),
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
    } else {
      body = Center(
        child: Text(
          _BottomNav._items[_navIndex].label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bgPage,
      body: Column(
        children: [
          Expanded(child: body),
          _BottomNav(
            index: _navIndex,
            onTap: (i) => setState(() => _navIndex = i),
            bottomPad: bottomPad,
          ),
        ],
      ),
    );
  }

  void _logout() {
    context.read<AuthCubit>().clear();
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false);
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
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
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
                    Expanded(child: _HeaderButton(icon: Icons.shopping_cart_outlined, label: 'New Order', onTap: () {})),
                    const SizedBox(width: 8),
                    Expanded(child: _HeaderButton(icon: Icons.person_add_outlined, label: 'New Customer', onTap: () {})),
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
            bgSvgString: _truckSvg,
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
            bgSvgString: _walletSvg,
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
            bgSvgString: _routeSvg,
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
            // Background SVG icon (Opacity 0.10)
            Positioned(
              bottom: -8,
              right: -8,
              child: Opacity(
                opacity: 0.10,
                child: SvgPicture.string(
                  bgSvgString,
                  width: 80,
                  height: 80,
                  colorFilter: const ColorFilter.mode(_teal, BlendMode.srcIn),
                ),
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon + title
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
                  // value
                  RichText(
                    text: TextSpan(
                      text: value,
                      style: const TextStyle(color: _tealDark, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                      children: valueSuffix != null
                          ? [TextSpan(text: valueSuffix, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500))]
                          : [],
                    ),
                  ),
                  Text(sub, style: const TextStyle(color: _teal, fontSize: 10), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  // dots
                  _DotRow(color: _teal, label: dot1Label),
                  const SizedBox(height: 2),
                  _DotRow(color: Colors.white.withValues(alpha: 0.6), label: dot2Label, labelColor: const Color(0xFF6B7280)),
                  const SizedBox(height: 6),
                  // progress bar
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
    _StopData(num: 1, name: 'Downtown Mart', address: '123 Main St, Downtown', units: 116, time: '08:30', amount: '\$374.00'),
    _StopData(num: 2, name: 'Uptown Groceries', address: '456 High St, Uptown', units: 220, time: '09:15', amount: '\$480.00'),
    _StopData(num: 3, name: 'City Cafe & Diner', address: '78 Park Ave, Midtown', units: 210, time: '10:00', amount: '\$560.00'),
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
        // Tab bar
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: _navBg, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              _TabBtn(label: 'Upcoming', icon: Icons.checklist, active: tabIndex == 0, onTap: () => onTabChanged(0)),
              _TabBtn(label: 'Map', icon: Icons.map_outlined, active: tabIndex == 1, onTap: () => onTabChanged(1)),
              _TabBtn(label: 'Completed', icon: Icons.check_circle_outline, active: tabIndex == 2, onTap: () => onTabChanged(2)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Stop cards
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
      ],
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
            borderRadius: BorderRadius.circular(8),
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

class _StopData {
  const _StopData({required this.num, required this.name, required this.address, required this.units, required this.time, required this.amount});
  final int num;
  final String name;
  final String address;
  final int units;
  final String time;
  final String amount;
}

class _StopCard extends StatelessWidget {
  const _StopCard({required this.data});
  final _StopData data;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                decoration: BoxDecoration(color: _navBg, shape: BoxShape.circle),
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

// ─── Bottom Nav ────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap, required this.bottomPad});
  final int index;
  final ValueChanged<int> onTap;
  final double bottomPad;

  static const _items = [
    _NavItem(icon: Icons.home_outlined, label: 'Home'),
    _NavItem(icon: Icons.inventory_2_outlined, label: 'Inventory'),
    _NavItem(icon: Icons.account_balance_wallet_outlined, label: 'Wallet'),
    _NavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -1))],
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: 56 + bottomPad,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Active indicator line
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: active ? 40 : 0,
                      decoration: BoxDecoration(
                        color: _brandRed,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40, height: 28,
                      decoration: BoxDecoration(
                        color: active ? _brandRed.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_items[i].icon, size: 21, color: active ? _brandRed : const Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _items[i].label,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: active ? _brandRed : const Color(0xFF9CA3AF), letterSpacing: 0.2),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

// ─── Dot Grid Painter ──────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.07);
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => false;
}

// ─── Profile View ─────────────────────────────────────────────────────────
class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.driverName, required this.onLogout});
  final String driverName;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header Section (Red gradient with dot grid + avatar)
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
                Positioned.fill(
                  child: CustomPaint(painter: _DotGridPainter()),
                ),
                // radial glow
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.3),
                        radius: 1.2,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.65],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, top + 36, 16, 32),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Name
                      Text(
                        driverName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      // Badges
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Badge(label: 'Sales Rep'),
                          SizedBox(width: 8),
                          _Badge(label: 'ID: REP-042'),
                        ],
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
                // Info Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEAEAE4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      _ProfileRow(
                        icon: Icons.local_shipping_outlined,
                        title: 'Assigned Truck',
                        value: 'Truck A-101',
                        isLast: false,
                      ),
                      _ProfileRow(
                        icon: Icons.location_on_outlined,
                        title: 'Territory',
                        value: 'North District',
                        isLast: false,
                      ),
                      _ProfileRow(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        value: '+1 555-0042',
                        isLast: false,
                      ),
                      _ProfileRow(
                        icon: Icons.shield_outlined,
                        title: 'Role',
                        value: 'Sales Rep',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEAEAE4)),
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
                      // App Settings
                      _ActionRow(
                        icon: Icons.settings_outlined,
                        title: 'App Settings',
                        iconBg: const Color(0xFFF4F4EE),
                        iconColor: const Color(0xFF6B7280),
                        textColor: const Color(0xFF374151),
                        chevronColor: const Color(0xFFD1D5DB),
                        onTap: () {},
                        isLast: false,
                      ),
                      // End Session & Logout
                      _ActionRow(
                        icon: Icons.logout,
                        title: 'End Session & Logout',
                        iconBg: const Color(0xFFFFE8E6),
                        iconColor: _brandRed,
                        textColor: _brandRed,
                        chevronColor: _brandRed.withValues(alpha: 0.35),
                        onTap: onLogout,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                // Footer brand text
                const Center(
                  child: Text(
                    'WAZZA3 · v1.0',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3.0,
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
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.90),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8E6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _brandRed, size: 16),
          ),
          const SizedBox(width: 16),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.iconBg,
    required this.iconColor,
    required this.textColor,
    required this.chevronColor,
    required this.onTap,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final Color iconBg;
  final Color iconColor;
  final Color textColor;
  final Color chevronColor;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            // Chevron
            Icon(Icons.chevron_right, color: chevronColor, size: 16),
          ],
        ),
      ),
    );
  }
}
