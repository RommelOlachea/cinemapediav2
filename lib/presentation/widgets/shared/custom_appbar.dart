import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
        //SafeArea: para evitar los notch
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.movie_outlined,
                  color: colors.primary,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'CinemaPedia',
                  style: titleStyle,
                ),
                const Spacer(), //toma el espacio disponible, esto separa lo mas que pueda el texto del icono de busqueda

                IconButton(
                    onPressed: () {
                      //final movieRepository = ref.read(movieRepositoryProvider);
                      final searchedMovies = ref.read(searchedMoviesProvider);
                      final searchQuery = ref.read(searchQueryProvider);

                      showSearch<Movie?>(
                          //el search delegate puede regresar cualquier dato dinamico, showSearch ya es una funcion definida para utilizar delegate en flutter
                          query: searchQuery,
                          context: context,
                          //el delegate es el se va encargar de realizar la busqueda, le pasamos la referencia de la funcion searchMovies del searchedMoviesProvider el cual ejecuta la funcion de busqueda de peliculas del provider del repositorio implementado
                          delegate: SearchMovieDelegate(
                            initialMovies: searchedMovies,
                            searchMovies: ref
                                .read(searchedMoviesProvider.notifier)
                                .searchMoviesByQuery,
                          )).then((movie) {
                        if (movie == null) return;

                        context.push('/home/0/movie/${movie.id}');
                      });
                    },
                    icon: const Icon(Icons.search)),
              ],
            ), //dale todo el ancho que se pueda
          ),
        ));
  }
}
