import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';
import 'package:modulo/widgets/GridNumberCell.dart';
import 'package:modulo/functions/Functions.dart'; // For getColorForNumber

class AddOne extends StatefulWidget {
  const AddOne({super.key});

  @override
  _AddOneState createState() => _AddOneState();
}

class _AddOneState extends State<AddOne> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final ModuloGameController controller = Get.find<ModuloGameController>();

    return Stack(
      children: [
        // Show either the button or the draggable cell based on state
        _isDragging
            ? _buildDraggableCell(controller)
            : _buildButton(() {
              if (controller.gems.value >= 20) {
                setState(() {
                  _isDragging = true;
                });
                controller.saveData(); // Save updated gems
                controller.playSound(controller.purchasePlayer);
                controller.gems.value -= 20;
              } else {
                Get.snackbar(
                  'Insufficient Gems',
                  'You need 20 gems to add a 1!',
                );
                controller.playSound(controller.wrongPlayer);
              }
            }),
        // Price tag
        _isDragging
            ? SizedBox.shrink()
            : Positioned(
              right: 0,
              top: 0,
              child: Transform.translate(
                offset: Offset(10, -10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MySizes.sm,
                    vertical: MySizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.cellColor,
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.diamonds, color: Colors.white, size: 10),
                      SizedBox(width: MySizes.xs),
                      Text(
                        "20", // Cost of 20 gems, adjust as needed
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
          border: Border.all(color: MyColors.cellColor, width: 2),
        ),
        child: Center(
          child: Text(
            '+1', // Display "+1" instead of just "1"
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MyColors.cellColor, // Match border color
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableCell(ModuloGameController controller) {
    return Draggable<String>(
      data: '1:pool:-1', // Special index -1 for AddOne
      feedback: SizedBox(
        width: 60,
        height: 60,
        child: Material(
          color: Colors.transparent,
          child: GridNumberCell(
            number: 1,
            color: Colors.white, // Feedback color
            textColor: Colors.black,
          ),
        ),
      ),

      childWhenDragging: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
          color: Colors.grey[300],
        ),
      ),
      child: SizedBox(
        width: 60,
        height: 60,
        child: GridNumberCell(
          number: 1, // Show "1" when draggable
          color: getColorForNumber(1, false),
          textColor: Colors.white,
        ),
      ),
      onDragCompleted: () {
        // Reset to button state after drag completes
        controller.isGameOver();
        setState(() {
          _isDragging = false;
        });
        controller.playSound(controller.correctPlayer);
      },
    );
  }
}
