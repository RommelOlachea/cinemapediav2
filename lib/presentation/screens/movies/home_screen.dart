import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../views/views.dart';

class HomeScreen extends StatelessWidget {
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});
  static const name = 'home-screen';

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(), //cagegorias view por mientras
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack( //el widget IndexedStack me permite mantener vivo el widget (keep alive., cuando cambio de opcion en el bottom navigation)
          index: pageIndex,
          children: viewRoutes,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigatorBar(currentIndex: pageIndex),
    );
  }
}