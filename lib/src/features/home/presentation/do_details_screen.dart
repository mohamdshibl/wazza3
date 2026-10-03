import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wazza3/l10n/app_localizations.dart';

import '../../../core/enums/request_status.dart';
import '../../../core/network/remote/models/delivery_order.dart';
import '../../auth/logic/controllers/auth_cubit.dart';
import '../logic/controllers/order_details_cubit.dart';
import '../logic/controllers/order_details_state.dart';

const _brandRed = Color(0xFFE52B13);
const _brandRedDark = Color(0xFFAF2409);
const _teal = Color(0xFF0B6B54);
const _cardBg = Color(0xFFFFFFFF);
const _navBg = Color(0xFFEAEAE4);

class DoDetailsScreen extends StatelessWidget {
  const DoDetailsScreen({
    super.key,
    this.initialOrder,
    this.orderId,
  });

  final DeliveryOrder? initialOrder;
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthCubit>().state;
    final uid = authUser?.uid ?? 0;
    final password = authUser?.token ?? '';
    final doId = initialOrder?.id ?? orderId ?? 0;

    return BlocProvider(
      create: (context) {
        final cubit = OrderDetailsCubit(initialOrder: initialOrder);
        if (uid != 0 && password.isNotEmpty && doId != 0) {
          cubit.fetchOrder(
            uid: uid,
            password: password,
            doId: doId,
            isRefresh: initialOrder != null,
          );
        }
        return cubit;
      },
      child: _DoDetailsContent(
        uid: uid,
        password: password,
        doId: doId,
      ),
    );
  }
}

class _DoDetailsContent extends StatefulWidget {
  const _DoDetailsContent({
    required this.uid,
    required this.password,
    required this.doId,
  });

  final int uid;
  final String password;
  final int doId;

  @override
  State<_DoDetailsContent> createState() => _DoDetailsContentState();
}

