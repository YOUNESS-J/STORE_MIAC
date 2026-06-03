import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';
import '../models/order_manager.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffbf7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfffbf7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF3e5219)),
          onPressed: () {},
        ),
        title: Text(
          'Zellij Market',
          style: GoogleFonts.ebGaramond(
            color: const Color(0xFF94492c),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<OrderModel>>(
        valueListenable: OrderManager.ordersNotifier,
        builder: (context, ordersList, child) {
          if (ordersList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 15),
                  Text(
                    'Aucune commande pour le moment',
                    style: GoogleFonts.dmSans(color: Colors.black45, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historique',
                  style: GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF2c2d27)),
                ),
                const SizedBox(height: 5),
                Text(
                  "Retrouvez l'ensemble de vos commandes artisanales.",
                  style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 25),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ordersList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return _buildOrderCard(context, ordersList[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf7f4f0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMMANDE #${order.orderNumber}',
                    style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5),
                  ),
                  Text(
                    '${order.date.day} Octobre ${order.date.year}',
                    style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  order.product.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.product.name,
                      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF45483c)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.product.price.toStringAsFixed(2).replaceAll('.', ',')} DH',
                      style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF94492c)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDeliveryTracker(order.status), 
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.grey[200]!.withOpacity(0.3),
              ),
              onPressed: () {},
              child: Text(
                'DÉTAILS DE LA COMMANDE',
                style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF45483c), letterSpacing: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    String text = '';
    Color bgColor = Colors.transparent;
    Color textColor = Colors.transparent;

    switch (status) {
      case OrderStatus.enAttente:
        text = 'En attente';
        bgColor = const Color(0xFFfcefe9);
        textColor = const Color(0xFF94492c);
        break;
      case OrderStatus.enTransit:
        text = 'Expédié';
        bgColor = const Color(0xFFeef3e6);
        textColor = const Color(0xFF3e5219);
        break;
      case OrderStatus.livre:
        text = 'Livré';
        bgColor = Colors.grey[200]!;
        textColor = Colors.black54;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
    );
  }

  Widget _buildDeliveryTracker(OrderStatus status) {
    int activeIndex = 0;
    if (status == OrderStatus.enTransit) activeIndex = 1;
    if (status == OrderStatus.livre) activeIndex = 2;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUIVI DE LIVRAISON',
            style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTrackerDot(activeIndex >= 0),
              _buildTrackerLine(activeIndex >= 1),
              _buildTrackerDot(activeIndex >= 1),
              _buildTrackerLine(activeIndex >= 2),
              _buildTrackerDot(activeIndex >= 2),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrackerLabel('Confirmé', activeIndex == 0),
              _buildTrackerLabel('En transit', activeIndex == 1),
              _buildTrackerLabel('Livré', activeIndex == 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerDot(bool isActive) {
    return CircleAvatar(radius: 5, backgroundColor: isActive ? const Color(0xFF3e5219) : Colors.grey[300]);
  }

  Widget _buildTrackerLine(bool isActive) {
    return Expanded(child: Container(height: 2, color: isActive ? const Color(0xFF3e5219) : Colors.grey[300]));
  }

  Widget _buildTrackerLabel(String text, bool isCurrent) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        color: isCurrent ? const Color(0xFF3e5219) : Colors.black38,
      ),
    );
  }
}