import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Esta clase es un Provider que nos permite obtener una instancia de MovieRepositoryImpl
final movieRepositoryProvider = Provider((ref) {

  return MovieRepositoryImpl( MoviedbDatasourceImpl() );

});


