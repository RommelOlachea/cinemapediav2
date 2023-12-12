import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/loca_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

/*
  La data lucira de esta manera:

  {
    1234: Movie,
    1543: Movie,
    8766: Movie,
  }

*/

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies =
        await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;

    //ejecutamos un ciclo for para llenar el mapaTemporal de las peliculas
    final tempMovieMap = <int, Movie>{};
    for (final movie in movies) {
      tempMovieMap[movie.id] = movie;
    }

    state = {
      ...state,
      ...tempMovieMap
    }; //cambiamos la data., para indicar que tenemos un cambio en el provider esto es para los widgets

    return movies; //regresamos la lista de peliculas
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] !=
        null; //verificamos que la pelicula exista en el estado

    if (isMovieInFavorites) {
      //si esta en el estado la removemos
      state.remove(movie.id);
      state = {
        ...state
      }; //volvemos asignarlo al state para indicar que hubo un cambio y poder renderizar de nuevo los widgets
    } else { //si no existe la agregamos al estado la nueva pelicula favorita
      state = {...state, movie.id: movie}; 
    }
  }
}
