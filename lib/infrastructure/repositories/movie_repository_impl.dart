import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource; //es la clase abstracta MoviesDatasource

  //nota: la implementacion del repository debera recibir una implementacion del la abstraccion del MovieDatasource
  //aunque la propiedad este definida como la abstraccion
  MoviesRepositoryImpl(this.datasource);

//en los siguientes metodos, aunque sean un Future, no tienen el async, porque el metodo del datasource
//que mandan llamar lo tiene, podriamos ponersele tambien en el metodo que llama al datasource y no pasa nada.
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(
        page: page); //regresamos el listado de peliculas del datasource dado
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(
        page: page); //regresamos el listado de peliculas del datasource dado
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }

  @override
  Future<List<Movie>> searchMovie(String query) {
    return datasource.searchMovie(query);
  }
}
