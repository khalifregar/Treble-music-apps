import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 50),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(34, 0, 0, 0),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: onTap,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey[600],
              selectedFontSize: 12.sp,
              unselectedFontSize: 12.sp,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled, size: 34.w),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, size: 34.w),
                  label: 'Cari',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined, size: 34.w),
                  label: 'Koleksi Kamu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium_outlined, size: 34.w),
                  label: 'Premium',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
