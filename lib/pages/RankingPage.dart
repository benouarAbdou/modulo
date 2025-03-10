import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo/controllers/FirebaseController.dart';
import 'package:modulo/models/User.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/widgets/RankingTile.dart';

class RankingPage extends StatelessWidget {
  RankingPage({super.key});

  final FirebaseController firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    firebaseController.getTopUsers(); // Fetch top users

    return Scaffold(
      backgroundColor: MyColors.bg,
      appBar: AppBar(
        title: const Text('Top 50 Players'),
        centerTitle: true,
        backgroundColor: MyColors.bg,
      ),
      body: Obx(() {
        if (firebaseController.topUsers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Check if current user is in the top 50
          final currentUserId = firebaseController.currentUser.value?.id ?? '';
          final isCurrentUserInTop50 = firebaseController.topUsers.any(
            (user) => user.id == currentUserId,
          );

          return Column(
            children: [
              // Top 50 List
              Expanded(
                child: ListView.builder(
                  itemCount: firebaseController.topUsers.length,
                  itemBuilder: (context, index) {
                    UserModel user = firebaseController.topUsers[index];
                    return RankingTile(
                      currentUserId: currentUserId,
                      id: user.id,
                      rank: index + 1,
                      name: user.name,
                      score: user.highScore,
                    );
                  },
                ),
              ),
              // Show current user's tile if not in top 50
              if (!isCurrentUserInTop50 &&
                  firebaseController.currentUser.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), // Optional spacing
                  child: RankingTile(
                    currentUserId: currentUserId,
                    id: firebaseController.currentUser.value!.id,
                    rank: -1, // Special rank for user not in top 50
                    name: firebaseController.currentUser.value!.name,
                    score: firebaseController.currentUser.value!.highScore,
                  ),
                ),
            ],
          );
        }
      }),
    );
  }
}
