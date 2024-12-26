import 'package:flutter/material.dart';
import 'package:pks_14/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 180,
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 8,
          shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Заказ №${order.orderId}',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Стоимость: \$${order.total}',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Статус:  ',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                        color: order.status == 'Выполнен'
                            ? Colors.green
                            : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          order.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
