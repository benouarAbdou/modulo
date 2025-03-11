import 'package:flutter/material.dart';
import 'package:modulo/utils/constants/sizes.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MySizes.sm,
          horizontal: MySizes.defaultSpace,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: MySizes.lg,
          vertical: MySizes.md,
        ),
        decoration: BoxDecoration(
          // Flip colors: yellow if current user, white otherwise
          color: Colors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),

          // Add border: white for current user if rank <= 3, yellow otherwise
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 10),
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
