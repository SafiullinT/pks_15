import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pks_14/models/order.dart';
import 'package:pks_14/order_bloc/order_bloc.dart';
import 'package:pks_14/order_bloc/order_state.dart';
import 'package:pks_14/widgets/order_card.dart';
import 'package:pks_14/pages/home_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return _buildScaffold(context, state.orders);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, List<Order> orders) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ваши заказы"),
        backgroundColor: Colors.blue,
        elevation: 6,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: orders.isEmpty
          ? _buildEmptyState(context)
          : _buildOrderList(context, orders),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            "У вас нет заказов",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Перейти в каталог"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<Order> orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOrderCard(orders[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      shadowColor: Colors.deepPurpleAccent.withOpacity(0.3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purpleAccent.withOpacity(0.1), Colors.white],
            ),
          ),
          child: OrderCard(order: order),
        ),
      ),
    );
  }
}
