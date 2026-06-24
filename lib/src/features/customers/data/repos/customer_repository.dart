import 'dart:async';

class Customer {
  const Customer({
    required this.name,
    required this.address,
    required this.phone,
    required this.type,
  });

  final String name;
  final String address;
  final String phone;
  final String type;
}

class CustomerRepository {
  CustomerRepository._();
  static final CustomerRepository instance = CustomerRepository._();

  final List<Customer> _customers = [
    const Customer(name: 'Downtown Mart', address: '123 Main St, Downtown', phone: '+1 555-0101', type: 'Retail'),
    const Customer(name: 'Uptown Groceries', address: '456 High St, Uptown', phone: '+1 555-0202', type: 'Retail'),
    const Customer(name: 'City Cafe & Diner', address: '78 Park Ave, Midtown', phone: '+1 555-0303', type: 'Horeca'),
    const Customer(name: 'North Star Wholesale', address: '890 Industrial Blvd, Northside', phone: '+1 555-0404', type: 'Wholesale'),
    const Customer(name: 'Beachside Kiosk', address: '55 Ocean Dr, Seaside', phone: '+1 555-0505', type: 'Retail'),
  ];

  final _controller = StreamController<List<Customer>>.broadcast();

  List<Customer> get customers => List.unmodifiable(_customers);
  Stream<List<Customer>> get customersStream => _controller.stream;

  void addCustomer(Customer customer) {
    _customers.add(customer);
    _controller.add(customers);
  }
}
