import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigatorBar extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigatorBar({super.key, required this.currentIndex});

  //metodo para navegar a la ruta seleccionada
  void onItemTapped(BuildContext context, int index) {
    //context.go('');
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
      default:
        context.go('/home/0');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex:
            currentIndex, //este es el parametro recibido por el widget
        onTap: (value) => onItemTapped(context,
            value), //ejecutamos el metodo onItemTapped cuando seleccionamos una opcion, el value trae la opcion
        elevation:
            0, //con elevation en 0, no se marca la linea divisoria del bottom navigation bar
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.label_outline), label: 'Categorias'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
        ]);
  }
}
