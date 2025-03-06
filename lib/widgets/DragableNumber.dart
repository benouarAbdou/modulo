import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/functions/Functions.dart';
import 'package:modulo/utils/constants/sizes.dart';
import 'package:modulo/widgets/GridNumberCell.dart';

class DraggableNumber extends StatelessWidget {
  final int? index;
  final int? number;
  final int? row;
  final int? col;
  final bool isFromGrid;

  const DraggableNumber({
    super.key,
    this.index,
    this.number,
    this.row,
    this.col,
    this.isFromGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final ModuloGameController controller = Get.find<ModuloGameController>();

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
      child:
          isFromGrid
              ? Obx(() {
                final displayNumber = controller.grid[row!][col!].value;
                return _buildDraggable(
                  displayNumber,
                  isFromGrid,
                  row,
                  col,
                  index,
                );
              })
              : Obx(() {
                final displayNumber = controller.availableNumbers[index!].value;
                return _buildDraggable(
                  displayNumber,
                  isFromGrid,
                  row,
                  col,
                  index,
                );
              }),
    );
  }

  Widget _buildDraggable(
    int displayNumber,
    bool isFromGrid,
    int? row,
    int? col,
    int? index,
  ) {
    // Determine the color based on the number of divisors
    Color cellColor = getColorForNumber(displayNumber, isFromGrid);

    // If the cell is empty and it's from the grid, return a non-draggable widget
    if (isFromGrid && displayNumber == 0) {
      return GridNumberCell(
        number: displayNumber,
        color: cellColor,
        textColor: Colors.black, // Text color for empty cells
      );
    }

    // Otherwise, return a draggable widget
    return Draggable<String>(
      data:
          isFromGrid
              ? '$displayNumber:grid:${row! * 2 + col!}'
              : '$displayNumber:pool:$index',
      feedback: ClipRRect(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
        child: SizedBox(
          width: 60,
          height: 60,
          child: Material(
            color: Colors.transparent,
            child: GridNumberCell(
              number: displayNumber,
              color: Colors.white, // Feedback can remain white
              textColor: Colors.black,
            ),
          ),
        ),
      ),
      childWhenDragging: GridNumberCell(
        number: isFromGrid ? 0 : displayNumber,
        color: Colors.grey[300]!,
        textColor: Colors.black,
      ),
      child: GridNumberCell(
        number: displayNumber,
        color: cellColor,
        textColor:
            displayNumber == 0
                ? Colors.black
                : Colors.white, // White text for colored cells, black for empty
      ),
    );
  }
}
