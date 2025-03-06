import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/utils/constants/colors.dart';
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
    Color cellColor = _getColorForNumber(displayNumber, isFromGrid);

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

  Color _getColorForNumber(int number, bool isFromGrid) {
    if (number == 0) {
      // Empty cell
      return isFromGrid ? MyColors.cellColor : Colors.white;
    }

    int divisors = _countDivisors(number);
    if (divisors <= 2) {
      return MyColors.redNumber;
    } else if (divisors <= 3) {
      return MyColors.orangeNumber;
    } else if (divisors <= 4) {
      return MyColors.blueNumber;
    } else if (divisors <= 6) {
      return MyColors.greenNumber;
    } else {
      return MyColors.yellowNumber;
    }
  }

  int _countDivisors(int number) {
    if (number <= 0) return 0;
    int count = 0;
    for (int i = 1; i <= number; i++) {
      if (number % i == 0) {
        count++;
      }
    }
    return count;
  }
}
