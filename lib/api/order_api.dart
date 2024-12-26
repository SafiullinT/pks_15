import 'package:pks_14/models/order.dart';

import 'api_service.dart';

class OrderApi {
  final ApiService _apiService;

  OrderApi(this._apiService);

  Future<List<Order>> getOrders(int userId) async {
    try {
      final response = await _apiService.dio.get(
          '${_apiService.baseUrl}/orders/$userId');
      if (response.statusCode == 200) {
        List<dynamic> ordersJson = response.data;
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Order> createOrder(Order order) async {
    try {
      final response = await _apiService.dio.post(
        '${_apiService.baseUrl}/orders/${order.userId}',
        data: order.toJson(),

      );
      if (response.statusCode == 201) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}