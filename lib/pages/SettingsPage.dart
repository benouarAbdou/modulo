import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/pages/RankingPage.dart';
import 'package:modulo/utils/constants/sizes.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/widgets/EditDialogue.dart';
import 'package:modulo/widgets/ProfileTile.dart';
import 'package:modulo/controllers/FirebaseController.dart'; // Add this import

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.name, required this.highScore});

  final String name;
  final int highScore;

  // Method to show edit name dialog

  @override
  Widget build(BuildContext context) {
    final FirebaseController firebaseController =
        Get.find<FirebaseController>();

    return Scaffold(
      backgroundColor: MyColors.bg,
      // AppBar
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: MyColors.bg,
      ),

      // Body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MySizes.defaultSpace),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Circle
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Iconsax.user,
                    size: 40,
                    color: MyColors.cellColor,
                  ),
                ),

                // Name and Highscore Column
                const SizedBox(width: MySizes.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: MySizes.sm),
                      Text(
                        'High Score: $highScore',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Edit Icon
                IconButton(
                  icon: const Icon(Iconsax.edit_copy, color: MyColors.black),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => EditNameDialog(
                            initialName: name,
                            onSave: (newName) async {
                              await firebaseController.updateUserName(newName);
                              Navigator.pop(context);
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Spacing
          const SizedBox(height: MySizes.spaceBtwSections),

          // Ranking Button
          ProfileTile(
            title: 'Rankings',
            icon: Iconsax.ranking_1,
            onTap: () => Get.to(() => RankingPage()),
          ),

          // Store Button
          ProfileTile(title: 'Store', icon: Iconsax.shop, onTap: () {}),

          ProfileTile(
            title: 'How to play',
            icon: Iconsax.info_circle,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
