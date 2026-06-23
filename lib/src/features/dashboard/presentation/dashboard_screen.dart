import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/app_routes.dart';
import '../../auth/logic/controllers/auth_cubit.dart';
import '../../home/presentation/widgets/home_view.dart';
import '../../inventory/presentation/widgets/inventory_view.dart';
import '../../profile/presentation/widgets/profile_view.dart';
import '../../wallet/presentation/widgets/wallet_view.dart';

const _bgPage = Color(0xFFF9FAEC);
const _brandRed = Color(0xFFE52B13);

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  int _navIndex = 0; // 0=Home, 1=Inventory, 2=Wallet, 3=Profile

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state;
    final driverName = user?.name ?? 'Driver';
    final bottomPad = MediaQuery.of(context).padding.bottom;

    Widget body;
    if (_navIndex == 3) {
      body = ProfileView(driverName: driverName, onLogout: _logout);
    } else if (_navIndex == 2) {
      body = const WalletView();
    } else if (_navIndex == 1) {
      body = const InventoryView();
    } else {
      body = HomeView(driverName: driverName, onLogout: _logout);
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
                      decoration: const BoxDecoration(
                        color: _brandRed,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(2)),
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
