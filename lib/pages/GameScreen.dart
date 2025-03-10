// game_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/controllers/AdsController.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/functions/Functions.dart';
import 'package:modulo/pages/RankingPage.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';
import 'package:modulo/widgets/AdOne.dart';
import 'package:modulo/widgets/DragableNumber.dart';
import 'package:modulo/widgets/Bonus.dart';
import 'package:modulo/widgets/GameOver.dart';

class ModuloGameScreen extends StatelessWidget {
  final ModuloGameController controller = Get.put(ModuloGameController());
  final adController = Get.find<AdController>();

  ModuloGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bg,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MySizes.defaultSpace * 2,
                vertical: MySizes.defaultSpace,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.diamonds,
                                color: MyColors.black,
                                size: 20,
                              ),
                              SizedBox(width: MySizes.spaceBtwItems / 2),
                              Obx(
                                () => Text(
                                  "${controller.gems}",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.star_1,
                                color: MyColors.black,
                                size: 20,
                              ),
                              SizedBox(width: MySizes.spaceBtwItems / 2),
                              Obx(
                                () => Text(
                                  "${controller.highScore}",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => RankingPage()),
                        child: Icon(
                          Iconsax.ranking_1,
                          color: MyColors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MySizes.spaceBtwSections * 1.5),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Score',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium!.copyWith(fontSize: 24),
                      ),
                      Obx(
                        () => Text(
                          '${controller.score}',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge!.copyWith(fontSize: 40),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MySizes.spaceBtwSections),
                  Expanded(child: _buildGrid()),
                  SizedBox(height: MySizes.spaceBtwSections),
                  buildAvailableNumbers(),
                  SizedBox(height: MySizes.spaceBtwSections / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BonusWidget(
                        icon: Icons.autorenew,
                        price: "10",
                        onTap: () {
                          Get.find<ModuloGameController>().rerandomizeNumbers(
                            context,
                          );
                        },
                      ),
                      AddOne(),
                      BonusWidget(
                        icon: Iconsax.video,
                        price: "+ 100",
                        onTap: () {
                          Get.find<AdController>().showRewardedAd(
                            context: context,
                            onRewardEarned: () {
                              Get.find<ModuloGameController>().gems.value +=
                                  100;
                              Get.find<ModuloGameController>().saveData();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Game Over Overlay
          Obx(() {
            if (controller.isGameOver.value) {
              return GameOver(
                score: controller.score.value,
                highScore: controller.highScore.value,
                restartGame: () {
                  controller.restartGame();
                },
              );
            } else {
              return const SizedBox(height: MySizes.spaceBtwSections);
            }
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (adController.isBannerAdLoaded.value &&
            adController.bannerAd != null) {
          return SizedBox(
            height: adController.bannerAd!.size.height.toDouble(),
            child: AdWidget(key: UniqueKey(), ad: adController.bannerAd!),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildGrid() => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16.0,
    ),
    itemCount: 4,
    itemBuilder: (context, index) {
      final row = index ~/ 2;
      final col = index % 2;
      return DragTarget<String>(
        builder:
            (context, _, __) => Obx(
              () => DraggableNumber(
                number: controller.grid[row][col].value,
                row: row,
                col: col,
                isFromGrid: true,
              ),
            ),
        onWillAcceptWithDetails: (details) => true,
        onAcceptWithDetails: (details) => handleDrop(details, row, col),
      );
    },
  );

  void handleDrop(DragTargetDetails<String> details, int row, int col) {
    final parts = details.data.split(':');
    final number = int.parse(parts[0]);
    final isFromGrid = parts[1] == 'grid';
    final sourceIndex = int.parse(parts[2]);

    final currentValue = controller.grid[row][col].value;

    if (currentValue == 0) {
      // Only allow placement from the bottom row (not grid)
      if (!isFromGrid) {
        controller.placeNumber(row, col, number, sourceIndex, isFromGrid);
      }
    } else {
      // Handle merging logic (only from grid or bottom row when divisible)
      controller.placeNumber(row, col, number, sourceIndex, isFromGrid);
    }

    // Force UI update
    controller.update();
  }
}
