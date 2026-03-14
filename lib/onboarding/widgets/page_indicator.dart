import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: index == count - 1 ? 0 : 8),
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.white
                  : AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
