import 'package:wazza3/l10n/app_localizations.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../customers/data/repos/customer_repository.dart';

class NewOrderDraftScreen extends StatefulWidget {
  const NewOrderDraftScreen({super.key});

  @override
  State<NewOrderDraftScreen> createState() => _NewOrderDraftScreenState();
}

class _NewOrderDraftScreenState extends State<NewOrderDraftScreen> {
  Customer? _selectedCustomer;
  bool _showCustomerSelector = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // List of draft lines
  final List<_DraftLine> _draftLines = [
    _DraftLine(),
  ];

  static const List<_ProductInfo> _products = [
    _ProductInfo(id: 'i1', name: 'Premium Water 1L', price: 2.5, unit: 'Ctn', available: 40),
    _ProductInfo(id: 'i2', name: 'Sparkling Water 500ml', price: 1.5, unit: 'Ctn', available: 60),
    _ProductInfo(id: 'i3', name: 'Energy Drink 250ml', price: 3.0, unit: 'Ctn', available: 25),
    _ProductInfo(id: 'i4', name: 'Juice Orange 1L', price: 4.0, unit: 'Ctn', available: 15),
    _ProductInfo(id: 'i5', name: 'Iced Tea 500ml', price: 2.0, unit: 'Ctn', available: 50),
  ];

  bool get _isValid {
    if (_selectedCustomer == null) return false;
    if (_draftLines.isEmpty) return false;
    for (final line in _draftLines) {
      if (line.productId == null) return false;
    }
    return true;
  }

  double get _totalPrice {
    double total = 0.0;
    for (final line in _draftLines) {
      if (line.productId != null) {
        final prod = _products.firstWhere((p) => p.id == line.productId);
        total += prod.price * line.quantity;
      }
    }
    return total;
  }

  void _addProductLine() {
    setState(() {
      _draftLines.add(_DraftLine());
    });
  }

  void _removeProductLine(int index) {
    setState(() {
      _draftLines.removeAt(index);
    });
  }

