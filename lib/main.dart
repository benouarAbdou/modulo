// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo/controllers/AdsController.dart';
import 'package:modulo/controllers/FirebaseController.dart';
import 'package:modulo/controllers/GameController.dart'
    show ModuloGameController;
import 'package:modulo/pages/GameScreen.dart';
import 'package:modulo/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ModuloGameApp());
}

class ModuloGameApp extends StatelessWidget {
  const ModuloGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdController());
    Get.put(FirebaseController());
    Get.put(ModuloGameController());

    return GetMaterialApp(
      title: 'Modulo Game',
      themeMode: ThemeMode.system,
      theme: RecipesTheme.lightTheme,
      darkTheme: RecipesTheme.darkTheme,
      home: ModuloGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
