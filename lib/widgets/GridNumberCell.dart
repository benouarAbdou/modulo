// grid_number_cell.dart
import 'package:flutter/material.dart';
import 'package:modulo/utils/constants/sizes.dart';

class GridNumberCell extends StatelessWidget {
  final int number;
  final Color color;
  final Color textColor;

  const GridNumberCell({
    super.key,
    required this.number,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
      child: Center(
        child: Text(
          number == 0 ? '' : '$number',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
