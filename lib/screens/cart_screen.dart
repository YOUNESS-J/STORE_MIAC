import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFfcf9f0),
      appBar: AppBar(
        title: Text('Votre Panier', style: GoogleFonts.ebGaramond(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219))),
        backgroundColor: Colors.transparent, elevation: 0,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Votre panier est vide.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final item = cart.items.values.toList()[i];
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(item.product.image, width: 80, height: 80, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${item.product.price} DH', style: const TextStyle(color: Color(0xFF94492c))),
                                ],
                              ),
                            ),
                            // L'bouton +/- (Feature 2)
                            Container(
                              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () => cart.removeSingleItem(item.product.id)),
                                  Text('${item.quantity}'),
                                  IconButton(icon: const Icon(Icons.add, size: 16), onPressed: () => cart.addItem(item.product)),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('${cart.totalAmount.toStringAsFixed(2)} DH', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF94492c))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {}, // Checkout Logic
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF94492c),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                        ),
                        child: const Text('Passer à la caisse →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}