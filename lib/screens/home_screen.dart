import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/product_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const HeroHeader(),
        const CategoryScroll(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OUR SELECTION', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: const Color(0xFF94492c))),
              Text('Artisanal Essentials', style: GoogleFonts.ebGaramond(fontSize: 32, color: const Color(0xFF3e5219))),
            ],
          ),
        ),
        const ProductGrid(),
        const SizedBox(height: 120),
      ],
    );
  }
}

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDtSduEhBgScu2-bzyAKQfGMYqsxfv-yHyRcVWg1ZcyRgfKmSGCO_NUYKfBPj4sakVIVxr0o_AXR2tt2WYeOeoWSC5cIfnrYzYCEyYNCzqBOsWpxCzLirayAS0TvWA7aLMObNuwVolmCx_J1KT1hdm5O2fdaMFWeHNsq8YRRhZlEAKJnBL4bY_z0zgWIU4KuCW00LfHX2FILg2e6SvIizWOAmUd7bFRvzzBwEeLgXRkFo9HOOjg9tBI1bWn8VjG23OKBXieKp1DRY1z'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, const Color(0xFF3e5219).withOpacity(0.7)],
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pure Moroccan\nArgan Oil', style: GoogleFonts.ebGaramond(fontSize: 42, color: Colors.white, height: 1.1)),
            const SizedBox(height: 12),
            const Text('Liquid gold harvested from the heart of the Souss Valley.', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {}, // Zid navigation dyalk hna ila bghitiha tdih lchi blassa
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3e5219), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), shape: const StadiumBorder()),
              child: const Text('EXPLORE COLLECTION'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScroll extends StatelessWidget {
  const CategoryScroll({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = [
      {'name': 'Oils', 'icon': Icons.oil_barrel_outlined},
      {'name': 'Spices', 'icon': Icons.spa_outlined},
      {'name': 'Honey', 'icon': Icons.emoji_nature},
      {'name': 'Beauty', 'icon': Icons.brush_outlined},
    ];

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: cats.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(color: const Color(0xFFebe8df), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF3e5219).withOpacity(0.05))),
                  child: Icon(cats[i]['icon'] as IconData, color: const Color(0xFF3e5219), size: 28),
                ),
                const SizedBox(height: 8),
                Text(cats[i]['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF45483c))),
              ],
            ),
          );
        },
      ),
    );
  }
}