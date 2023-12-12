import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

//Nota: utilizar GoRoute nos permite no utilizar configuraciones adicionales
//si vamos a utilizar nuestro codigo en la web

final appRouter = GoRouter(
    initialLocation:
        '/home/0', //la ruta por default es home, con el paremetro de pageindex en 0
    routes: [
      GoRoute(
          path: '/home/:page', //el parametro recibido se encuentra en page, y se utilizara porque se utiliza un widget IndexedStack en el home
          name: HomeScreen.name,
          builder: (context, state) {
            final pageIndex = state.pathParameters['page'] ??
                0; //si el parametro page no se encuentra el pageindex sera 0
            return HomeScreen(
                pageIndex: int.parse(pageIndex
                    .toString())); //se pasa a tostring porque pageIndex es regresado como un objeto
          },
          routes: [
            GoRoute(
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (context, state) {
                final movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen(movieId: movieId);
              },
            ),
          ]),
      GoRoute(
        path: '/',
        redirect: (context, state) =>
            '/home/0', //tambien podemos poner ( _, __ ) => '/home/0' donde el ( _, __ ) es como si fuera (a, b), es normal verlo
      ),
    ]);


