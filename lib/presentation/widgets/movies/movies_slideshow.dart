import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        viewportFraction:
            0.8, //podemos ver una fraccion en el carrusel de la imagen anterior y posterior
        scale:
            0.9, //la imagen anterior y posterior en el carrusel se ven mas peques
        autoplay: true, //se moveran automaticamente
        pagination: SwiperPagination( //crea los puntitos debajo de la imagen
          margin: const EdgeInsets.only(top: 0), //baja los puntitos mas abajo de la imagen
          builder: DotSwiperPaginationBuilder( 
            activeColor: colors.primary, //define color seleccionado del puntito
            color: colors.secondary, //define los colores de los puntitos no seleccionado
          )
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(movie: movies[index]),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
            color: Colors.black45, //colod difuminado
            blurRadius: 10, //crea un difuminado
            offset: Offset(0, 10) // mueve la sombra
            )
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          //me permite ponerle los bordes redondeados a la imagen
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit
                .cover, //esto hace que la imagen tome el espacio que le estamos dando
            loadingBuilder: (context, child, loadingProgress) {
              //me permite determinar si la imagen todavia esta proceso de loading o carga
              if (loadingProgress != null) {
                return const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black12));
              }
              return FadeIn(child: child);
            },
          ),
        ),
      ),
    );
  }
}