class _DoDetailsContentState extends State<_DoDetailsContent> {
  int _activeTab = 0; // 0 = Stops, 1 = Goods, 2 = Finance

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Color _getStatusBg(String status) {
    switch (status.toLowerCase()) {
      case 'done':
      case 'completed':
        return const Color(0xFFC9F2E3);
      case 'in_progress':
      case 'trip_started':
        return const Color(0xFFDBEAFE);
      case 'loading':
      case 'waiting_for_loading_order':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusFg(String status) {
    switch (status.toLowerCase()) {
      case 'done':
      case 'completed':
        return const Color(0xFF0B4A38);
      case 'in_progress':
      case 'trip_started':
        return const Color(0xFF1D4ED8);
      case 'loading':
      case 'waiting_for_loading_order':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF4B5563);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: _brandRedDark,
              ),
            );
          }
        },
        builder: (context, state) {
          final order = state.order;

          if (state.status.isLoading && order == null) {
            return const Scaffold(
              backgroundColor: Color(0xFFF9FAEC),
              body: Center(
                child: CircularProgressIndicator(color: _brandRed),
              ),
            );
          }

          if (state.status.isFailure && order == null) {
            return Scaffold(
              backgroundColor: const Color(0xFFF9FAEC),
              appBar: AppBar(
                backgroundColor: _brandRed,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text('Order Details', style: TextStyle(color: Colors.white)),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'Failed to load order details',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (widget.uid != 0 && widget.password.isNotEmpty && widget.doId != 0) {
                            context.read<OrderDetailsCubit>().fetchOrder(
                                  uid: widget.uid,
                                  password: widget.password,
                                  doId: widget.doId,
                                );
                          }
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                        label: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final displayRef = order?.displayReference ?? 'DO-${widget.doId}';
          final displayDate = order?.date ?? '';
          final status = order?.displayStatus ?? 'draft';
          final vehicle = order?.displayVehicle ?? '';
          final salesRep = order?.salesRep ?? '';
          final warehouse = order?.warehouse ?? '';
          final stopsCount = order?.stopCount ?? order?.stops.length ?? 0;
          final goodsCount = order?.itemsCount ?? order?.goods.length ?? 0;
          final totalAmount = order?.amountTotal ?? 0.0;
          final currency = order?.currency ?? 'USD';
          final actions = order?.actions;

          return Column(
            children: [
              // ─── Header Gradient ───
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  bottom: 12,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayRef,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (displayDate.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              displayDate,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusBg(status),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusFg(status),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Scrollable Body ───
              Expanded(
                child: RefreshIndicator(
                  color: _brandRed,
                  onRefresh: () async {
                    if (widget.uid != 0 && widget.password.isNotEmpty && widget.doId != 0) {
                      await context.read<OrderDetailsCubit>().fetchOrder(
                            uid: widget.uid,
                            password: widget.password,
                            doId: widget.doId,
                            isRefresh: true,
                          );
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 3-Metric Summary Cards
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  icon: Icons.route_outlined,
                                  iconColor: _brandRed,
                                  label: l10n?.stopsLabel ?? 'Stops',
                                  value: '$stopsCount',
                                  subtitle: 'Total stops',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildMetricCard(
                                  icon: Icons.inventory_2_outlined,
                                  iconColor: _teal,
                                  label: 'Items',
                                  value: '$goodsCount',
                                  subtitle: 'Total units',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildMetricCard(
                                  icon: Icons.payments_outlined,
                                  iconColor: const Color(0xFFD97706),
                                  label: 'Amount',
                                  value: '$currency ${totalAmount.toStringAsFixed(0)}',
                                  subtitle: 'Order value',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Vehicle & Sales Rep Info Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _cardBg,
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
                            children: [
                              if (vehicle.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(Icons.local_shipping_outlined, color: _brandRed, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        vehicle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF374151),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              if (vehicle.isNotEmpty && (salesRep.isNotEmpty || warehouse.isNotEmpty))
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                                ),
                              Row(
                                children: [
                                  if (salesRep.isNotEmpty) ...[
                                    const Icon(Icons.person_outline, color: Color(0xFF6B7280), size: 15),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        salesRep,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                  if (warehouse.isNotEmpty) ...[
                                    const Icon(Icons.warehouse_outlined, color: Color(0xFF6B7280), size: 15),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        warehouse,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Action Banner / Buttons
                        if (actions != null && (actions.startLoading || actions.confirmLoadedGoods || actions.startTrip))
                          _buildActionsBanner(context, actions, state.isActionLoading),

                        const SizedBox(height: 16),

                        // Tabs Selector: Stops | Goods | Finance
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _navBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              _buildTabItem(0, '${l10n?.stopsLabel ?? "Stops"} ($stopsCount)'),
                              _buildTabItem(1, 'Goods ($goodsCount)'),
                              _buildTabItem(2, 'Finance'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Tab Content
                        if (_activeTab == 0)
                          _buildStopsTab(order?.stops ?? [])
                        else if (_activeTab == 1)
                          _buildGoodsTab(order?.goods ?? [])
                        else
                          _buildFinanceTab(order),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
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
              Icon(icon, color: iconColor, size: 15),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsBanner(BuildContext context, DeliveryOrderActions actions, bool isLoading) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF1D4ED8), size: 16),
              SizedBox(width: 6),
              Text(
                'Available Actions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (actions.startLoading)
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<OrderDetailsCubit>().startLoading(
                            uid: widget.uid,
                            password: widget.password,
                            doId: widget.doId,
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 42),
              ),
              icon: const Icon(Icons.play_arrow, size: 16),
              label: const Text('Start Loading'),
            ),
          if (actions.confirmLoadedGoods) ...[
            if (actions.startLoading) const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<OrderDetailsCubit>().confirmLoadedGoods(
                            uid: widget.uid,
                            password: widget.password,
                            doId: widget.doId,
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 42),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 16),
              label: const Text('Confirm Loaded Goods'),
            ),
          ],
          if (actions.startTrip) ...[
            if (actions.startLoading || actions.confirmLoadedGoods) const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<OrderDetailsCubit>().startTrip(
                            uid: widget.uid,
                            password: widget.password,
                            doId: widget.doId,
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 42),
              ),
              icon: const Icon(Icons.navigation_outlined, size: 16),
              label: const Text('Start Trip'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF1F2937) : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStopsTab(List<DeliveryStop> stops) {
    if (stops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.route_outlined, size: 40, color: Color(0xFF9CA3AF)),
            SizedBox(height: 10),
            Text(
              'No delivery stops assigned yet',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: stops.map((stop) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBg,
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
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _navBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${stop.sequence > 0 ? stop.sequence : stops.indexOf(stop) + 1}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      stop.name.isNotEmpty ? stop.name : 'Customer Stop',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1F2937)),
                    ),
                  ),
                  if (stop.time.isNotEmpty)
                    Text(
                      stop.time,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                ],
              ),
              if (stop.address.isNotEmpty) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => _launchUrl('https://maps.google.com/?q=${Uri.encodeComponent(stop.address)}'),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: _brandRed),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stop.address,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                            decoration: TextDecoration.underline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (stop.phone.isNotEmpty) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => _launchUrl('tel:${stop.phone}'),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: _teal),
                      const SizedBox(width: 4),
                      Text(
                        stop.phone,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _teal,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoodsTab(List<DeliveryGoodItem> goods) {
    if (goods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 40, color: Color(0xFF9CA3AF)),
            SizedBox(height: 10),
            Text(
              'No loaded goods for this order',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: goods.map((g) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.shopping_bag_outlined, color: _brandRed, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1F2937)),
                    ),
                    if (g.productCode != null && g.productCode!.isNotEmpty)
                      Text(
                        g.productCode!,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${g.quantity} ${g.uom ?? "units"}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF374151)),
                  ),
                  if (g.priceSubtotal != null)
                    Text(
                      '\$${g.priceSubtotal!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 11, color: _teal, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFinanceTab(DeliveryOrder? order) {
    final currency = order?.currency ?? 'USD';
    final total = order?.amountTotal ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Financial Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 12),
          _buildFinanceRow('Total Invoiced', '$currency ${total.toStringAsFixed(2)}', isBold: true),
          const SizedBox(height: 8),
          _buildFinanceRow('Shift Reference', order?.shift?.reference ?? 'N/A'),
          const SizedBox(height: 8),
          _buildFinanceRow('Shift State', order?.shift?.state.toUpperCase() ?? 'N/A'),
          const SizedBox(height: 8),
          _buildFinanceRow('Warehouse', order?.warehouse ?? 'N/A'),
          const SizedBox(height: 8),
          _buildFinanceRow('Sales Rep', order?.salesRep ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildFinanceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFF1F2937) : const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
