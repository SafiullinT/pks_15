import 'package:equatable/equatable.dart';
import 'package:pks_14/models/product.dart';

class Order extends Equatable {
  final int? orderId;
  final int userId;
  late final double total;
  final String status;
  final List<Product> products;

  Order({
    required this.orderId,
    required this.userId,
    required this.total,
    required this.status,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      userId: json['user_id'],
      total: json['total'].toDouble(),
      status: json['status'],
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total': total,
      'status': status,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [userId, total, status, products];
}