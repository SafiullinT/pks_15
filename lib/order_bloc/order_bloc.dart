import 'package:pks_14/api/order_api.dart';
import 'package:pks_14/api/product_api.dart';
import 'package:pks_14/models/order.dart';
import 'package:pks_14/models/product.dart';
import 'package:pks_14/order_bloc/order_event.dart';
import 'package:pks_14/order_bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderApi _orderApi;
  final ProductApi _productApi;

  OrderBloc(this._orderApi, this._productApi) : super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final orders = await _orderApi.getOrders(event.userId);
      emit(state.copyWith(
        status: OrderStatus.success,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  //TODO: FIX _onCreateOrder !!

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {

      double total = 0;
      List<Product> productsInTheCart = [];

      for (var cartItem in event.cartItems) {
        try {
          Product thisProduct = await _productApi.getProduct(cartItem.productId);
          total += thisProduct.price * cartItem.quantity;
          productsInTheCart.add(thisProduct);
        } catch (e) {
          emit(state.copyWith(
            status: OrderStatus.failure,
            errorMessage: 'Failed to fetch product: ${cartItem.productId}',
          ));
          return;
        }
      }

      final newOrder = Order(
        orderId: 0,
        userId: 0,
        total: total,
        status: 'В обработке',
        products: productsInTheCart,
      );

      final createdOrder = await _orderApi.createOrder(newOrder);

      final updatedOrders = List<Order>.from(state.orders)..add(createdOrder);

      emit(state.copyWith(
        status: OrderStatus.success,
        orders: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: 'Failed to create order: ${e.toString()}',
      ));
    }
  }
}

/*
{
    "user_id": 0,
    "total": 4499.0,
    "status": "pending",
    "products": [
        {
            "product_id": 5,
            "name": "Мастера Пламени",
            "image_url": "https://website.cdn77.luckyduckgames.com/shop-products/September2022/Flamecraft_3Dbox_450x510_EN.png",
            "description": "Мастера Пламени (Flamecraft) — это очаровательные маленькие драконы, которые живут в небольшом городке в мире и согласии с людьми. Каждый игрок берёт на себя роль волшебника, который понимает язык этих удивительных созданий, а значит, может помочь городу процветать!",
            "price": 4499,
            "stock": 10
        }
    ]
}
 */