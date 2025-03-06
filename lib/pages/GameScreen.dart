// game_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';
import 'package:modulo/widgets/DragableNumber.dart';

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
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: MySizes.spaceBtwSections),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Score',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Obx(
                    () => Text(
                      '${controller.score}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MySizes.spaceBtwSections),
              Expanded(child: _buildGrid()),
              SizedBox(height: MySizes.spaceBtwSections),
              _buildAvailableNumbers(),
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
        onAcceptWithDetails: (details) => _handleDrop(details, row, col),
      );
    },
  );

  Widget _buildAvailableNumbers() => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: MySizes.defaultSpace),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) => DraggableNumber(index: index)),
    ),
  );

  void _handleDrop(DragTargetDetails<String> details, int row, int col) {
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
  }
}
