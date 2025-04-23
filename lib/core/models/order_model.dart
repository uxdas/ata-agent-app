// lib/core/models/order_model.dart

class OrderItemModel {
  final String productName;
  final double price;
  final int quantity;

  double get total => price * quantity;

  OrderItemModel({
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'price': price,
    'quantity': quantity,
    'total': total,
  };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productName: json['productName'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class OrderModel {
  final String id;
  final String clientName;
  final String distributorName;
  final String orderType;
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final double total;

  OrderModel({
    required this.id,
    required this.clientName,
    required this.distributorName,
    required this.orderType,
    required this.orderDate,
    required this.items,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientName': clientName,
    'distributorName': distributorName,
    'orderType': orderType,
    'orderDate': orderDate.toIso8601String(),
    'items': items.map((item) => item.toJson()).toList(),
    'total': total,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      clientName: json['clientName'],
      distributorName: json['distributorName'],
      orderType: json['orderType'],
      orderDate: DateTime.parse(json['orderDate']),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      total: json['total'],
    );
  }
}