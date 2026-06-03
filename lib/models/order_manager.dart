import 'dart:async';
import 'package:flutter/material.dart';

enum OrderStatus { enAttente, enTransit, livre }

class OrderModel {
  final String id;
  final String productName;
  final double productPrice;
  final String productImage;
  final DateTime date;
  final OrderStatus status;
  final String orderNumber;

  OrderModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.date,
    required this.status,
    required this.orderNumber,
  });
}

class OrderManager {
  static final ValueNotifier<List<OrderModel>> ordersNotifier = ValueNotifier<List<OrderModel>>([]);

  static void addOrder(String name, double price, String image) {
    final newOrder = OrderModel(
      id: DateTime.now().toString(),
      productName: name,
      productPrice: price,
      productImage: image,
      date: DateTime.now(),
      status: OrderStatus.enAttente,
      orderNumber: 'ZM-${(1000 + ordersNotifier.value.length * 7)}',
    );

    ordersNotifier.value = [newOrder, ...ordersNotifier.value];

    Timer(const Duration(minutes: 1), () {
      ordersNotifier.value = ordersNotifier.value.map((order) {
        if (order.id == newOrder.id) {
          return OrderModel(
            id: order.id,
            productName: order.productName,
            productPrice: order.productPrice,
            productImage: order.productImage,
            date: order.date,
            status: OrderStatus.enTransit,
            orderNumber: order.orderNumber,
          );
        }
        return order;
      }).toList();
    });
  }
}