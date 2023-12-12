import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

//init
//solo las primeras 10 movies

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

//nota: en ConsumerState esta implicito el ref ya de manera global
class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    //cargamos las peliculas al inicializar
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    //nota: ponemos el favoritesMoviesProvider con .notifier para poder accesar a los metodos
    //si no lo ponemos con .notifier, nos saldrian los metodos para manejar el state, es decir la data que fluye
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //obtenemos la data del provider, con watch para que reaccione a los cambios y se redibuje el widget, cuando carguemos con loadNextPage
    final favoritesMovies = ref
        .watch(favoriteMoviesProvider)
        .values
        .toList(); //con esto solo sacamos los valores del mapa, y lo convertimos en una lista

    if (favoritesMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline_sharp,
              size: 60,
              color: colors.primary,
            ),
            Text(
              'Ohhh no!!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              'No tienes peliculas favoritas',
              style: TextStyle(fontSize: 20, color: Colors.black45),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.tonal(
                onPressed: () => context.go('/home/0'), child: const Text('Empieza a buscar')),
          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(movies: favoritesMovies, loadNextPage: loadNextPage),
    );
  }
}


//nota, el setstate en flutter lo unico que indica es que hubo un cambio en el estado y que el widget
//necesita redibujarse

