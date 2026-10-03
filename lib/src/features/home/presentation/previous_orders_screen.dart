import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazza3/l10n/app_localizations.dart';

import '../../../core/enums/request_status.dart';
import '../../../core/network/remote/models/delivery_order.dart';
import '../../../core/routing/app_routes.dart';
import '../../auth/logic/controllers/auth_cubit.dart';
import '../logic/controllers/history_cubit.dart';
import '../logic/controllers/history_state.dart';

const _brandRed = Color(0xFFE52B13);
const _brandRedDark = Color(0xFFAF2409);
const _cardBg = Color(0xFFFFFFFF);
const _navBg = Color(0xFFEAEAE4);

class PreviousOrdersScreen extends StatelessWidget {
  const PreviousOrdersScreen({super.key, this.initialOrders});

  final List<DeliveryOrder>? initialOrders;

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthCubit>().state;
    final uid = authUser?.uid ?? 0;
    final password = authUser?.token ?? '';

    return BlocProvider(
      create: (context) {
        final cubit = HistoryCubit(initialOrders: initialOrders);
        if (uid != 0 && password.isNotEmpty) {
          cubit.fetchHistory(
            uid: uid,
            password: password,
            isRefresh: initialOrders != null && initialOrders!.isNotEmpty,
          );
        }
        return cubit;
      },
      child: _PreviousOrdersContent(
        uid: uid,
        password: password,
      ),
    );
  }
}

class _PreviousOrdersContent extends StatefulWidget {
  const _PreviousOrdersContent({
    required this.uid,
    required this.password,
  });

  final int uid;
  final String password;

  @override
  State<_PreviousOrdersContent> createState() => _PreviousOrdersContentState();
}

class _PreviousOrdersContentState extends State<_PreviousOrdersContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (widget.uid != 0 && widget.password.isNotEmpty) {
        context.read<HistoryCubit>().loadMore(
              uid: widget.uid,
              password: widget.password,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ─── Header Gradient ───
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                bottom: 14,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_brandRed, _brandRedDark],
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
                    child: BlocBuilder<HistoryCubit, HistoryState>(
                      builder: (context, state) {
                        final count = state.orders.length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n?.previousOrders ?? 'Previous Orders',
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
                              l10n?.completedOrdersCount(count.toString()) ?? '$count orders',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ─── Orders List ───
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state.status.isLoading && state.orders.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: _brandRed),
                    );
                  }

                  if (state.status.isFailure && state.orders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade400, size: 44),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage ?? 'Failed to load previous orders',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brandRed,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                if (widget.uid != 0 && widget.password.isNotEmpty) {
                                  context.read<HistoryCubit>().fetchHistory(
                                        uid: widget.uid,
                                        password: widget.password,
                                      );
                                }
                              },
                              icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                              label: const Text('Retry', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.orders.isEmpty) {
                    return RefreshIndicator(
                      color: _brandRed,
                      onRefresh: () async {
                        if (widget.uid != 0 && widget.password.isNotEmpty) {
                          await context.read<HistoryCubit>().fetchHistory(
                                uid: widget.uid,
                                password: widget.password,
                                isRefresh: true,
                              );
                        }
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 48, color: Color(0xFF9CA3AF)),
                                SizedBox(height: 12),
                                Text(
                                  'No previous delivery orders found',
                                  style: TextStyle(
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
                      if (widget.uid != 0 && widget.password.isNotEmpty) {
                        await context.read<HistoryCubit>().fetchHistory(
                              uid: widget.uid,
                              password: widget.password,
                              isRefresh: true,
                            );
                      }
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: state.orders.length + (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index >= state.orders.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(color: _brandRed, strokeWidth: 2.5),
                            ),
                          );
                        }
                        final order = state.orders[index];
                        return _HistoryOrderCard(order: order);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryOrderCard extends StatelessWidget {
  const _HistoryOrderCard({required this.order});
  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    final status = order.finalStatus ?? order.state ?? 'draft';
    final dateStr = order.date ?? '';
    final vehicleStr = order.displayVehicle.isNotEmpty ? ' · ${order.displayVehicle}' : '';
    final stopsCount = order.stopCount ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.doDetails,
          arguments: order,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_shipping_outlined,
                color: _brandRed,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.displayReference,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1F2937),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _navBg,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF4B5563),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dateStr$vehicleStr · $stopsCount stops',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
