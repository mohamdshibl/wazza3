import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/models/mobile_notification.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../auth/logic/controllers/auth_cubit.dart';
import '../../logic/controllers/notifications_cubit.dart';
import '../../logic/controllers/notifications_state.dart';

const _brandRed = Color(0xFFE52B13);
const _cardBg = Color(0xFFFFFFFF);
const _navBg = Color(0xFFEAEAE4);

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthCubit>().state;
    final uid = authUser?.uid ?? 0;
    final password = authUser?.token ?? '';

    return BlocProvider(
      create: (context) {
        final cubit = NotificationsCubit();
        if (uid != 0 && password.isNotEmpty) {
          cubit.fetchNotifications(uid: uid, password: password, unreadOnly: false);
        }
        return cubit;
      },
      child: _NotificationsContent(
        uid: uid,
        password: password,
      ),
    );
  }
}

class _NotificationsContent extends StatefulWidget {
  const _NotificationsContent({
    required this.uid,
    required this.password,
  });

  final int uid;
  final String password;

  @override
  State<_NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<_NotificationsContent> {
  bool _unreadOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAEC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ─── Drag Handle & Header ───
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.notifications_outlined, color: _brandRed, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (context, state) {
                        final unreadList = state.notifications.where((n) => !n.isRead).toList();
                        if (unreadList.isEmpty) return const SizedBox.shrink();

                        return TextButton(
                          onPressed: state.isMarkingRead
                              ? null
                              : () {
                                  context.read<NotificationsCubit>().markAsRead(
                                        uid: widget.uid,
                                        password: widget.password,
                                        notificationIds: unreadList.map((n) => n.id).toList(),
                                      );
                                },
                          style: TextButton.styleFrom(
                            foregroundColor: _brandRed,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          child: const Text('Mark all read', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF6B7280), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Filter Tabs: All vs Unread
                Row(
                  children: [
                    _buildFilterChip('All', !_unreadOnly, () {
                      setState(() => _unreadOnly = false);
                    }),
                    const SizedBox(width: 8),
                    _buildFilterChip('Unread', _unreadOnly, () {
                      setState(() => _unreadOnly = true);
                    }),
                  ],
                ),
              ],
            ),
          ),

          // ─── Notifications List ───
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state.status.isLoading && state.notifications.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: _brandRed),
                  );
                }

                if (state.status.isFailure && state.notifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade400, size: 44),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage ?? 'Failed to load notifications',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: _brandRed),
                            onPressed: () {
                              context.read<NotificationsCubit>().fetchNotifications(
                                    uid: widget.uid,
                                    password: widget.password,
                                    unreadOnly: _unreadOnly,
                                  );
                            },
                            child: const Text('Retry', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final displayList = _unreadOnly
                    ? state.notifications.where((n) => !n.isRead).toList()
                    : state.notifications;

                if (displayList.isEmpty) {
                  return RefreshIndicator(
                    color: _brandRed,
                    onRefresh: () async {
                      await context.read<NotificationsCubit>().fetchNotifications(
                            uid: widget.uid,
                            password: widget.password,
                            unreadOnly: false,
                            isRefresh: true,
                          );
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.notifications_off_outlined, size: 30, color: Color(0xFF9CA3AF)),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _unreadOnly ? 'No unread notifications' : 'No notifications yet',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: _brandRed,
                  onRefresh: () async {
                    await context.read<NotificationsCubit>().fetchNotifications(
                          uid: widget.uid,
                          password: widget.password,
                          unreadOnly: false,
                          isRefresh: true,
                        );
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: displayList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = displayList[index];
                      return _NotificationCard(
                        item: item,
                        onTap: () {
                          if (!item.isRead) {
                            context.read<NotificationsCubit>().markAsRead(
                                  uid: widget.uid,
                                  password: widget.password,
                                  notificationIds: [item.id],
                                );
                          }
                          if (item.doId != null && item.doId! > 0) {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.doDetails,
                              arguments: item.doId,
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _brandRed : _navBg,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onTap,
  });

  final MobileNotification item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !item.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFFFFBEB) : _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread ? const Color(0xFFFDE68A) : const Color(0xFFF3F4F6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isUnread ? const Color(0xFFFEF3C7) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isUnread ? Icons.mark_email_unread_outlined : Icons.mail_outline,
                color: isUnread ? const Color(0xFFD97706) : const Color(0xFF6B7280),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.createdAt != null)
                        Text(
                          item.createdAt!,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                        ),
                    ],
                  ),
                  if (item.message != null && item.message!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.message!,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
