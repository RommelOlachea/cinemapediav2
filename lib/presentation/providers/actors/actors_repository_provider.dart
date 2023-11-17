import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//Este repositorio es inmutable (solo lectura), porque es de tipo Provider,
//Este provider mantiene la instancia del la implementacion del repositorio (de infrastructure)
final actorsRepositoryProvider = Provider((ref) {

  return ActorRepositoryImpl(ActorMovieDbDatasource());
  // return MoviesRepositoryImpl(ActorsIMDBDatasource());
  //cuando cambia el datasource solo cambiamos esta linea


});
