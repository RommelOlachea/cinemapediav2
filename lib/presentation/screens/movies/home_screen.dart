import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.childView});

  final Widget childView;
  static const name = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: CustomBottomNavigatorBar(),
    );
  }
}

//cuando nosotros pasamos una vista al home screen., el bottonNavigation no se recrea cuando cambiamos la vista., sigue siendo el mismo