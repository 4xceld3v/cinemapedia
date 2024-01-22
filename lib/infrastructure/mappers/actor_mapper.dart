

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {

  static Actor castToEntity(Cast cast) {

    return Actor(
      id: cast.id, 
      name: cast.name, 
      profilePath: cast.profilePath != null 
        ? "https://image.tmdb.org/t/p/w500${cast.profilePath}" 
        : 'https://st4.depositphotos.com/9998432/24428/v/450/depositphotos_244284796-stock-illustration-person-gray-photo-placeholder-man.jpg',
      character: cast.character
    );
  }
  
}