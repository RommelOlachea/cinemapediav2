import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar>
      db; // se le pone late para que termine de crear la db de isar

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir =
        await getApplicationDocumentsDirectory(); //obtenemos el directorio de la aplicacion

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema],
          inspector: true,
          directory: dir
              .path); //el inspector en true., nos permite levantar un servicio para ver la db, nota este se levanta hasta que interactuamos con la base
              //en la consola de depuracion te da el path web, para abrirla
    }
    return Future.value(
        Isar.getInstance()); //regresamos la instancia que ya estaba creada
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies
        .filter()
        .idEqualTo(movieId)
        .findFirst(); //buscamos la pelicula en la base de datos, el prefijo id es el nombre
    //de la propiedad en el esquema, y tiene varios metodos que genera isar para poderlos utilizar.

    return isFavoriteMovie !=
        null; //verdadero si no es null, y false si es null.
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;

    //el limit es la cantidad de registros a traer., y el offset el paginado

    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    //aqui vamos a grabar el registro en la base de datos

    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      //borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }

    //insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
