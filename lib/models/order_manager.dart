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

    // Kanzido l-commande jdida f l-lista
    ordersNotifier.value = [newOrder, ...ordersNotifier.value];

    // Mn b3d 30 tanya (30 seconds) -> twelli 'En transit'
    Timer(const Duration(seconds: 30), () {
      _updateOrderStatus(newOrder.id, OrderStatus.enTransit);
    });

    // Mn b3d d9i9a (60 seconds) -> twelli 'Livré' kifma bghiti!
    Timer(const Duration(seconds: 60), () {
      _updateOrderStatus(newOrder.id, OrderStatus.livre);
    });
  }

  // Methode bach t-misi a jour status bla ma n-khrb9o data
  static void _updateOrderStatus(String id, OrderStatus newStatus) {
    ordersNotifier.value = ordersNotifier.value.map((order) {
      if (order.id == id) {
        return OrderModel(
          id: order.id,
          productName: order.productName,
          productPrice: order.productPrice,
          productImage: order.productImage,
          date: order.date,
          status: newStatus,
          orderNumber: order.orderNumber,
        );
      }
      return order;
    }).toList();
  }
}