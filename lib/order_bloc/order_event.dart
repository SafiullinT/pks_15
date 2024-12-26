import 'package:equatable/equatable.dart';
import 'package:pks_14/models/cart.dart';
import 'package:pks_14/models/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {
  final int userId;

  const LoadOrders(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateOrder extends OrderEvent {
  final List<Cart> cartItems;
  const CreateOrder(this.cartItems);
}