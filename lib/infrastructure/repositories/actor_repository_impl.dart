import 'package:cinemapedia/domain/datasource/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  
  final ActorsDatasource actorsDatasource;

  ActorRepositoryImpl( this.actorsDatasource );

  @override
  Future<List<Actor>> getActorsByMovieId(String movieId) async {
    return await actorsDatasource.getActorsByMovieId(movieId);
  }
  
}