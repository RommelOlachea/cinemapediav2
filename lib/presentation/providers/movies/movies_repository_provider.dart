import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';


//Este repositorio es inmutable (solo lectura), porque es de tipo Provider,
//Este provider mantiene la instancia del la implementacion del repositorio (de infrastructure)
final movieRepositoryProvider = Provider((ref) {

  return MoviesRepositoryImpl(MoviedbDatasource());
  // return MoviesRepositoryImpl(IMDBDatasource());
  //cuando cambia el datasource solo cambiamos esta linea


});
