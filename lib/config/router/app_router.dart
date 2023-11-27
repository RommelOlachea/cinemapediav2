import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/home_views/home_view.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/views/views.dart';

//Nota: utilizar GoRoute nos permite no utilizar configuraciones adicionales
//si vamos a utilizar nuestro codigo en la web

//con ShellRoute podemos navegar sin destruir el bottom navigator del HomeScreen, ni la vista a la que apunta la opcion

final appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
  ShellRoute(
    builder: (context, state, child) {
      return HomeScreen(childView: child);
    },
    routes: [
      GoRoute(
        path: '/',     //este seria el path inicial del shellrouter., y el widget que se manda es el HomeView, como child al homeScreen
        builder: (context, state) {
          return const HomeView();
        },
        routes: [
          //ruta hija que se manda llamar dentro del homeview 
          GoRoute(
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (context, state) {
                final movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen(movieId: movieId);
              },
            ),

        ],
      ),

      GoRoute(
        path: '/favorites',     
        builder: (context, state) {
          return const FavoritesView();
        },
      ),



    ],
  )
]);


//Rutas padre/hijo paso de parametros
// final appRouter = GoRouter(initialLocation: '/', routes: [
//   GoRoute(
//     path: '/',
//     name: HomeScreen.name,
//     builder: (context, state) => const HomeScreen(childView: HomeView(),),
//     routes: [
//             GoRoute(
//               path: 'movie/:id',
//               name: MovieScreen.name,
//               builder: (context, state) {
//                 final movieId = state.pathParameters['id'] ?? 'no-id';
//                 return MovieScreen(movieId: movieId);
//               },
//             ),

//     ],
//   );

//Rutas con manejo tradicional, y paso de parametros a un screenm
// final appRouter = GoRouter(initialLocation: '/', routes: [
//   GoRoute(
//     path: '/',
//     name: HomeScreen.name,
//     builder: (context, state) => const HomeScreen(childView: HomeView(),),
//   ),
//   GoRoute(
//     path: '/movie/:id',
//     name: MovieScreen.name,
//     builder: (context, state) {
//       final movieId = state.pathParameters['id'] ?? 'no-id';
//       return MovieScreen(movieId: movieId);
//     },
//   ),
// ]);