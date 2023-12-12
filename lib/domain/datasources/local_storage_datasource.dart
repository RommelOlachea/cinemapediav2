import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
      Future<void> toggleFavorite(Movie movie); //metodo que sirve para agregar una pelicula
      Future<bool> isMovieFavorite(int movieId); //metodo que sirve para verificar si la pelicula esta en favoritos
      Future <List<Movie>> loadMovies({int limit = 10, offset = 0}); //metodo que me permite leer las peliculas, y limitamos la cantidad de resultados

}


