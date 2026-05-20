import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart'; 
import '../providers/favorite_provider.dart';
import '../data/static_data.dart'; // List dyal les 30 produits
import 'product_detail_screen.dart'; // <-- Hna rj3na l-import dyal screen detail bباش l-navigation tkhdem direct

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  RangeValues priceRange = const RangeValues(30, 5000); 
  String selectedRegion = 'All';
  int selectedRating = 0; 

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view},
    {'name': 'Cosmetics', 'icon': Icons.spa},
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Artisanat', 'icon': Icons.palette},
  ];

  final List<String> regions = ['All', 'Marrakech', 'Tiznit', 'Agadir', 'Essaouira'];

  @override
  Widget build(BuildContext context) {
    
    // --- GA3 LES FILTRES KHSTATUS REAL-TIME (Safe Mode) ---
    final List<Product> displayedProducts = products.where((product) {
      final matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesPrice = product.price >= priceRange.start && product.price <= priceRange.end;
      
      String productRegion = 'All';
      double productRating = 4.8;
      try {
        productRegion = (product as dynamic).region ?? 'All';
        productRating = ((product as dynamic).rating ?? 4.8).toDouble();
      } catch (e) {
        productRegion = 'All';
        productRating = 4.8;
      }

      final matchesRegion = selectedRegion == 'All' || productRegion.toLowerCase() == selectedRegion.toLowerCase();
      final matchesRating = productRating >= selectedRating;

      return matchesCategory && matchesSearch && matchesPrice && matchesRegion && matchesRating;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFfffbf7), // Khlfiya clean m9adda b-7al screen.jpg
      body: SafeArea(
        child: Column(
          children: [
            // 1. SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFf7f4f0), 
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: const InputDecoration(
                    hintText: 'Search for Huile, Tapis, Dattes...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.black54),
                    suffixIcon: Icon(Icons.mic, color: Color(0xFF3e5219)),
                  ),
                ),
              ),
            ),

            // FILTERS & GRID SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. CATEGORIES TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text('CATEGORIES', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219), letterSpacing: 1)),
                    ),
                    
                    // CATEGORIES LIST
                    SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: categories.length,
                        itemBuilder: (ctx, i) {
                          bool isSelected = selectedCategory == categories[i]['name'];
                          return GestureDetector(
                            onTap: () => setState(() => selectedCategory = categories[i]['name']),
                            child: Container(
                              margin: const EdgeInsets.only(right: 24),
                              child: Column(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF94492c) : const Color(0xFFebe8df),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      categories[i]['icon'], 
                                      color: isSelected ? Colors.white : const Color(0xFF3e5219)
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    categories[i]['name'], 
                                    style: GoogleFonts.dmSans(
                                      fontSize: 11, 
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, 
                                      color: isSelected ? const Color(0xFF94492c) : const Color(0xFF3e5219)
                                    )
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 3. PRICE RANGE SLIDER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PRICE RANGE', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219), letterSpacing: 1)),
                              Text('PRICE: ${priceRange.start.toInt()} - ${priceRange.end.toInt()} DH', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: const Color(0xFF94492c), fontSize: 12)),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF3e5219),
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: const Color(0xFF94492c),
                            ),
                            child: RangeSlider(
                              values: priceRange,
                              min: 0,
                              max: 5000,
                              onChanged: (values) => setState(() => priceRange = values),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 4. REGION FILTER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REGION', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219), letterSpacing: 1)),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 38,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: regions.length,
                              itemBuilder: (context, index) {
                                bool isSelected = selectedRegion == regions[index];
                                return GestureDetector(
                                  onTap: () => setState(() => selectedRegion = regions[index]),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF3e5219) : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: isSelected ? const Color(0xFF3e5219) : Colors.grey[300]!),
                                    ),
                                    child: Center(
                                      child: Text(
                                        regions[index],
                                        style: GoogleFonts.dmSans(color: isSelected ? Colors.white : const Color(0xFF3e5219), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 5. RATING FILTER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RATING', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219), letterSpacing: 1)),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () => setState(() => selectedRating = index + 1),
                                    child: Icon(
                                      index < selectedRating ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 26,
                                    ),
                                  );
                                }),
                              ),
                              if (selectedRating > 0)
                                TextButton(
                                  onPressed: () => setState(() => selectedRating = 0),
                                  child: const Text('Clear', style: TextStyle(color: Colors.red, fontSize: 12)),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),

                    // COUNT RESULTS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('${displayedProducts.length} Results Found', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                    ),

                    // 6. GRID OF PRODUCTS
                    displayedProducts.isEmpty 
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(child: Text("Aucun produit trouvé")),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: displayedProducts.length,
                        itemBuilder: (ctx, i) => _buildProductCard(context, displayedProducts[i]),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
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
      // 🚨 Hna rj3na l-navigation l-haqiqi l-m9adda b material page route direct sans bogue
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFf7f4f0),
                    child: Image.network(
                      product.image, 
                      width: double.infinity, 
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                    ),
                  ),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    onTap: () => favProvider.toggleFavorite(product.id),
                    child: CircleAvatar(
                      backgroundColor: Colors.white, radius: 16,
                      child: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 18, color: isFav ? Colors.red : Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COOPÉRATIVE CERTIFIÉE', style: GoogleFonts.dmSans(color: Colors.black38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(product.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF45483c)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${product.price} DH', style: GoogleFonts.dmSans(color: const Color(0xFF94492c), fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        Text(' 4.8', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}