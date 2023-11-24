import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(
      movieRepositoryProvider); // cargamos el provider del repositorio implementado

  return SearchedMoviesNotifier(
      searchMovies: movieRepository.searchMovie,
      ref:
          ref); //pasamos la referencia a la funcion para que la ejecute el provider del repositorio
});

typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallBack searchMovies;
  final Ref
      ref; //parametro que nos permite tener el ref, para poder tener acceso a otros provider dentro del controlador del notifier, SearchedMoviesNotifier

  SearchedMoviesNotifier({required this.searchMovies, required this.ref})
      : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query); //ejecutamos la busqueda de peliculas en el provider del repositorio
    ref.read(searchQueryProvider.notifier).update((state) =>
        query); //actualizamos el estado del provicer que mantiene el query de la ultima busqueda

    state = movies;
    return movies;
  }
}
