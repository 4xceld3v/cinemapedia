import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/date_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return _MovieDetails(movie: movie);
          }, childCount: 1))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTitleStyle = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Titulo: ',
                        style: textTitleStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: movie.title,
                            style: textTitleStyle.copyWith(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    //Text(movie.title, style: textStyle.titleLarge),
                    const Text('Visión general:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(movie.overview, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),

                    const SizedBox(height: 10),

                    RichText(
                      text: TextSpan(
                        text: 'Fecha de lanzamiento: ',
                        style: textTitleStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: DateFormats.formatDate(movie.releaseDate),
                            style: textTitleStyle.copyWith(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Géneros:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                children: movie.genreIds
                    .map((genre) => Container(
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          child: Chip(
                            label: Text(genre),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovie({ required this.movieId });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final actors = actorsByMovie[movieId]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Actores:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final actor = actors[index];
              return Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    FadeInRight(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          actor.profilePath,
                          width: 120,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: Text(
                        actor.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        actor.character!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        )
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );

  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                    ? FadeIn(child: child)
                    : const SizedBox(),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1.0],
                          colors: [Colors.transparent, Colors.black87]))),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          stops: [0.0, 0.3],
                          colors: [Colors.black87, Colors.transparent]))),
            ),
          ],
        ),
      ),
    );
  }
}
