import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final User? user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 120),
      child: Column(
        children: [
          // 
          if (user == null) ...[
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF3e5219).withOpacity(0.1),
              child: const Icon(Icons.person_outline, size: 60, color: Color(0xFF3e5219)),
            ),
            const SizedBox(height: 16),
            Text('Welcome Guest', style: GoogleFonts.ebGaramond(fontSize: 28, color: const Color(0xFF3e5219))),
            const Text('Join us to track your orders', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/auth'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3e5219),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('SIGN IN / REGISTER'),
            ),
          ] 
          // 
          else ...[
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.photoURL ?? 'https://ui-avatars.com/api/?name=${user.email}'),
            ),
            const SizedBox(height: 16),
            Text(user.displayName ?? 'Artisan Lover', style: GoogleFonts.ebGaramond(fontSize: 28, color: const Color(0xFF3e5219))),
            Text('MEMBER SINCE 2024', style: const TextStyle(fontSize: 10, letterSpacing: 2, color: Color(0xFF94492c))),
            const SizedBox(height: 40),
            _profileItem('Account Settings', Icons.settings_outlined),
            _profileItem('My Orders', Icons.shopping_bag_outlined),
            _profileItem('Shipping Addresses', Icons.location_on_outlined),
            const SizedBox(height: 20),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut(); 
                Navigator.pushReplacementNamed(context, '/main');
              },
              title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
              leading: const Icon(Icons.logout, color: Colors.redAccent),
            ),
          ],
        ],
      ),
    );
  }

  Widget _profileItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3e5219)),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}