import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';

class GameOver extends StatelessWidget {
  const GameOver({
    super.key,
    required this.score,
    required this.highScore,
    required this.restartGame,
  });

  final int score;
  final int highScore;
  final Function restartGame;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent background
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
            boxShadow: [
              BoxShadow(
                color: MyColors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: MySizes.spaceBtwItems),
              Text(
                'High Score: $highScore',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: MySizes.spaceBtwItems / 2),
              Text(
                'Score: $score',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: MySizes.spaceBtwItems),
              GestureDetector(
                onTap: () {
                  restartGame();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MySizes.defaultSpace / 2,
                    horizontal: MySizes.defaultSpace * 2,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.cellColor,
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
                  ),
                  child: Text(
                    'Restart',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: MyColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
