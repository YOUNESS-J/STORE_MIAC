import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart'; // Matnsach t-importi hada

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favProvider.isFavorite(product.id);

    return Scaffold(
      backgroundColor: const Color(0xFFfcf9f0),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. L'IMAGE LFO9 (Slider vibe)
              SliverAppBar(
                expandedHeight: 450,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'img-${product.id}',
                    child: Image.network(product.image, fit: BoxFit.cover),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SMIT L'COOPÉRATIVE
                      Text(
                        "OR PUR D'ESSAOUIRA",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // SMIT L'PRODUIT O L'TAMAN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.ebGaramond(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF3e5219),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${product.price.toInt()} DH',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94492c),
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 14),
                                  Text(" 4.9/5", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // 2. KHASIYA DYAL L'AUDIO (B7al f l'image)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5b42f3), Color(0xFF8000ff)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5b42f3).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.graphic_eq, color: Colors.white, size: 30),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Écouter l'histoire",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    "La voix de nos artisanes",
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {}, // Hna ghadi t-khdem l'audio moustaqbalan
                              icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // DESCRIPTION
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Color(0xFF45483c),
                        ),
                      ),

                      const SizedBox(height: 120), // Bach may-ghttich l'bouton lte7t
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. BARRE D'ACHAT L'TE7T (B7al l'image)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  // L'Glbiya (Favorite)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () => favProvider.toggleFavorite(product.id),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Ajouter au panier
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          Navigator.pushNamed(context, '/auth');
                        } else {
                          Provider.of<CartProvider>(context, listen: false).addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} ajouté !')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF94492c),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Ajouter au panier',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}