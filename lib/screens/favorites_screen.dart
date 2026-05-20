import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorite_provider.dart';
import '../data/static_data.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    

    final List<Product> favoriteProducts = products.where((product) {
      return favProvider.isFavorite(product.id);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFfcf9f0), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3e5219)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Mes Favoris',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2d2f2a),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Retrouvez ici vos coups de cœur de l'artisanat marocain.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 25),
              

              Expanded(
                child: favoriteProducts.isEmpty
                    ? const Center(
                        child: Text(
                          "Aucun produit favori pour le moment.",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : GridView.builder(
                        itemCount: favoriteProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68, 
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (ctx, i) {
                          final product = favoriteProducts[i];
                          

                          String productRegion = 'Maroc';
                          String coopName = 'Coopérative';
                          try {
                            productRegion = (product as dynamic).region ?? 'Maroc';
                            coopName = (product as dynamic).cooperative ?? '${product.category} Coop';
                          } catch (_) {}

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: Image.network(
                                            product.image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported)),
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF94492c).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              productRegion,
                                              style: const TextStyle(
                                                color: Color(0xFF94492c),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: GestureDetector(
                                            onTap: () => favProvider.toggleFavorite(product.id),
                                            child: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child: Icon(Icons.favorite, size: 16, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Color(0xFF3e5219),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                coopName.toUpperCase(),
                                                style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3e5219)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${product.price} MAD',
                                          style: const TextStyle(color: Color(0xFF94492c), fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}