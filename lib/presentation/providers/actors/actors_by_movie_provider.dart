import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch(actorsRepositoryProvider).getActorsByMovieId;
  return ActorByMovieNotifier(getActors: actorsRepository);
});

/*
{
  '505642': <Actor>[],
  '505643': <Actor>[],
  '505644': <Actor>[],
  '505645': <Actor>[],
}
*/

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {

  final GetActorsCallback getActors;

  ActorByMovieNotifier({
    required this.getActors
  }) : super({});

  Future<void> loadActors(String movieId) async {

    if (state[movieId] != null) return;

    final List<Actor> actors = await getActors( movieId );
    
    state = { ...state, movieId: actors };

  }
}



