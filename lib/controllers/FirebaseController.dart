// firebase_controller.dart
import 'dart:math';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modulo/models/User.dart';

class FirebaseController extends GetxController {
  // Observable variables
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxList<UserModel> topUsers = RxList<UserModel>([]);

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    print('FirebaseController: onInit called');
    createAnonymousAccount();
  }

  // Create anonymous account and initialize user data
  Future<void> createAnonymousAccount() async {
    print('FirebaseController: Starting createAnonymousAccount');
    try {
      print('FirebaseController: Attempting anonymous sign-in');
      UserCredential userCredential = await _auth.signInAnonymously();
      String userId = userCredential.user!.uid;
      print(
        'FirebaseController: Successfully signed in anonymously, userId: $userId',
      );

      // Create default name using first 6 characters of ID
      String defaultName = 'guest_${userId.substring(0, 6)}';
      print('FirebaseController: Generated default name: $defaultName');

      // Create user model
      UserModel newUser = UserModel(
        id: userId,
        name: defaultName,
        highScore: 0,
        gems: 0,
      );
      print(
        'FirebaseController: Created new user model: id=${newUser.id}, name=${newUser.name}',
      );

      // Save to Firestore
      print('FirebaseController: Saving user to Firestore');
      await _firestore.collection('users').doc(userId).set(newUser.toMap());
      print('FirebaseController: User data saved to Firestore');

      // Update current user
      currentUser.value = newUser;
      print('FirebaseController: Updated currentUser with new user data');
    } catch (e) {
      print('FirebaseController: Error in createAnonymousAccount: $e');
      Get.snackbar('Error', 'Failed to create anonymous account: $e');
    }
  }

  // Update user high score
  Future<void> updateHighScore(int newScore) async {
    print(
      'FirebaseController: updateHighScore called with newScore: $newScore',
    );
    if (currentUser.value == null) {
      print('FirebaseController: No current user, skipping updateHighScore');
      return;
    }

    try {
      print(
        'FirebaseController: Current highScore: ${currentUser.value!.highScore}',
      );
      // Only update if new score is higher than current
      if (newScore > currentUser.value!.highScore) {
        print('FirebaseController: New score is higher, updating Firestore');
        await _firestore.collection('users').doc(currentUser.value!.id).update({
          'highScore': newScore,
        });
        print(
          'FirebaseController: Firestore updated with new highScore: $newScore',
        );

        currentUser.value = UserModel(
          id: currentUser.value!.id,
          name: currentUser.value!.name,
          highScore: newScore,
          gems: currentUser.value!.gems,
        );
        print('FirebaseController: Updated currentUser with new highScore');
      } else {
        print(
          'FirebaseController: New score not higher than current, no update needed',
        );
      }
    } catch (e) {
      print('FirebaseController: Error in updateHighScore: $e');
      Get.snackbar('Error', 'Failed to update high score: $e');
    }
  }

  // Retrieve current user's score
  Future<int> getUserScore() async {
    print('FirebaseController: getUserScore called');
    if (currentUser.value == null) {
      print('FirebaseController: No current user, returning 0');
      return 0;
    }

    try {
      print(
        'FirebaseController: Fetching user score from Firestore for userId: ${currentUser.value!.id}',
      );
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser.value!.id).get();

      if (doc.exists) {
        int score = doc['highScore'] ?? 0;
        print('FirebaseController: Retrieved score from Firestore: $score');
        return score;
      }
      print('FirebaseController: Document does not exist, returning 0');
      return 0;
    } catch (e) {
      print('FirebaseController: Error in getUserScore: $e');
      Get.snackbar('Error', 'Failed to get user score: $e');
      return 0;
    }
  }

  // Retrieve top 50 users by high score
  Future<void> getTopUsers() async {
    print('FirebaseController: getTopUsers called');
    try {
      print('FirebaseController: Querying Firestore for top 50 users');
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .orderBy('highScore', descending: true)
              .limit(50)
              .get();
      print(
        'FirebaseController: Retrieved ${querySnapshot.docs.length} users from Firestore',
      );

      topUsers.value =
          querySnapshot.docs
              .map(
                (doc) => UserModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();
      print(
        'FirebaseController: Updated topUsers list with ${topUsers.length} entries',
      );
      // Optional: Print top 5 for debugging
      for (int i = 0; i < min(topUsers.length, 5); i++) {
        print(
          'FirebaseController: Top user ${i + 1}: ${topUsers[i].name}, Score: ${topUsers[i].highScore}',
        );
      }
    } catch (e) {
      print('FirebaseController: Error in getTopUsers: $e');
      Get.snackbar('Error', 'Failed to get top users: $e');
    }
  }
}
