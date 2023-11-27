import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';


//cambiamos el statefullwidget por ConsumerStateWidget
class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  //Cambiamos el state, por la clase _HomeViewState propiamente dicha
  @override
  HomeViewState createState() => HomeViewState();
}

//Cambiamos el state por ConsumerState
class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //se utiliza el read porque estamos dentro de un metodo
    //ademas en el init, realizamos la primera peticion
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(nowPopularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //aqui si utilizamos el watch porque vamos a estar al pendiente
    //del listado de las peliculas, por si hubo algun cambio
    //una vez realizado el read del init, mediante el watch donde se utilize la variable
    //se redibujara el widget

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    //recordamos que los watch que los watch de los provders de abajo ya
    //estan cargando datos, porque en el initstate ya se invoco el loadNextPage() de cada uno. super genial!!!

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(nowPopularMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final slidesShowMovies = ref.watch(moviesSlideshowProvider);

    

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              // const CustomAppbar(),

              MoviesSlideshow(movies: slidesShowMovies),

              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Octubre 27',
                loadNextPage: () {
                  //print('Llamado del padre');
                  ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(); //recordemos que el read se utiliza cuando estamos dentro de funciones.
                },
              ),

              MovieHorizontalListview(
                movies: upComingMovies,
                title: 'Proximamente',
                subTitle: 'En este mes',
                loadNextPage: () {
                  //print('Llamado del padre');
                  ref
                      .read(upComingMoviesProvider.notifier)
                      .loadNextPage(); //recordemos que el read se utiliza cuando estamos dentro de funciones.
                },
              ),
              MovieHorizontalListview(
                movies: popularMovies,
                title: 'Populares',
                // subTitle: 'En este mes',
                loadNextPage: () =>
                    ref.read(nowPopularMoviesProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: topRatedMovies,
                title: 'Mejor calificadas',
                subTitle: 'Desde siempre',
                loadNextPage: () {
                  //print('Llamado del padre');
                  ref
                      .read(topRatedMoviesProvider.notifier)
                      .loadNextPage(); //recordemos que el read se utiliza cuando estamos dentro de funciones.
                },
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        }, childCount: 1)),
      ],
    );
  }
}
