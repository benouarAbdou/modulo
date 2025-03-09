// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo/controllers/AdsController.dart';
import 'package:modulo/pages/GameScreen.dart';
import 'package:modulo/theme/theme.dart';

void main() {
  runApp(const ModuloGameApp());
}

class ModuloGameApp extends StatelessWidget {
  const ModuloGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdController());

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
