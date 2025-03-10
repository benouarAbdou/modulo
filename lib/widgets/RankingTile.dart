import 'package:flutter/material.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';

class RankingTile extends StatelessWidget {
  const RankingTile({
    super.key,
    required this.rank,
    required this.score,
    required this.name,
    required this.id,
    required this.currentUserId, // Add currentUserId as a required parameter
  });

  final int rank;
  final int score;
  final String name;
  final String id;
  final String currentUserId; // New parameter for the current user's ID

  @override
  Widget build(BuildContext context) {
    // Determine if this tile represents the current user
    final bool isCurrentUser = id == currentUserId;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MySizes.sm,
        horizontal: MySizes.defaultSpace,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: MySizes.lg,
        vertical: MySizes.sm,
      ),
      decoration: BoxDecoration(
        // Flip colors: yellow if current user, white otherwise
        color: isCurrentUser ? MyColors.cellColor : Colors.white,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
        // Add border: white for current user if rank <= 3, yellow otherwise
        border:
            rank <= 3
                ? Border.all(color: MyColors.cellColor, width: 2.0)
                : null, // No border for ranks > 3
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                rank == -1 ? ' ' : '$rank',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isCurrentUser ? Colors.white : MyColors.black,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // Flip icon background: white if current user, yellow otherwise
                  color: isCurrentUser ? Colors.white : MyColors.cellColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: isCurrentUser ? MyColors.cellColor : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isCurrentUser ? Colors.white : MyColors.black,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Text(
            '$score',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isCurrentUser ? Colors.white : MyColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
