import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'screens/main_navigation.dart';
import 'firebase_options.dart'; 
import 'providers/cart_provider.dart'; 
import 'providers/favorite_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: const MaisonDuMarocApp(),
    ),
  );
}

class MaisonDuMarocApp extends StatefulWidget {
  const MaisonDuMarocApp({super.key});

  @override
  _MaisonDuMarocAppState createState() => _MaisonDuMarocAppState();
}

class _MaisonDuMarocAppState extends State<MaisonDuMarocApp> {
  @override
  void initState() {
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIAC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3e5219),
          primary: const Color(0xFF3e5219),
          secondary: const Color(0xFF94492c),
          surface: const Color(0xFFfcf9f0),
        ),
        textTheme: GoogleFonts.dmSansTextTheme(),
      ),
      initialRoute: '/main',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/main': (context) => const MainNavigationShell(),
      },
    );
  }
}