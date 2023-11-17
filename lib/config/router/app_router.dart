import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

//Nota: utilizar GoRoute nos permite no utilizar configuraciones adicionales
//si vamos a utilizar nuestro codigo en la web

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/movie/:id',
    name: MovieScreen.name,
    builder: (context, state) {
      final movieId = state.pathParameters['id'] ?? 'no-id';
      return MovieScreen(movieId: movieId);
    },
  ),
]);
