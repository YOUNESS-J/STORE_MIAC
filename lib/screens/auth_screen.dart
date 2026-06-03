import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false; 
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false; 

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _submitAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!isLogin) {
      if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
        _showError('Veuillez remplir tous les champs');
        return;
      }
      if (password != _confirmPasswordController.text.trim()) {
        _showError('Les mots de passe ne correspondent pas');
        return;
      }
      if (!_acceptTerms) {
        _showError("Veuillez accepter les conditions d'utilisation");
        return;
      }
    }

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await userCredential.user?.updateDisplayName(_nameController.text.trim());
      }
      
      if (mounted) {
        Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showError('The account already exists for that email.');
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showError('Invalid email or password.');
      } else {
        _showError(e.message ?? 'An error occurred. Please try again.');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfcf9f5), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3e5219)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                isLogin 
                    ? const Icon(Icons.star, size: 55, color: Color(0xFF3e5219)) 
                    : const Icon(Icons.supervised_user_circle_outlined, size: 60, color: Color(0xFF3e5219)), 
                const SizedBox(height: 12),
                Text(
                  isLogin ? 'MIAC' : 'WELCOM', 
                  style: GoogleFonts.ebGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3e5219),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLogin ? 'PURE ORGANIC LIVING' : "Découvrez l'authenticité de l'artisanat marocain.",
                  style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black45, letterSpacing: isLogin ? 2 : 0),
                ),
                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabItem('LOGIN', isLogin, () => setState(() => isLogin = true)),
                          _buildTabItem('SIGN UP', !isLogin, () => setState(() => isLogin = false)),
                        ],
                      ),
                      const SizedBox(height: 25),

                      if (isLogin) ...[
                        _buildInputFieldLabel('Email Address'),
                        _buildTextField(_emailController, 'votre@email.com', suffixIcon: const Icon(Icons.email_outlined, size: 20, color: Colors.black38)),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInputFieldLabel('Password'),
                            Text('Mot de passe oublié ?', style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF3e5219), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        _buildTextField(
                          _passwordController, 
                          '••••••••', 
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: Colors.black38),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildActionButton(isLoading ? 'CONNEXION...' : 'LOG IN', isLoading ? null : _submitAuth),
                      ] else ...[
                        _buildInputFieldLabel('Nom / Prénom'),
                        _buildTextField(_nameController, 'Ahmed Benani', suffixIcon: const Icon(Icons.person_outline, size: 20, color: Colors.black38)),
                        const SizedBox(height: 14),
                        _buildInputFieldLabel('Email'),
                        _buildTextField(_emailController, 'ahmed@exemple.com', suffixIcon: const Icon(Icons.email_outlined, size: 20, color: Colors.black38)),
                        const SizedBox(height: 14),
                        _buildInputFieldLabel('Téléphone'),
                        _buildTextField(_phoneController, '+212 600 000 000', suffixIcon: const Icon(Icons.phone_outlined, size: 20, color: Colors.black38)),
                        const SizedBox(height: 14),
                        _buildInputFieldLabel('Mot de passe'),
                        _buildTextField(
                          _passwordController, 
                          '••••••••', 
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: Colors.black38),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildInputFieldLabel('Confirmer le mot de passe'),
                        _buildTextField(
                          _confirmPasswordController, 
                          '••••••••', 
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: Colors.black38),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _acceptTerms,
                                activeColor: const Color(0xFF3e5219),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black54),
                                  children: [
                                    const TextSpan(text: "J'accepte les "),
                                    TextSpan(text: "conditions d'utilisation", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                                    const TextSpan(text: " et la "),
                                    TextSpan(text: "politique de confidentialité", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildActionButton(isLoading ? 'INSCRIPTION...' : 'Créer mon compte', isLoading ? null : _submitAuth),
                      ],

                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = !isLogin),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black54),
                              children: [
                                TextSpan(text: isLogin ? "Pas encore de compte ? " : "Vous avez déjà un compte ? "),
                                TextSpan(
                                  text: isLogin ? 'Créer un compte' : 'Se connecter',
                                  style: const TextStyle(color: Color(0xFF94492c), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (isLogin) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text('OU CONTINUER AVEC', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38)),
                      ),
                      const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildGoogleButton(), 
                      const SizedBox(width: 16),
                      _buildFacebookButton(),
                    ],
                  ),
                ],

                const SizedBox(height: 30),
                Text(
                  isLogin 
                    ? "Rejoignez +5,000 passionnés d'artisanat authentique."
                    : "Soutenez les coopératives locales de l'Atlas.",
                  style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(text, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF3e5219) : Colors.black38)),
          const SizedBox(height: 4),
          Container(height: 2, width: 40, color: isActive ? const Color(0xFF3e5219) : Colors.transparent),
        ],
      ),
    );
  }

  Widget _buildInputFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF45483c))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFf7f4f0), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF94492c), 
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12), 
          borderRadius: BorderRadius.circular(12), 
          color: Colors.white
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CustomPaint(
                    painter: GoogleLogoPainter(),
                  ),
                ),
              ),
              Text('Google', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookButton() {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12), 
          borderRadius: BorderRadius.circular(12), 
          color: Colors.white
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 24),
              const SizedBox(width: 8),
              Text('Facebook', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double r = size.width / 2;

    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(r, r)
      ..lineTo(r - 0.7 * r, r - 0.7 * r)
      ..arcToPoint(Offset(r + 0.7 * r, r - 0.7 * r), radius: Radius.circular(r), clockwise: true)
      ..close();
    canvas.drawPath(redPath, paint);

    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(r, r)
      ..lineTo(r - 0.7 * r, r - 0.7 * r)
      ..arcToPoint(Offset(r - 0.9 * r, r + 0.3 * r), radius: Radius.circular(r), clockwise: false)
      ..close();
    canvas.drawPath(yellowPath, paint);

    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(r, r)
      ..lineTo(r - 0.9 * r, r + 0.3 * r)
      ..arcToPoint(Offset(r + 0.6 * r, r + 0.8 * r), radius: Radius.circular(r), clockwise: false)
      ..close();
    canvas.drawPath(greenPath, paint);

    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(r, r)
      ..lineTo(r + 0.6 * r, r + 0.8 * r)
      ..arcToPoint(Offset(r + 0.7 * r, r - 0.7 * r), radius: Radius.circular(r), clockwise: false)
      ..lineTo(r, r - 0.1 * r)
      ..close();
    canvas.drawPath(bluePath, paint);

    paint.color = Colors.white;
    canvas.drawCircle(Offset(r, r), r * 0.5, paint);

    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(Rect.fromLTWH(r, r - 2, r * 0.9, 4), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}