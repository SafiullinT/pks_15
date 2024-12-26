import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pks_14/api/product_api.dart';
import 'package:pks_14/models/cart.dart';
import 'package:pks_14/models/product.dart';
import '../cart_bloc/cart_bloc.dart';
import '../cart_bloc/cart_state.dart';
import '../order_bloc/order_bloc.dart';
import '../order_bloc/order_event.dart';
import '../order_bloc/order_state.dart';
import '../widgets/cart_product_card.dart';

class CartPage extends StatelessWidget {
  final ProductApi productApi;

  const CartPage({
    Key? key,
    required this.productApi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, orderState) {
        if (orderState.status == OrderStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Заказ оформлен!')),
          );
        } else if (orderState.status == OrderStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка оформления заказа: ${orderState.errorMessage}')),
          );
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Корзина"),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
            ),
            body: state.carts.isEmpty
                ? _buildEmptyCart()
                : _buildCartContent(context, state.carts),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Text(
        "Корзина пуста",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<Product?> getProduct(int productId) async {
    try {
      return await productApi.getProduct(productId);
    } catch (e) {
      debugPrint('Error fetching product: $e');
      return null;
    }
  }

  Future<double> calculateTotal(List<Cart> carts) async {
    double total = 0;
    for (var cart in carts) {
      Product? product = await getProduct(cart.productId);
      if (product != null) {
        total += product.price * cart.quantity;
      }
    }
    return total;
  }

  Widget _buildCartContent(BuildContext context, List<Cart> carts) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: carts.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Product?>(
              future: getProduct(carts[index].productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text("Ошибка загрузки товара");
                } else if (snapshot.hasData) {
                  return CartProductCard(
                    product: snapshot.data!,
                    quantity: carts[index].quantity,
                  );
                } else {
                  return const Text("Товар не найден");
                }
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 16, color: Colors.grey),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildTotalSection(context, carts),
        ),
      ],
    );
  }

  Widget _buildTotalSection(BuildContext context, List<Cart> carts) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: FutureBuilder<double>(
        future: calculateTotal(carts),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Text(
              "Ошибка расчета суммы",
              style: TextStyle(color: Colors.white, fontSize: 16),
            );
          } else {
            final total = snapshot.data ?? 0;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Итого: \$${total.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: context.read<OrderBloc>().state.status == OrderStatus.loading
                      ? null
                      : () {
                    context.read<OrderBloc>().add(CreateOrder(carts));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: context.read<OrderBloc>().state.status == OrderStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text("Оформить заказ", style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
