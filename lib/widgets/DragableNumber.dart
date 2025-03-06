// draggable_number.dart
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
              color: Colors.white,
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
        color: isFromGrid ? MyColors.cellColor : Colors.white,
        textColor: Colors.black,
      ),
    );
  }
}
