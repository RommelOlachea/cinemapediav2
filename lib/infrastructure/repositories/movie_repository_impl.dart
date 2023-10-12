import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource; //es la clase abstracta MoviesDatasource

  //nota: la implementacion del repository debera recibir una implementacion del la abstraccion del MovieDatasource
  //aunque la propiedad este definida como la abstraccion
  MoviesRepositoryImpl(this.datasource); 

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}