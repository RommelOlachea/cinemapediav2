import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

//definimos un tipo que se llamara SearchMovieCallBack y debe tener la firma de la funcion definida
//asimismo en el searchdelegate definiremos una propiedad con ese tipo definido, para poder pasarle
//la referencia de la funcion del provider que contiene el repositorio o que mandara llamar a este, que nos dara el listado de
//peliculas., ufff.... complejo al inicio solamente
typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debounceMovies = StreamController
      .broadcast(); // se utiliza el broadcast porque mas de un widget lo va a escuchar

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer; //el timer nos sirve para medir un rango de tiempo

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  //funcion que cerrara el stream., cuando salgamos del SearchDelegate
  void _clearStream() {
    debounceMovies.close();
  }

  //funcion que sera llamada cada vez que escribamos algo (se dispara en el metodo BuildSuggestions)
  void _onQueryChanged(String query) {
    print('query string cambio');

    isLoadingStream.add(true);

    //si el _debouncetimer esta activo lo desactivamos y posteriormente ejecutamos una funcion solo si pasan 500 milisegundos
    //sin escribir., si durante el proceso del conteo volvemos a escribir volvemos a descactivar y volvemos a comenzar a contar
    //los 500 milisegundos

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!
          .cancel(); //si el timer esta activo, lo cancelamos cada vez que estamos escribiendo en el cuadro de busqueda
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      //cuando dejamos de escribir y pasan 500 milisegundos, ejecutamos la busqueda.

      print('buscando peliculas query');

      // if (query.isEmpty) {
      //   debounceMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(
          query); //esta es la funcion implementada en el provider searchedMoviesProvider en la funcion searchMoviesByQuery, en esta
      //se invoca la funcion del provider del repositorio que mantiene la implementacion de este
      debounceMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  //cambiamos la palabra dentro del cuadro de busqueda, de Search a Buscar pelicula
  @override
  String get searchFieldLabel => 'Buscar Película';

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      stream: debounceMovies.stream,
      initialData: initialMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              _clearStream();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  //nos permite construir las acciones, son los botones de la barra de busqueda
  //* NOTA: cada vez que escribimos y cambia el query, las acciones se disparan, se ejecuta este metodo.
  @override
  List<Widget>? buildActions(BuildContext context) {
    //la palabra query ya es propia del SearchDelegate y contiene lo escrito en el cuadro de busqueda,
    //Si la inicializamos, se inicializa lo que esta en el cuadro de busqueda

    // if (query.isNotEmpty) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20), //duracion de la animacion
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          return FadeIn(
            animate: query
                .isNotEmpty, //nos permite animar la entrada y la salida, fadein y fadeout segun el valor booleano, reemplaza al if externo
            duration:
                const Duration(milliseconds: 200), //duracion de la animacion
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      )
    ];
    //}
  }

//nos permite construir el icono, que se encuentra a un costado de la barra para escribir la busqueda
//regularmente es el icono para regresar a la pantalla anterior., pero puede ser otra cosa
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          _clearStream();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  //son los resultados que van a aparecer cuando las personas presionan enter
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  //Se va a disparar cada vez que la persona esta escribiendo algo
  @override
  Widget buildSuggestions(BuildContext context) {
    // return FutureBuilder(
    //   future: searchMovies(query),
    //   builder: (context, snapshot) {
    //     final movies = snapshot.data ?? [];

    //     return ListView.builder(
    //       itemCount: movies.length,
    //       itemBuilder: (context, index) => _MovieItem(
    //         movie: movies[index],
    //         onMovieSelected: close,
    //       ), //pasamos la funcion close del searchdelegate, para cerrar y regresar la movie
    //     );
    //   },
    // );

    //*cambiamos el futurebuilder de arriba por un StreamBuilder

    _onQueryChanged(query);

    return buildResultsAndSuggestions();
  }
}

//* NOTA: un streambuilder., redibujara un widget, hasta que el stream emita un valor., que es cuando el usuario
//* deje de escribir en el cuadro de busqueda., originalmente estaba con un FutureBuilder pero se lanzan muchas peticiones
//* cada vez que escribimos y se busca reducir el numero de trafico de las mismas. El stream notificara al streambuilder, en este
//* es el debounceMovies el streamController

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context,
            movie); //ejecuta la funcion que se le definio cuando creamos el _MovieItem, en el List.Builder
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              //image
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        FadeIn(child: child),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              //description
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleMedium,
                    ),
                    (movie.overview.length > 100)
                        ? Text('${movie.overview.substring(0, 100)}...')
                        : Text(movie.overview),
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_rounded,
                          color: Colors.yellow.shade800,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          HumanFormats.number(movie.voteAverage, 1),
                          style: textStyle.bodyMedium!
                              .copyWith(color: Colors.yellow.shade900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
