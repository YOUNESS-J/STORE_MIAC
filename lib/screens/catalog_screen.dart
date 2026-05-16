import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart'; 
import '../providers/favorite_provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'All';

  //
  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view, 'color': Color(0xFFe8f0d1)},
    {'name': 'Cosmetics', 'icon': Icons.spa, 'color': Color(0xFFf9e8d4)},
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Color(0xFFf9d4d4)},
    {'name': 'Artisanat', 'icon': Icons.palette, 'color': Color(0xFFd4e2f9)},
  ];

  @override
  Widget build(BuildContext context) {
    // 
    final List<Product> dummyProducts = [
      Product(id: '1', name: 'Huile d\'Argan Bio', price: 250, image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqtqS9S9YIxGmT4TMbcZ_NWNZva0lp7pqaGVrbSYkbJxXTIfOnlhbqdin09VYV6ausL4awSZ1Xs5xhHD-pFtcMS8OJpDTplWslVP64EilnAmJlv5pJdMX4m316uk9e0zcyNAMSenHIQPLzuVRmoYr_Av0efluphUFa7TELPi8CXzt7nssfEgz0jYJy43Da4WrLDuhf3FBzAeIQA5llx7NhErXYs1GZAhohGhzh3Wf8pgRU7NmdWwwkPzvjXUZLXSNhZQUGUs1tMr_l', description: 'Pure 100%', category: 'Cosmetics'),
      Product(id: '2', name: 'Premium Saffron', price: 1200, image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAwIy0Q24UXeoOBS93iLwRMLlH7uv7axphyY2eR3goFrgX4tL5H3sqczL6MlA6XWqWzWLxUdXnUxAec1-M_fG7rtlRsUOyMoDFtJjUKOFlBjWsv2CNaoO-bqurwWstDVuQ484F9ACBktaysVHhvt3BIEXHz7J1ViLHm3TPGKpnqfu6DKwxB6Qxj4PLxjpIGQF31mby9vCbit1aGIfcP0ZhQYfpuqbmVZD7dT2a_1NZbJwKkFdIooIhLRUtC_01RnEO59zQ3OnC1Ja3m', description: 'Fait main', category: 'Artisanat'),
      Product(id: '3', name: 'Miel de Thym', price: 180, image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDvTNVCYYbnpLTIOO3_SZG77oqAtQ5otdFkmP_y38U6W7DmX16da3HqX8YHbmLH1rl-5UlA9rZ6kyolzOL0yd59_1lL5ai4y8NfakMw7Jy9U_2aM5iFK6pG5BH3tKnnhmjtuopskbpbRkXyrRr5CzOfzu97RtzRRdycdcADL0p7HdOkN4HdTS3N8cc6TOswDVwAcxESbQ7fp6x0TPeAOx2uIhZSB1WJN32gZavAXZb-TEhIRITnQv_whNUDfrwx7o4VFYWWI_VHtjTQ', description: 'Naturel', category: 'Food'),
      Product(id: '4', name: 'Atlas Clay Mask', price: 850, image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFrsXdO8iuhRRZjnQtRTxCO_u4n_hsy1bTn8bcCYsPl8qlR2E1QcLj5Z2gU8flpKBgjKveWaguxL-wriDc59C2wG27sPSqQHMY4jrz2ZWh6L1hOy0hEBAbxzpizVUWqkvnP-No1dxr5CMJgjaH21RcUi0dhB_BzxzCu-Lu0HMwrshJMNHvCkFME8TRPOunbv-DPCM7W5Q9ty6U1cIGs6QkMqzjSH5P05oO27DfFi3NL51wYLmovzV6VGfWitWjYPTEHKfWn-slJvam', description: 'Soie pure', category: 'Artisanat'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFfcf9f0),
      body: SafeArea(
        child: Column(
          children: [
            // 1. BARRE DE RECHERCHE (Search Bar)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher Argan, Tapis...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Color(0xFF3e5219)),
                    suffixIcon: Icon(Icons.tune, color: Color(0xFF3e5219)),
                  ),
                ),
              ),
            ),

            // 2. LES CATÉGORIES 
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: categories.length,
                itemBuilder: (ctx, i) {
                  bool isSelected = selectedCategory == categories[i]['name'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = categories[i]['name']),
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF3e5219) : categories[i]['color'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              categories[i]['icon'],
                              color: isSelected ? Colors.white : const Color(0xFF3e5219),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            categories[i]['name'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: const Color(0xFF3e5219),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 3. GRID DES PRODUITS 
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: dummyProducts.length,
                itemBuilder: (ctx, i) {
                  final product = dummyProducts[i];
                  return _buildProductCard(context, product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    bool isFav = favProvider.isFavorite(product.id);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Heart Icon
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(product.image, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: GestureDetector(
                      onTap: () => favProvider.toggleFavorite(product.id),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        radius: 15,
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 16, color: isFav ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info Produit
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COOPÉRATIVE ATLAS',
                    style: TextStyle(color: Colors.blue[900], fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price} DH',
                        style: const TextStyle(color: Color(0xFF94492c), fontWeight: FontWeight.bold),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 10),
                          Text(' 4.8', style: TextStyle(fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}