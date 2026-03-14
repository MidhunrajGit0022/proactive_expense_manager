import 'package:dummyexpense/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final int itemCount;

  const ShimmerLoader({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardGrey,
      highlightColor: AppColors.lightCardGrey,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.cardGrey,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
