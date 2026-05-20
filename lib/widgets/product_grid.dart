import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/static_data.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required String selectedCategory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 20, mainAxisSpacing: 30),
      itemCount: products.length,
      itemBuilder: (context, i) => ProductCard(product: products[i]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'img-${product.id}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFF31312b).withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(product.image, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(product.name, style: GoogleFonts.ebGaramond(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1c1c17))),
          Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF75796b), fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}