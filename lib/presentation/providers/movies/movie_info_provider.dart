import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//creamos el provider
final movieInfoProvider = StateNotifierProvider <MovieMapNotifier, Map<String,Movie>> ((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});

//estructura de la cache (state) de datos que manejara el admimistrador del provider
/*
{
  '5001' : Movie(),
  '5002' : Movie(),
  '5003' : Movie(),
  '5301' : Movie(),
  '6701' : Movie(),
}
*/

typedef GetMovieCallBack = Future<Movie> Function(String movieId);

//clase que administrara el flujo del provider
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallBack getMovie;

  MovieMapNotifier({required this.getMovie})
      : super(
            {}); //inicializamos el flugo de la data que manejara el MovieMapNotifier ( Map<String, Movie>  )

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    print('raelizando peticion http');
    final movie = await getMovie(movieId);

    state = {
      ...state,
      movieId: movie
    }; //...state hacemos el spread del state, para clonarlo y agregar la pelicula que no esta en cache
  }
}