  void _addNewCustomer() {
    final nameCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String type = 'Retail';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(AppLocalizations.of(context)!.addNewCustomer, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        hintText: 'e.g. Corner Shop',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addrCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'e.g. 12 High St',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        hintText: 'e.g. +1 555-0909',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.typeLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        DropdownButton<String>(
                          value: type,
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => type = val);
                            }
                          },
                          items: [
                            DropdownMenuItem(value: 'Retail', child: Text(AppLocalizations.of(context)!.retail)),
                            DropdownMenuItem(value: 'Horeca', child: Text(AppLocalizations.of(context)!.horeca)),
                            DropdownMenuItem(value: 'Wholesale', child: Text(AppLocalizations.of(context)!.wholesale)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE52B13)),
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty && addrCtrl.text.isNotEmpty) {
                      final newCust = Customer(
                        name: nameCtrl.text,
                        address: addrCtrl.text,
                        phone: phoneCtrl.text.isEmpty ? '+1 555-9999' : phoneCtrl.text,
                        type: type,
                      );
                      CustomerRepository.instance.addCustomer(newCust);
                      setState(() {
                        _selectedCustomer = newCust;
                        _showCustomerSelector = false;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save, style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createOrder() {
    if (!_isValid) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9F2E3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF0B6B54),
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.orderCreated,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sales Order for ${_selectedCustomer?.name} has been created successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE52B13),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Pop dialog
                    Navigator.pop(context); // Pop draft screen
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = CustomerRepository.instance.customers.where((c) {
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.address.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAEC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE5E7EB), height: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B5563)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.newOrderDraft,
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CUSTOMER SECTION HEADER
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(AppLocalizations.of(context)!.customer,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    
                    // Selected Customer or Selector Trigger
                    if (_selectedCustomer == null) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCustomerSelector = !_showCustomerSelector;
                          });
                        },
                        child: CustomPaint(
                          painter: const _DashedBorderPainter(
                            color: Color(0xFFD1D5DB),
                            strokeWidth: 1.5,
                            gap: 4.5,
                            dashLength: 4.5,
                            borderRadius: 20.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            alignment: Alignment.center,
                            child: Text(AppLocalizations.of(context)!.tapToSelectACustomer,
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Dropdown list container when selector is open
                      if (_showCustomerSelector) ...[
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Search Input
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) {
                                    setState(() {
                                      _searchQuery = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                                    hintText: 'Search customers...',
                                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFF3F4F6)),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFE52B13)),
                                    ),
                                  ),
                                ),
                              ),
                              // Customer List
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 240),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: filteredCustomers.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                                  itemBuilder: (context, index) {
                                    final cust = filteredCustomers[index];
                                    
                                    // Badge styling
                                    Color badgeBg;
                                    Color badgeFg;
                                    if (cust.type == 'Retail') {
                                      badgeBg = const Color(0xFFDBEAFE);
                                      badgeFg = const Color(0xFF2563EB);
                                    } else if (cust.type == 'Horeca') {
                                      badgeBg = const Color(0xFFFEF3C7);
                                      badgeFg = const Color(0xFFD97706);
                                    } else {
                                      badgeBg = const Color(0xFFF3E8FF);
                                      badgeFg = const Color(0xFF9333EA);
                                    }

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedCustomer = cust;
                                          _showCustomerSelector = false;
                                          _searchQuery = '';
                                          _searchController.clear();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cust.name,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF1F2937),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    cust.address,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF9CA3AF),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: badgeBg,
                                                borderRadius: BorderRadius.circular(99),
                                              ),
                                              child: Text(
                                                cust.type,
                                                style: TextStyle(
                                                  color: badgeFg,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Bottom add customer bar
                              InkWell(
                                onTap: _addNewCustomer,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFA9D7CD),
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_add_outlined, color: Color(0xFF0B4A38), size: 16),
                                      SizedBox(width: 6),
                                      Text(AppLocalizations.of(context)!.addNewCustomer,
                                        style: TextStyle(
                                          color: Color(0xFF0B4A38),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ] else
                      // Selected Customer Card
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCustomer = null;
                            _showCustomerSelector = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFA9D7CD), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedCustomer!.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedCustomer!.address,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _selectedCustomer!.phone,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Customer Group Type Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: _selectedCustomer!.type == 'Retail'
                                            ? const Color(0xFFDBEAFE)
                                            : _selectedCustomer!.type == 'Horeca'
                                                ? const Color(0xFFFEF3C7)
                                                : const Color(0xFFF3E8FF),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        _selectedCustomer!.type,
                                        style: TextStyle(
                                          color: _selectedCustomer!.type == 'Retail'
                                              ? const Color(0xFF2563EB)
                                              : _selectedCustomer!.type == 'Horeca'
                                                  ? const Color(0xFFD97706)
                                                  : const Color(0xFF9333EA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
                            ],
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // PRODUCTS SECTION HEADER
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(AppLocalizations.of(context)!.products,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    
                    // Products List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _draftLines.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final line = _draftLines[index];
                        final selectedProd = line.productId != null
                            ? _products.firstWhere((p) => p.id == line.productId)
                            : null;
                        
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  // Index Badge
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE52B13),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Dropdown selector
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFFE5E7EB)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: line.productId,
                                          hint: Text(AppLocalizations.of(context)!.selectProduct,
                                            style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                                          ),
                                          isExpanded: true,
                                          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1F2937),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              line.productId = val;
                                            });
                                          },
                                          items: _products.map((p) {
                                            return DropdownMenuItem<String>(
                                              value: p.id,
                                              child: Text('${p.name} — \$${p.price}/${p.unit}'),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_draftLines.length > 1) ...[
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Color(0xFF9CA3AF)),
                                      onPressed: () => _removeProductLine(index),
                                    ),
                                  ],
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Quantity selector, item price, and stock info
                              Row(
                                children: [
                                  // Quantity +/- box
                                  Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 36,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.remove, size: 14, color: Color(0xFF4B5563)),
                                            onPressed: () {
                                              if (line.quantity > 1) {
                                                setState(() => line.quantity--);
                                              }
                                            },
                                          ),
                                        ),
                                        Text(
                                          '${line.quantity}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 36,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.add, size: 14, color: Color(0xFF4B5563)),
                                            onPressed: () {
                                              setState(() => line.quantity++);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 12),
                                  
                                  // Line item total price
                                  if (selectedProd != null) ...[
                                    Text(
                                      '\$${(selectedProd.price * line.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Color(0xFF0B6B54),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${selectedProd.available} avail.',
                                      style: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Add Another Product Button
                    GestureDetector(
                      onTap: _addProductLine,
                      child: CustomPaint(
                        painter: const _DashedBorderPainter(
                          color: Color(0xFFD1D5DB),
                          strokeWidth: 1.5,
                          gap: 4.5,
                          dashLength: 4.5,
                          borderRadius: 16.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Color(0xFF6B7280), size: 16),
                              SizedBox(width: 4),
                              Text(AppLocalizations.of(context)!.addAnotherProduct,
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // ORDER SUMMARY CARD
                    if (_draftLines.any((l) => l.productId != null)) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9F2E3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x260B6B54)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.inventory_2_outlined, color: Color(0xFF0B6B54), size: 16),
                                SizedBox(width: 6),
                                Text(AppLocalizations.of(context)!.orderSummary,
                                  style: TextStyle(
                                    color: Color(0xFF0B6B54),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Line items
                            ..._draftLines.where((l) => l.productId != null).map((line) {
                              final prod = _products.firstWhere((p) => p.id == line.productId);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${prod.name} ×${line.quantity}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF063527),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '\$${(prod.price * line.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF063527),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const Divider(color: Color(0x260B6B54), height: 20),
                            // Total Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.total,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF063527),
                                  ),
                                ),
                                Text(
                                  '\$${_totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF063527),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
            
            // BOTTOM ACTION BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isValid ? 1.0 : 0.6,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _isValid ? const Color(0xFFE52B13) : const Color(0xFFE2E2D8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isValid ? [
                      BoxShadow(
                        color: const Color(0xFFE52B13).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isValid ? _createOrder : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: _isValid ? Colors.white : const Color(0xFF9CA3AF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.createSalesOrder,
                          style: TextStyle(
                            color: _isValid ? Colors.white : const Color(0xFF9CA3AF),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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

class _DraftLine {
  _DraftLine();
  String? productId;
  int quantity = 1;
}

class _ProductInfo {
  const _ProductInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.available,
  });

  final String id;
  final String name;
  final double price;
  final String unit;
  final int available;
}

// ─── Dashed Border Painter ──────────────────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 4.0,
    this.dashLength = 4.0,
    this.borderRadius = 20.0,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final Path path = Path()..addRRect(rrect);

    final Path dashPath = Path();
    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final double len = dashLength;
        if (distance + len > metric.length) {
          dashPath.addPath(metric.extractPath(distance, metric.length), Offset.zero);
        } else {
          dashPath.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
