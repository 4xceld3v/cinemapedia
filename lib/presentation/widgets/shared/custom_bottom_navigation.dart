import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CustomBottomNavigation extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNavigation({
    super.key, required this.currentIndex
  });

  void onItemTapped(BuildContext context, int value) {
    switch (value) {
      case 0:
       context.go('/home/$value');
        break;
      case 1:
        context.go('/home/$value');
        break;
      case 2:
        context.go('/home/$value');
        break;
      default:
        context.go('/home/0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap:(value) => onItemTapped(context, value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outlined),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}