import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//creamos el provider, este solo nos servira para mantener y modificar el estado de la data
final actorsByMovieProvider = StateNotifierProvider <ActorByMovieNotifier, Map<String,List<Actor>>> ((ref) {
  final actorsRepository = ref.watch(actorsRepositoryProvider);
  return ActorByMovieNotifier(getActors: actorsRepository.getActorsByMovie);
});

//estructura de la cache (state) de datos que manejara el admimistrador del provider
/*
{
  '5001' : <Actor>[],
  '5002' : <Actor>[],
  '5003' : <Actor>[],
  '5301' : <Actor>[],
  '6701' : <Actor>[],
}
*/

typedef GetActorsCallBack = Future <List<Actor>> Function(String movieId);

//clase que administrara el flujo del provider
class ActorByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallBack getActors;

  ActorByMovieNotifier({required this.getActors})
      : super(
            {}); //inicializamos el flugo de la data que manejara el MovieMapNotifier ( Map<String, <Actor> []  )

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    
    final List<Actor>  actors = await getActors(movieId);

    state = {
      ...state,
      movieId: actors
    }; //...state hacemos el spread del state, para clonarlo y agregar la pelicula que no esta en cache
  }
}
