import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazza3/l10n/app_localizations.dart';

import '../../../../core/enums/request_status.dart';
import '../../../../core/widgets/dot_grid_painter.dart';
import '../../../auth/logic/controllers/auth_cubit.dart';
import '../../logic/controllers/profile_cubit.dart';
import '../../logic/controllers/profile_state.dart';
import 'change_password_sheet.dart';

const _brandRed = Color(0xFFE52B13);
const _brandRedDark = Color(0xFFAF2409);

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.onLogout,
    this.driverName,
  });

  final VoidCallback onLogout;
  final String? driverName;

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthCubit>().state;
    final uid = authUser?.uid ?? 0;
    final password = authUser?.token ?? '';

    return BlocProvider(
      create: (context) {
        final cubit = ProfileCubit();
        if (uid != 0 && password.isNotEmpty) {
          cubit.fetchProfile(uid: uid, password: password);
        }
        return cubit;
      },
      child: _ProfileViewContent(
        fallbackName: driverName ?? authUser?.name ?? 'Driver',
        uid: uid,
        password: password,
        onLogout: onLogout,
      ),
    );
  }
}

class _ProfileViewContent extends StatelessWidget {
  const _ProfileViewContent({
    required this.fallbackName,
    required this.uid,
    required this.password,
    required this.onLogout,
  });

  final String fallbackName;
  final int uid;
  final String password;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        final displayName = profile?.name.isNotEmpty == true ? profile!.name : fallbackName;
        final employeeCode = profile?.employeeCode ?? '';
        final username = profile?.username ?? '';
        final mustChangePassword = profile?.mustChangePassword ?? false;
        final vehicles = profile?.vehicles ?? const [];
        final areas = profile?.areas ?? const [];

        return RefreshIndicator(
          color: _brandRed,
          onRefresh: () async {
            if (uid != 0 && password.isNotEmpty) {
              await context.read<ProfileCubit>().fetchProfile(
                    uid: uid,
                    password: password,
                    isRefresh: true,
                  );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // ─── Profile Header Section (Red gradient with dot grid + avatar) ───
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.7, -1),
                      end: Alignment(1, 1),
                      colors: [_brandRedDark, _brandRed],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Dot grid
                      const Positioned.fill(
                        child: CustomPaint(painter: DotGridPainter()),
                      ),
                      // Radial glow
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
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, top + 28, 16, 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.18),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'D',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Name
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Primary Role Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.verified_user_outlined, size: 12, color: Colors.white),
                                    const SizedBox(width: 5),
                                    Text(
                                      l10n?.salesRep ?? 'Sales Rep',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (employeeCode.isNotEmpty || username.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                // Sub-badges (Employee code & Username)
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    if (employeeCode.isNotEmpty)
                                      _HeaderBadge(
                                        icon: Icons.badge_outlined,
                                        label: employeeCode,
                                      ),
                                    if (username.isNotEmpty)
                                      _HeaderBadge(
                                        icon: Icons.alternate_email,
                                        label: username,
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Body Content ───
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Not signed in state
                      if (uid == 0 || password.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
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
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE8E6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.lock_outline, color: _brandRed, size: 24),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Authentication Required',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Please sign in with your credentials to view your live profile, vehicles, and assigned areas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brandRed,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                onPressed: onLogout,
                                icon: const Icon(Icons.login, size: 18, color: Colors.white),
                                label: const Text(
                                  'Sign In Again',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ]
                      // Loading State
                      else if (state.status.isLoading && profile == null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                            child: CircularProgressIndicator(color: _brandRed),
                          ),
                        ),
                      ]
                      // Error State
                      else if (state.status.isFailure && profile == null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade400, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                state.errorMessage ?? 'Failed to load profile data',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brandRed,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  context.read<ProfileCubit>().fetchProfile(
                                        uid: uid,
                                        password: password,
                                      );
                                },
                                icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                                label: const Text('Retry', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // 1. Password change alert banner
                        if (mustChangePassword) ...[
                          GestureDetector(
                            onTap: () => ChangePasswordSheet.show(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFFCD34D)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 24),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Password Change Required',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Color(0xFF92400E),
                                          ),
                                        ),
                                        Text(
                                          'Tap here to update your password now →',
                                          style: TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Color(0xFFD97706), size: 18),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // 2. Assigned Vehicles Card
                        _SectionCard(
                          title: 'Assigned Vehicles',
                          icon: Icons.local_shipping_outlined,
                          child: vehicles.isEmpty
                              ? const _EmptyRow(text: 'No vehicles assigned')
                              : Column(
                                  children: List.generate(vehicles.length, (i) {
                                    final v = vehicles[i];
                                    return _ItemTile(
                                      icon: Icons.local_shipping_outlined,
                                      title: v.name,
                                      badge: v.id != null ? '#${v.id}' : null,
                                      isLast: i == vehicles.length - 1,
                                    );
                                  }),
                                ),
                        ),
                        const SizedBox(height: 14),

                        // 3. Assigned Service Areas Card
                        _SectionCard(
                          title: 'Assigned Service Areas',
                          icon: Icons.map_outlined,
                          child: areas.isEmpty
                              ? const _EmptyRow(text: 'No service areas assigned')
                              : Column(
                                  children: List.generate(areas.length, (i) {
                                    final a = areas[i];
                                    return _ItemTile(
                                      icon: Icons.location_on_outlined,
                                      title: a.name,
                                      badge: a.id != null ? 'Zone #${a.id}' : null,
                                      isLast: i == areas.length - 1,
                                    );
                                  }),
                                ),
                        ),
                        const SizedBox(height: 14),

                        // 4. Account Details Card
                        _SectionCard(
                          title: 'Account Information',
                          icon: Icons.person_outline,
                          child: Column(
                            children: [
                              _ProfileRow(
                                icon: Icons.badge_outlined,
                                title: 'Employee Code',
                                value: employeeCode.isNotEmpty ? employeeCode : 'N/A',
                                isLast: false,
                              ),
                              _ProfileRow(
                                icon: Icons.alternate_email,
                                title: 'Username',
                                value: username.isNotEmpty ? username : 'N/A',
                                isLast: false,
                              ),
                              _ProfileRow(
                                icon: Icons.shield_outlined,
                                title: l10n?.role ?? 'Role',
                                value: l10n?.salesRep ?? 'Sales Representative',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // ─── Actions Card ───
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
                            // Change Password
                            _ActionRow(
                              icon: Icons.lock_reset,
                              title: 'Change Password',
                              iconBg: const Color(0xFFEFF6FF),
                              iconColor: const Color(0xFF2563EB),
                              textColor: const Color(0xFF1F2937),
                              chevronColor: const Color(0xFF9CA3AF),
                              onTap: () => ChangePasswordSheet.show(context),
                              isLast: false,
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            // End Session & Logout
                            _ActionRow(
                              icon: Icons.logout,
                              title: l10n?.endSessionLogout ?? 'End Session & Logout',
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

                      const SizedBox(height: 18),
                      // Footer brand text
                      Center(
                        child: Text(
                          l10n?.wazza3V10 ?? 'WAZZA3 · DISTRIBUTION SYSTEM',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.95)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: _brandRed),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          child,
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.icon,
    required this.title,
    this.badge,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final String? badge;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8E6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _brandRed, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6B7280), size: 16),
          ),
          const SizedBox(width: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 14),
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
            Icon(Icons.chevron_right, color: chevronColor, size: 16),
          ],
        ),
      ),
    );
  }
}
