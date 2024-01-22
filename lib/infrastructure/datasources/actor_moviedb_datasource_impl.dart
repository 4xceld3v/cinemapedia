import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasource/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasourceImpl extends ActorsDatasource{

    final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'es-CO',
    },
  ));

  @override
  Future<List<Actor>> getActorsByMovieId(String movieId) async {

    final response = await dio.get('/movie/$movieId/credits');

    final creditResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = creditResponse.cast.map(
      (actor) => ActorMapper.castToEntity(actor)
    ).toList();

    return actors;
  }

}