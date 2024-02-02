import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMovieCallback searchMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  List<Movie> initialMovies;

  SearchMovieDelegate({
    required this.initialMovies,
    required this.searchMovies
  });

  void clearStreams(){
    debouncedMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.refresh_rounded)),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.clear_rounded)),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestionsAndResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return _buildSuggestionsAndResults();
  }

  Widget _buildSuggestionsAndResults() {
    return StreamBuilder(
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
            itemBuilder: (context, index) => _MovieItem(
              movie: movies[index],
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            ),
            itemCount: movies.length,
          );
        });
  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size; 

    return GestureDetector(
      onTap:() => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //*Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  fit: BoxFit.cover,
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
    
            const SizedBox(width: 10),
            //*Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleLarge),
                  const SizedBox(height: 5),
                  movie.overview.length > 100
                  ? Text('${movie.overview.substring(0, 100)}...', style: textStyles.titleMedium)
                  : Text(movie.overview, style: textStyles.titleMedium) ,
                  
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: textStyles.bodyMedium
                        ?.copyWith(color: Colors.yellow.shade900))
                    ],
                  )
                ],
              ),
            )
    
          ],
        ),
      ),
    );
  }
  
}


