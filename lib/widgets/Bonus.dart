import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';

class BonusWidget extends StatelessWidget {
  const BonusWidget({
    super.key,
    required this.icon,
    required this.price,
    required this.onTap,
  });

  final IconData icon;
  final String price;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 58,
            height: 58,
            padding: EdgeInsets.all(MySizes.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
              border: Border.all(color: MyColors.cellColor, width: 2),
            ),
            child: Icon(icon, color: MyColors.cellColor, size: 24),
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
                    price,
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
