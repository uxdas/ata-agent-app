import 'package:agent_pro/core/network/api_client.dart';
import 'package:agent_pro/core/models/order_model.dart';

class OrderService {
  final ApiClient apiClient;

  OrderService(this.apiClient);

  Future<void> sendOrder(OrderModel order) async {
    try {
      final response = await apiClient.post(
        '/orders', // 🛠 заменишь на свой эндпоинт
        data: order.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Ошибка при отправке заказа: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при отправке заказа: $e');
    }
  }
}
