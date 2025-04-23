import 'package:dio/dio.dart';
import 'package:agent_pro/core/network/api_client.dart';
import 'package:agent_pro/core/models/order_model.dart';

class OrderApiService {
  final ApiClient api;

  OrderApiService(this.api);

  Future<void> sendOrder(OrderModel order) async {
    try {
      final response = await api.dio.post(
        '/orders', // 🔁 здесь замени на свой реальный endpoint
        data: order.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Ошибка при отправке заказа: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }
}
