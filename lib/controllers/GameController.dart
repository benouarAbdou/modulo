import 'dart:math';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class ModuloGameController extends GetxController {
  final RxInt score = 0.obs;
  final RxInt gems = 0.obs;
  final RxInt highScore = 0.obs; // Add high score as observable
  final List<List<RxInt>> grid = List.generate(
    2,
    (_) => List.generate(2, (_) => 0.obs),
  );
  final List<RxInt> availableNumbers = List.generate(3, (_) => 0.obs);

  late AudioPlayer correctPlayer;
  late AudioPlayer purchasePlayer;
  late AudioPlayer wrongPlayer;

  @override
  void onInit() async {
    // Make onInit async
    super.onInit();
    correctPlayer = AudioPlayer();
    purchasePlayer = AudioPlayer();
    wrongPlayer = AudioPlayer();
    await _loadAudioAssets();
    await _loadSavedData(); // Load saved data before initializing
    _initializeGame();
  }

  Future<void> _loadAudioAssets() async {
    try {
      await correctPlayer.setAsset('assets/audio/correct.wav');
      await purchasePlayer.setAsset('assets/audio/purchase.wav');
      await wrongPlayer.setAsset('assets/audio/wrong.wav');
    } catch (e) {
      print('Error loading audio assets: $e');
    }
  }

  // Load saved gems and high score from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    gems.value =
        prefs.getInt('gems') ?? 0; // Load gems, default to 0 if not set
    highScore.value = prefs.getInt('highScore') ?? 0; // Load high score
  }

  // Save gems and high score to SharedPreferences
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gems', gems.value);
    await prefs.setInt('highScore', highScore.value);
  }

  @override
  void onClose() {
    correctPlayer.dispose();
    purchasePlayer.dispose();
    wrongPlayer.dispose();
    super.onClose();
  }

  void _initializeGame() {
    score.value = 0;
    // gems.value remains loaded from SharedPreferences
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
    int baseMax = 10;
    int bonusRange = score.value ~/ 100;
    int maxRange = baseMax + bonusRange;
    return Random().nextInt(maxRange) + 1;
  }

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
        await playSound(correctPlayer);
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
        await playSound(correctPlayer);
      } else {
        grid[gridRow][gridCol].value = currentValue + number;
        availableNumbers[sourceIndex].value = _randomNumber();
        gems.value++;
        print('Merged with available number: ${currentValue + number}');
        await playSound(correctPlayer);
      }
    } else {
      print('Not divisible, no action taken');
      await playSound(wrongPlayer);
    }

    // Update score and check for new high score
    score.value = _getMaxInGrid();
    if (score.value > highScore.value) {
      highScore.value = score.value;
    }
    await saveData(); // Save gems and high score after each move

    if (_isGameOver()) {
      print('Game Over');
      Get.snackbar('Game Over', 'Score: $score, High Score: $highScore');
      await playSound(wrongPlayer);
    }

    update();
  }

  bool _isGameOver() {
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (grid[i][j].value == 0) return false;
      }
    }

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        final current = grid[i][j].value;
        if (j < 1 &&
            (current % grid[i][j + 1].value == 0 ||
                grid[i][j + 1].value % current == 0)) {
          return false;
        }
        if (i < 1 &&
            (current % grid[i + 1][j].value == 0 ||
                grid[i + 1][j].value % current == 0)) {
          return false;
        }
      }
    }

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

    return true;
  }

  void rerandomizeNumbers() async {
    if (gems.value > 10) {
      gems.value -= 10;
      _refreshNumbers();
      print(
        'Rerandomized numbers, deducted 10 gems. Remaining gems: ${gems.value}',
      );
      Get.snackbar('Numbers Rerandomized', 'Cost: 10 gems');
      await playSound(purchasePlayer);
      await saveData(); // Save updated gems
    } else {
      print('Not enough gems to rerandomize. Current gems: ${gems.value}');
      Get.snackbar(
        'Insufficient Gems',
        'You need more than 10 gems to rerandomize!',
      );
      await playSound(wrongPlayer);
    }
  }

  Future<void> playSound(AudioPlayer player) async {
    try {
      if (player.playing) {
        await player.stop();
      }
      await player.seek(Duration.zero);
      await player.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
