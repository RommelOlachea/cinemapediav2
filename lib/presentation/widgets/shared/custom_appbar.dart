import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 5,),
            Text('CinemaPedia', style: titleStyle,),
            const Spacer(), //toma el espacio disponible, esto separa lo mas que pueda el texto del icono de busqueda

            IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          ],
        ), //dale todo el ancho que se pueda
      ),
    ));
  }
}


