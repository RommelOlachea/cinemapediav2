import 'package:flutter/material.dart';


class CustomBottomNavigatorBar extends StatelessWidget {
  const CustomBottomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0, //con elevation en 0, no se marca la linea divisoria del bottom navigation bar
      items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_max),
              label: 'Inicio'
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.label_outline),
              label: 'Categorias'
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Favoritos'
              ),
        ]
      );
  }
}