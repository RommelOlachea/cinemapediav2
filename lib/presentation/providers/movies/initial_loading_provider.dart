import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  //para poder determinar si ya tienen datos todos los providers, debemos verificar mediante
  //la propiedad isEmpty de cada uno de ellos, de esta manera cada provider regresara un booleano.

  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(nowPopularMoviesProvider).isEmpty;
  final step3 = ref.watch(upComingMoviesProvider).isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).isEmpty;

  if (step1 || step2 || step3 || step4) return true;

  return false; //** terminamos de cargar las peliculas de todas las secciones
});
