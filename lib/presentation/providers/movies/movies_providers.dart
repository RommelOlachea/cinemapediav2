//aqui se definiran los nowplaymoviesingproviders, upcomingmoviesprovider, toprelatedmoviesproviders, etc

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este provider nos permitira saber las pelicuals que estan en el cine para consultar la info
//Proveedor que notifica cuando cambia el estado de la data
//El notificador es el MoviesNotifier y la data que fluye a traves de el es el List<Movie>
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  //nota: solo asignamos la referencia a la funcion para que sea invocada directamente
  //de la implementacion del repositorio que esta en el movieRepositoryProvider.
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//Para los otros casos de uso, ratedmovies, upcomingmovies, etc, solo creamos otro statenotifier como el de
// arriba pero cambiando la referencia de la funcion fetchMoreMovies

//NOTA: se realiza esta definicion para que sirva el MoviesNotifier de manera generica para la llamada de la
//la data, que es la misma, para nowPlayingMovies, upcomingmovies, toprate, etc., es decir definir el
//caso de uso
//typedef es un alias que nos permite definir tipos personalizados, en este caso, debe cumplir con la firma
//de la funcion
typedef MovieCallback = Future<List<Movie>> Function({int page});

//La clase MoviesNotifier se encargara de controlar el estado de la data (List<Movie>)
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading =
      false; //validacion para evitar mandar llamar muchas veces la carga de peliculas
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return; //si esta cargando nos salimos

    isLoading = true; //iniciamos la carga

    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    //modificamos el estado para que notifique
    state = [...state, ...movies];
    //await Future.delayed(const Duration(milliseconds: 300)); //esperamos un poco para el renderizado, esto es opcional
    
    isLoading = false; //finalizamos la carga
  }
}
