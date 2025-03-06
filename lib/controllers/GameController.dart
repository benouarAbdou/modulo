import 'dart:math';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class ModuloGameController extends GetxController {
  final RxInt score = 0.obs;
  final RxInt gems = 0.obs;
  final List<List<RxInt>> grid = List.generate(
    2,
    (_) => List.generate(2, (_) => 0.obs),
  );
  final List<RxInt> availableNumbers = List.generate(3, (_) => 0.obs);

  // Audio players for each sound effect
  late AudioPlayer _correctPlayer;
  late AudioPlayer _purchasePlayer;
  late AudioPlayer _wrongPlayer;

  @override
  void onInit() {
    super.onInit();
    // Initialize audio players
    _correctPlayer = AudioPlayer();
    _purchasePlayer = AudioPlayer();
    _wrongPlayer = AudioPlayer();
    _loadAudioAssets();
    _initializeGame();
  }

  Future<void> _loadAudioAssets() async {
    try {
      await _correctPlayer.setAsset('assets/audio/correct.wav');
      await _purchasePlayer.setAsset('assets/audio/purchase.wav');
      await _wrongPlayer.setAsset('assets/audio/wrong.wav');
    } catch (e) {
      print('Error loading audio assets: $e');
    }
  }

  @override
  void onClose() {
    // Dispose audio players to free resources
    _correctPlayer.dispose();
    _purchasePlayer.dispose();
    _wrongPlayer.dispose();
    super.onClose();
  }

  void _initializeGame() {
    score.value = 0; // Score starts at 0
    gems.value = 0; // Reset gems
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
    // Base range is 1-10, increases by 1 for every 100 points in score
    int baseMax = 10;
    int bonusRange = score.value ~/ 100; // Integer division by 100
    int maxRange = baseMax + bonusRange;
    return Random().nextInt(maxRange) + 1; // Returns 1 to maxRange
  }

  // Helper method to find the maximum number in the grid
  int _getMaxInGrid() {
    int maxVal = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (grid[i][j].value > maxVal) {
          maxVal = grid[i][j].value;
        }
      }
    }
    return maxVal;
  }

  void placeNumber(
    int gridRow,
    int gridCol,
    int number,
    int sourceIndex,
    bool isFromGrid,
  ) async {
    final currentValue = grid[gridRow][gridCol].value;
    print(
      'Placing $number at ($gridRow, $gridCol), current: $currentValue, fromGrid: $isFromGrid',
    );

    if (currentValue == 0) {
      if (!isFromGrid) {
        grid[gridRow][gridCol].value = number;
        availableNumbers[sourceIndex].value = _randomNumber();
        print('Placed $number in empty cell');
        await _playSound(_correctPlayer); // Play correct sound
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
        gems.value++;
        print('Merged grid numbers: ${currentValue + number}');
        await _playSound(_correctPlayer); // Play correct sound
      } else {
        grid[gridRow][gridCol].value = currentValue + number;
        availableNumbers[sourceIndex].value = _randomNumber();
        gems.value++;
        print('Merged with available number: ${currentValue + number}');
        await _playSound(_correctPlayer); // Play correct sound
      }
    } else {
      print('Not divisible, no action taken');
      await _playSound(_wrongPlayer); // Play wrong sound
    }

    // Update score to the maximum number in the grid
    score.value = _getMaxInGrid();

    if (_isGameOver()) {
      print('Game Over');
      Get.snackbar('Game Over', 'Score: $score');
      await _playSound(_wrongPlayer); // Play wrong sound on game over
    }

    // Force UI update
    update();
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

  void rerandomizeNumbers() async {
    if (gems.value > 10) {
      // Deduct 10 gems
      gems.value -= 10;
      // Refresh all three available numbers
      _refreshNumbers();
      print(
        'Rerandomized numbers, deducted 10 gems. Remaining gems: ${gems.value}',
      );
      Get.snackbar('Numbers Rerandomized', 'Cost: 10 gems');
      await _playSound(_purchasePlayer); // Play purchase sound
    } else {
      print('Not enough gems to rerandomize. Current gems: ${gems.value}');
      Get.snackbar(
        'Insufficient Gems',
        'You need more than 10 gems to rerandomize!',
      );
      await _playSound(_wrongPlayer); // Play wrong sound
    }
  }

  // Helper method to play sound and prevent overlap
  Future<void> _playSound(AudioPlayer player) async {
    try {
      // Stop any currently playing sound to prevent overlap
      if (player.playing) {
        await player.stop();
      }
      await player.seek(Duration.zero); // Rewind to start
      await player.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
