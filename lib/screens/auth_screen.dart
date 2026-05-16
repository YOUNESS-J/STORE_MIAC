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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  // Fonction liée à l'authentification (login/signup)
  
  Future<void> _submitAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      if (isLogin) {
        // --- LOGIN ---
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // --- SIGN UP ---
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3e5219)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFfcf9f0),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCWZBfJuv8nyNLwq9qeMFZ2oT7EJTIp_1lgds84Lf2zk6NoaE1myMhpCBTtDEKOl2Na8ZBtgqZoN838leYsic5luqGADk5zHlB20xPlXSz4t2-1OvluAVLKd0jCmSkJq58rj11SrMkToDucnYIsb3CTN2zORsqNmjDgm0q-c8huM9xhO9XNzM1yEiLPx8TOzJ0sVbiIXyx-NphLsowhLsqEUK85RcELecSnYlsuNTOaFGbpvFDSGJPd-ECGbnSM_63L_7vhOpoL9e9g', 
              fit: BoxFit.cover, 
              opacity: const AlwaysStoppedAnimation(0.05)
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, size: 60, color: Color(0xFF3e5219)),
                  const SizedBox(height: 16),
                  Text('Maison du Maroc', style: GoogleFonts.ebGaramond(fontSize: 36, color: const Color(0xFF3e5219))),
                  const Text('PURE ORGANIC LIVING', style: TextStyle(fontSize: 10, letterSpacing: 3, color: Color(0xFF75796b))),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), 
                      borderRadius: BorderRadius.circular(40), 
                      border: Border.all(color: Colors.white)
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _tab('LOGIN', isLogin, () => setState(() => isLogin = true)),
                            _tab('SIGN UP', !isLogin, () => setState(() => isLogin = false)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        //
                        _field('Email Address', Icons.mail_outline, _emailController, false),
                        const SizedBox(height: 20),
                        // 
                        _field('Password', Icons.lock_outline, _passwordController, true),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            // 
                            onPressed: isLoading ? null : _submitAuth, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3e5219), 
                              foregroundColor: Colors.white, 
                              padding: const EdgeInsets.symmetric(vertical: 20), 
                              shape: const StadiumBorder()
                            ),
                            child: isLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(isLogin ? 'LOG IN' : 'CREATE ACCOUNT', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                          ),
                        ),
                      ],
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

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: active ? const Color(0xFF3e5219) : Colors.grey)),
            if (active) Container(height: 2, width: 40, color: const Color(0xFF3e5219), margin: const EdgeInsets.only(top: 4)),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, IconData icon, TextEditingController controller, [bool pass = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF75796b))),
        TextField(
          controller: controller,
          obscureText: pass,
          decoration: InputDecoration(
            suffixIcon: Icon(icon, color: Colors.grey, size: 18),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFebe8df))),
          ),
        ),
      ],
    );
  }
}