// game_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/functions/Functions.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';
import 'package:modulo/widgets/AdOne.dart';
import 'package:modulo/widgets/DragableNumber.dart';
import 'package:modulo/widgets/Bonus.dart';

class ModuloGameScreen extends StatelessWidget {
  final ModuloGameController controller = Get.put(ModuloGameController());

  ModuloGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MySizes.defaultSpace * 2,
            vertical: MySizes.defaultSpace,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.diamonds, color: MyColors.black, size: 20),
                      SizedBox(width: MySizes.spaceBtwItems / 2),
                      Obx(
                        () => Text(
                          "${controller.gems}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                  Icon(Iconsax.setting, color: MyColors.black, size: 20),
                ],
              ),
              SizedBox(height: MySizes.spaceBtwSections * 2),
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
                      Get.find<ModuloGameController>().rerandomizeNumbers();
                    },
                  ),
                  AddOne(),
                  BonusWidget(
                    icon: Iconsax.video,
                    price: "+ 100",
                    onTap: () {
                      Get.find<ModuloGameController>().rerandomizeNumbers();
                    },
                  ),
                ],
              ),
              SizedBox(height: MySizes.spaceBtwSections),
            ],
          ),
        ),
      ),
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
