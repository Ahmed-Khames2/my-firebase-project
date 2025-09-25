// ignore_for_file: file_names

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/features/favorites/presentation/pages/favorit_page.dart';
import 'package:my_firebase_app/features/products/presentation/products_page.dart';

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({super.key});

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  int currentIndex = 0;

  final List<Widget> _pages = const [
    ProductsPage(),
    FavoritesPage(),
    // CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[currentIndex]),

      /// ---------------- ConvexAppBar ----------------
      // bottomNavigationBar: ConvexAppBar(
      //   style: TabStyle.react,
      //   backgroundColor: AppColors.bg,
      //   activeColor: AppColors.primary,
      //   color: AppColors.greyDark,
      //   elevation: 8,
      //   items: const [
      //     TabItem(
      //       icon: Icons.home_outlined,
      //       activeIcon: Icons.home,
      //       title: "Home",
      //     ),
      //     TabItem(
      //       icon: Icons.favorite_border,
      //       activeIcon: Icons.favorite,
      //       title: "Favorites",
      //     ),
      //     TabItem(
      //       icon: Icons.shopping_cart_outlined,
      //       activeIcon: Icons.shopping_cart,
      //       title: "Cart",
      //     ),
      //   ],
      //   initialActiveIndex: currentIndex,
      //   onTap: (index) => setState(() => currentIndex = index),
      // ),

      // / ---------------- CurvedNavigationBar ----------------
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 60,
        backgroundColor: AppColors.primary,
        color: AppColors.bg,
        buttonBackgroundColor: AppColors.bg,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(Icons.home, size: 30, color: AppColors.primary),
          Icon(Icons.favorite, size: 30, color: AppColors.primary),
          Icon(Icons.shopping_cart, size: 30, color: AppColors.primary),
        ],
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
