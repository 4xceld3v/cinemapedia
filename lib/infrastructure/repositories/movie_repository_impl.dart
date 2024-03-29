import 'package:cinemapedia/domain/datasource/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl implements MoviesRepository {

  final MoviesDatasource moviesDatasource;

  MovieRepositoryImpl(this.moviesDatasource);

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) {
    return moviesDatasource.getNowPlayingMovies(page: page);
  }
  
  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) {
    return moviesDatasource.getPopularMovies(page: page);
  }
  
  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) {
    return moviesDatasource.getTopRatedMovies(page: page);
  }
  
  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) {
    return moviesDatasource.getUpcomingMovies(page: page);
  }
  
  @override
  Future<Movie> getMoviesById( String movieId ) {
    return moviesDatasource.getMoviesById(movieId);
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) {
    return moviesDatasource.searchMovies(query);
  }


}