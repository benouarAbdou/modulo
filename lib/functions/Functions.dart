import 'package:flutter/material.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/widgets/DragableNumber.dart';

Color getColorForNumber(int number, bool isFromGrid) {
  if (number == 0) {
    // Empty cell
    return isFromGrid ? MyColors.cellColor : Colors.white;
  }

  int divisors = countDivisors(number);
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

int countDivisors(int number) {
  if (number <= 0) return 0;
  int count = 0;
  for (int i = 1; i <= number; i++) {
    if (number % i == 0) {
      count++;
    }
  }
  return count;
}

Widget buildAvailableNumbers() => SizedBox(
  width: double.infinity,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(3, (index) => DraggableNumber(index: index)),
  ),
);
