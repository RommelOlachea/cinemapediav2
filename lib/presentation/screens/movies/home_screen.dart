import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const name = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _HomeView(),
      ),
    );
  }
}

//cambiamos el statefullwidget por ConsumerStateWidget
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView({
    super.key,
  });

  //Cambiamos el state, por la clase _HomeViewState propiamente dicha
  @override
  _HomeViewState createState() => _HomeViewState();
}

//Cambiamos el state por ConsumerState
class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //se utiliza el read porque estamos dentro de un metodo
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //aqui si utilizamos el watch porque vamos a estar al pendiente
    //del listado de las peliculas.
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

    if (nowPlayingMovies.length == 0) return CircularProgressIndicator();

    return ListView.builder(
      itemCount: nowPlayingMovies.length,
      itemBuilder: (context, index) {
        final movie = nowPlayingMovies[index];
        return ListTile(
          title: Text(movie.title),

        );
      },
    );
  }
}
