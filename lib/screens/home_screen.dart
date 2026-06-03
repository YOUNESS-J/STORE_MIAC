import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart'; 
import '../providers/favorite_provider.dart';
import '../data/static_data.dart';
import '../screens/product_detail_screen.dart'; 
import 'custom_drawer.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All'; 
  String searchQuery = '';

  final List<Map<String, dynamic>> homeCategories = [
    {'name': 'Cosmetics', 'icon': Icons.local_florist, 'dbName': 'Beauty'},
    {'name': 'Food', 'icon': Icons.restaurant, 'dbName': 'Culinary'},
    {'name': 'Crafts', 'icon': Icons.brush, 'dbName': 'Living'},
    {'name': 'Apparel', 'icon': Icons.checkroom, 'dbName': 'Jewelry'},
  ];

  final List<Map<String, String>> cooperatives = [
    {'name': 'Tiznit Silver', 'image': 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=150'},
    {'name': 'Argania Life', 'image': 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=150'},
    {'name': 'Atlas Weavers', 'image': 'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=150'},
    {'name': 'Zellij Art', 'image': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=150'},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Product> allProducts = products ?? []; 

    final List<Product> displayedProducts = allProducts.where((product) {
      bool matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFfffbf7),
      
      drawer: const CustomNavigationDrawer(activeRoute: 'dashboard'), 

      appBar: AppBar(
        backgroundColor: const Color(0xFFfffbf7),
        elevation: 0,
        
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF3e5219)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ), 
        title: Text(
          'MIAC',
          style: GoogleFonts.ebGaramond(
            color: const Color(0xFF3e5219), 
            fontWeight: FontWeight.bold, 
            fontSize: 24
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF3e5219)),
            onPressed: () {}, 
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf7f4f0), 
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: const InputDecoration(
                      hintText: 'Search for Argan, Rugs, or Jewelry...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.black54),
                      suffixIcon: Icon(Icons.tune, color: Color(0xFF94492c)),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity, 
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3e5219), 
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=600'),
                      fit: BoxFit.cover, 
                      opacity: 0.4, 
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      Text(
                        'NEW COLLECTION', 
                        style: GoogleFonts.dmSans(
                          color: Colors.white70, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 2
                        )
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Artisan Tiznit Silver', 
                        style: GoogleFonts.ebGaramond(
                          color: Colors.white, 
                          fontSize: 26, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF94492c), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10)
                        ),
                        child: Text(
                          'Explore Now', 
                          style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Categories', 
                        style: GoogleFonts.ebGaramond(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => selectedCategory = 'All'), 
                      child: Text(
                        'View All', 
                        style: GoogleFonts.dmSans(color: const Color(0xFF94492c), fontWeight: FontWeight.bold)
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, 
                  padding: const EdgeInsets.only(left: 20),
                  itemCount: homeCategories.length,
                  itemBuilder: (context, i) {
                    bool isSelected = selectedCategory == homeCategories[i]['dbName'];
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = isSelected ? 'All' : homeCategories[i]['dbName']),
                      child: Container(
                        margin: const EdgeInsets.only(right: 25),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28, 
                              backgroundColor: isSelected ? const Color(0xFF94492c) : const Color(0xFFebe8df),
                              child: Icon(
                                homeCategories[i]['icon'], 
                                color: isSelected ? Colors.white : const Color(0xFF3e5219)
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              homeCategories[i]['name'], 
                              style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF45483c), fontWeight: FontWeight.w500)
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Popular Products', 
                        style: GoogleFonts.ebGaramond(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: Text(
                        'See Trends', 
                        style: GoogleFonts.dmSans(color: const Color(0xFF94492c), fontWeight: FontWeight.bold)
                      ),
                    )
                  ],
                ),
              ),

              displayedProducts.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No products found")))
              : GridView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.63, 
                    crossAxisSpacing: 15, 
                    mainAxisSpacing: 15
                  ),
                  itemCount: displayedProducts.length > 4 ? 4 : displayedProducts.length,
                  itemBuilder: (ctx, i) => _buildProductCard(context, displayedProducts[i]),
                ),

              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certified Cooperatives', 
                      style: GoogleFonts.ebGaramond(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219))
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Supporting 200+ rural artisans directly', 
                      style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w400)
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, 
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  itemCount: cooperatives.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32, 
                            backgroundColor: const Color(0xFF94492c),
                            child: CircleAvatar(
                              radius: 30, 
                              backgroundImage: NetworkImage(cooperatives[i]['image']!)
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cooperatives[i]['name']!, 
                            style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF45483c), fontWeight: FontWeight.w500)
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    bool isFav = favProvider.isFavorite(product.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: 'img-${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: double.infinity, 
                      height: double.infinity, 
                      color: Colors.grey[100],
                      child: Image.network(
                        product.image, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image, color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10, 
                  right: 10,
                  child: GestureDetector(
                    onTap: () => favProvider.toggleFavorite(product.id),
                    child: CircleAvatar(
                      backgroundColor: Colors.white, 
                      radius: 16,
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border, 
                        size: 18, 
                        color: isFav ? Colors.red : Colors.grey
                      ),
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
                Text(
                  'ATLAS ARTISANS', 
                  style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 0.5)
                ),
                const SizedBox(height: 2),
                Text(
                  product.name, 
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF45483c)), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    Text(
                      ' ${product.rating ?? 4.8} (12)', 
                      style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.price.toInt()} DH', 
                  style: GoogleFonts.dmSans(color: const Color(0xFF94492c), fontWeight: FontWeight.bold, fontSize: 14)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}