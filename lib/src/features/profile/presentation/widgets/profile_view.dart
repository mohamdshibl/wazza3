import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/dot_grid_painter.dart';

const _brandRed = Color(0xFFE52B13);

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.driverName,
    required this.onLogout,
  });

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
                const Positioned.fill(
                  child: CustomPaint(painter: DotGridPainter()),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Badge(label: AppLocalizations.of(context)!.salesRep),
                          const SizedBox(width: 8),
                          _Badge(label: AppLocalizations.of(context)!.idRep042),
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
                  child: Column(
                    children: [
                      _ProfileRow(
                        icon: Icons.local_shipping_outlined,
                        title: AppLocalizations.of(context)!.assignedTruck,
                        value: AppLocalizations.of(context)!.truckA101,
                        isLast: false,
                      ),
                      _ProfileRow(
                        icon: Icons.location_on_outlined,
                        title: AppLocalizations.of(context)!.territory,
                        value: AppLocalizations.of(context)!.northDistrict,
                        isLast: false,
                      ),
                      _ProfileRow(
                        icon: Icons.phone_outlined,
                        title: AppLocalizations.of(context)!.phone,
                        value: '+1 555-0042',
                        isLast: false,
                      ),
                      _ProfileRow(
                        icon: Icons.shield_outlined,
                        title: AppLocalizations.of(context)!.role,
                        value: AppLocalizations.of(context)!.salesRep,
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
                        title: AppLocalizations.of(context)!.appSettings,
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
                        title: AppLocalizations.of(context)!.endSessionLogout,
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
                Center(
                  child: Text(AppLocalizations.of(context)!.wazza3V10,
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
