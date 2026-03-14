import 'package:dummyexpense/features/profile/presentation/pages/profile_screen.dart';
import 'package:dummyexpense/features/transaction/presentation/pages/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/colors.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const TransactionsScreen(),
    const ProfileScreen(),
  ];

  final List<String> _navIcons = [
    'assets/svg/home.svg',
    'assets/svg/transaction.svg',
    'assets/svg/profile.svg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildFloatingBottomNav(),
    );
  }

  Widget _buildFloatingBottomNav() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            color: AppColors.cardGrey,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                _navIcons.length,
                (index) => _buildNavItem(index, _navIcons[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String svgPath) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? AppColors.white : AppColors.textGrey,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
