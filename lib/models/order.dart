import 'product.dart';

enum OrderStatus { enAttente, enTransit, livre }

class OrderModel {
  final String id;
  final Product product;
  final DateTime date;
  final int quantity;
  final OrderStatus status;
  final String orderNumber;

  OrderModel({
    required this.id,
    required this.product,
    required this.date,
    required this.quantity,
    required this.status,
    required this.orderNumber,
  });
}