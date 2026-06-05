import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_miac/screens/cart_screen.dart';
import 'package:audioplayers/audioplayers.dart'; // L-package l-jdīd
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart'; 
import 'checkout_screen.dart'; 

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({required this.product, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // N-sm3o l-player ila sala l-audio bo7do, n-rj3o l-icon l-Play
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // S-sawt y-skt o y-tms7 mn l-mémoire ila khrjna
    super.dispose();
  }

  // L-methode li kat-7ded s-smiya d l-audio mn loun/smiya d produit
  String _getAudioPath(String productName) {
    String name = productName.toLowerCase();
    if (name.contains('foulard')) return 'audio/foulard.mp3';
    if (name.contains('safran') || name.contains('cactus')) return 'audio/zafran.mp3';
    
    // Default audio ila l-produit makaynch s-sawt dyalo exact
    return 'audio/default_histoire.mp3'; 
  }

  void _showHistoireBottomSheet(BuildContext context, String productName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: const BoxDecoration(
            color: Color(0xFFfcf9f0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, 
                  height: 5, 
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.mic_external_on_rounded, color: Color(0xFF94492c)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "L'histoire de: $productName",
                      style: GoogleFonts.ebGaramond(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.product.description,
                    style: GoogleFonts.dmSans(fontSize: 15, color: const Color(0xFF45483c), height: 1.6, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3e5219),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _audioPlayer.stop();
                    setState(() => _isPlaying = false);
                    Navigator.pop(ctx);
                  },
                  child: Text("Fermer", style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      _audioPlayer.stop();
      setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favProvider.isFavorite(widget.product.id);

    return Scaffold(
      backgroundColor: const Color(0xFFfcf9f0),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'img-${widget.product.id}',
                    child: Image.network(widget.product.image, fit: BoxFit.cover),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "OR PUR D'ESSAOUIRA",
                        style: TextStyle(color: Colors.blue[900], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: GoogleFonts.ebGaramond(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.product.price.toInt()} DH',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF94492c)),
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

                      // Bouton dynamic dyal l-audio mp3 dyalk 7é9é9i!
                      GestureDetector(
                        onTap: () async {
                          if (_isPlaying) {
                            await _audioPlayer.stop();
                            setState(() => _isPlaying = false);
                          } else {
                            setState(() => _isPlaying = true);
                            
                            // Kat-playi l-audio mn l-assets nichan
                            String audioPath = _getAudioPath(widget.product.name);
                            await _audioPlayer.play(AssetSource(audioPath));
                            
                            _showHistoireBottomSheet(context, widget.product.name);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF5b42f3), Color(0xFF8000ff)]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: const Color(0xFF5b42f3).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                          ),
                          child: Row(
                            children: [
                              Icon(_isPlaying ? Icons.stop_circle_rounded : Icons.play_circle_fill, color: Colors.white, size: 40),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isPlaying ? "Lecture du récit..." : "Écouter la voix de l'artisane",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const Text("Enregistrement audio authentique", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                ),
                              ),
                              if (_isPlaying) const Icon(Icons.volume_up, color: Colors.white)
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(widget.product.description, style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF45483c))),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(15)),
                    child: IconButton(
                      onPressed: () => favProvider.toggleFavorite(widget.product.id),
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          Navigator.pushNamed(context, '/auth');
                        } else {
                          Provider.of<CartProvider>(context, listen: false).addItem(widget.product);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(product: widget.product)));
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
                          Text('Acheter maintenant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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