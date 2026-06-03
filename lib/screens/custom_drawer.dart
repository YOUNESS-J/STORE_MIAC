import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final String activeRoute; 

  const CustomNavigationDrawer({
    super.key, 
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    final String userName = currentUser?.displayName ?? 
        (currentUser?.email != null ? currentUser!.email!.split('@')[0] : 'Artisan MIAC');
    
    final String userEmail = currentUser?.email ?? 'Pas d\'email disponible';
    final String? userPhoto = currentUser?.photoURL;

    return Drawer(
      child: Container(
        color: const Color(0xFFFCF9F5), 
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF3E5219), width: 1.5),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: userPhoto != null
                            ? Image.network(
                                userPhoto,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Color(0xFF3E5219), size: 30),
                              )
                            : const Icon(Icons.person, color: Color(0xFF3E5219), size: 30), 
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName, 
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3E5219),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail, 
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'SELLER MODE',
                            style: GoogleFonts.dmSans(
                              fontSize: 10, 
                              color: const Color(0xFF94492C),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(color: Colors.black12, thickness: 1, indent: 24, endIndent: 24),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    isSelected: activeRoute == 'dashboard',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.storefront_outlined,
                    label: 'Products',
                    isSelected: activeRoute == 'products',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.receipt_long_outlined,
                    label: 'Orders',
                    isSelected: activeRoute == 'orders',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet',
                    isSelected: activeRoute == 'wallet',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.black12, thickness: 1, indent: 24, endIndent: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0, top: 8.0),
              child: _buildDrawerItem(
                context: context,
                icon: Icons.logout_rounded,
                label: 'Déconnexion',
                isSelected: false,
                isLogout: true,
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final Color activeColor = const Color(0xFF3E5219); 
    final Color inactiveColor = isLogout ? Colors.redAccent.shade700 : Colors.black54;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? activeColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? activeColor : inactiveColor, size: 22),
        title: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFCF9F5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Déconnexion', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: const Color(0xFF3E5219))),
          content: Text('Voulez-vous vraiment vous déconnecter ?', style: GoogleFonts.dmSans(color: Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler', style: GoogleFonts.dmSans(color: Colors.black54, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
              },
              child: Text('Déconnexion', style: GoogleFonts.dmSans(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}