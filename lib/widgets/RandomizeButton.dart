import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/controllers/GameController.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';

class RandomizeButton extends StatelessWidget {
  const RandomizeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.find<ModuloGameController>().rerandomizeNumbers();
          },
          child: Container(
            width: 58,
            height: 58,
            padding: EdgeInsets.all(MySizes.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
              border: Border.all(color: MyColors.cellColor, width: 2),
            ),
            child: Icon(Icons.autorenew, color: MyColors.cellColor, size: 24),
          ),
        ),
        // Price tag positioned at top right
        Positioned(
          right: 0,
          top: 0,
          child: Transform.translate(
            offset: Offset(10, -10), // Adjust this to fine-tune position
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MySizes.sm,
                vertical: MySizes.xs,
              ),
              decoration: BoxDecoration(
                color: MyColors.cellColor, // Cell color as requested
                borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.diamonds, // Using diamond icon for gem
                    color: Colors.white,
                    size: 10,
                  ),
                  SizedBox(width: MySizes.xs),
                  Text(
                    '10',
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
}
