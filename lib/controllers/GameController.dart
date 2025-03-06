// modulo_game_controller.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuloGameController extends GetxController {
  final RxInt score = 0.obs;
  final List<List<RxInt>> grid = List.generate(
    2,
    (_) => List.generate(2, (_) => 0.obs),
  );
  final List<RxInt> availableNumbers = List.generate(3, (_) => 0.obs);

  @override
  void onInit() {
    super.onInit();
    _initializeGame();
  }

  void _initializeGame() {
    score.value = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        grid[i][j].value = 0;
      }
    }
    _refreshNumbers();
  }

  void _refreshNumbers() {
    for (int i = 0; i < availableNumbers.length; i++) {
      availableNumbers[i].value = _randomNumber();
    }
  }

  int _randomNumber() {
    return Random().nextInt(10) + 1; // Returns 1-10
  }

  void placeNumber(
    int gridRow,
    int gridCol,
    int number,
    int sourceIndex,
    bool isFromGrid,
  ) {
    final currentValue = grid[gridRow][gridCol].value;
    print(
      'Placing $number at ($gridRow, $gridCol), current: $currentValue, fromGrid: $isFromGrid',
    );

    if (currentValue == 0) {
      if (!isFromGrid) {
        grid[gridRow][gridCol].value = number;
        availableNumbers[sourceIndex].value = _randomNumber();
        print('Placed $number in empty cell');
      }
    } else if (currentValue % number == 0 || number % currentValue == 0) {
      print(
        'Divisible: $currentValue % $number = ${currentValue % number}, $number % $currentValue = ${number % currentValue}',
      );
      if (isFromGrid) {
        final sourceRow = sourceIndex ~/ 2;
        final sourceCol = sourceIndex % 2;
        if (sourceRow == gridRow && sourceCol == gridCol) return;

        grid[gridRow][gridCol].value = currentValue + number;
        grid[sourceRow][sourceCol].value = 0;
        score.value += currentValue + number;
        Get.snackbar(
          'Numbers Added',
          '$currentValue + $number = ${currentValue + number}',
        );
        print('Merged grid numbers: ${currentValue + number}');
      } else {
        grid[gridRow][gridCol].value = currentValue + number;
        availableNumbers[sourceIndex].value = _randomNumber();
        score.value += currentValue + number;
        Get.snackbar(
          'Numbers Added',
          '$currentValue + $number = ${currentValue + number}',
        );
        print('Merged with available number: ${currentValue + number}');
      }
    } else {
      print('Not divisible, no action taken');
    }

    if (_isGameOver()) {
      print('Game Over');
      Get.snackbar('Game Over', 'Score: $score');
    }
  }

  bool _isGameOver() {
    // Check if grid is full
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (grid[i][j].value == 0) return false; // Empty cell, game not over
      }
    }

    // Check grid merges (adjacent cells)
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        final current = grid[i][j].value;
        // Check right
        if (j < 1 &&
            (current % grid[i][j + 1].value == 0 ||
                grid[i][j + 1].value % current == 0)) {
          return false;
        }
        // Check bottom
        if (i < 1 &&
            (current % grid[i + 1][j].value == 0 ||
                grid[i + 1][j].value % current == 0)) {
          return false;
        }
      }
    }

    // Check available numbers against all grid cells
    for (int i = 0; i < availableNumbers.length; i++) {
      final avail = availableNumbers[i].value;
      for (int r = 0; r < 2; r++) {
        for (int c = 0; c < 2; c++) {
          final gridVal = grid[r][c].value;
          if (avail % gridVal == 0 || gridVal % avail == 0) {
            return false;
          }
        }
      }
    }

    return true; // No moves possible
  }
}
