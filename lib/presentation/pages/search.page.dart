import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prac/data/models/movies.models.dart';
import 'package:prac/helper/app_cache.service.dart';
import 'package:prac/helper/shimmer.widget.dart';
import 'package:prac/presentation/widgets/shared/star_rating.widget.dart';

class MoviesListSearchDelegate extends SearchDelegate {
  final ThemeData theme;

  MoviesListSearchDelegate({required this.theme});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: theme.iconTheme,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ));
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return MoviesSearchResults(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return MoviesSearchResults(query: query);
  }
}

class MoviesSearchResults extends StatelessWidget {
  final String query;

  const MoviesSearchResults({Key? key, this.query = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MovieModel>> searchData =
        AppCacheService().searchMovies(query);
    List<MovieModel> searchMovies = [
      ...(searchData['now']!),
      ...(searchData['top']!)
    ];
    return searchMovies.isNotEmpty
        ? ListView.builder(
            itemCount: searchMovies.length,
            itemBuilder: (context, index) => MovieSearchItem(
              title: searchMovies[index].title ?? '',
              imageUrl: searchMovies[index].posterPath ?? '',
              rating: searchMovies[index].voteAverage ?? 0,
              isPlayingNow: index < (searchData['now']!.length),
            ),
          )
        : const Center(child: Text('No Results'));
  }
}

class MovieSearchItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final bool isPlayingNow;
  const MovieSearchItem(
      {super.key,
      required this.imageUrl,
      required this.rating,
      required this.isPlayingNow,
      required this.title});

  @override
  Widget build(BuildContext context) {
    String iconPath = "https://image.tmdb.org/t/p/w92/$imageUrl";
    return ListTile(
      title: Text(title),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
            height: 48,
            width: 48,
            child: CachedNetworkImage(
              imageUrl: iconPath,
              placeholder: (context, url) => const ShimmerWidget(
                height: 48,
                width: 48,
              ),
            )),
      ),
      subtitle: Row(
        children: [
          StarRatingWidget(rating: (rating).toStringAsFixed(2)),
          const SizedBox(
            width: 8,
          ),
          Text(isPlayingNow ? "Now Playing" : "Top Rated")
        ],
      ),
    );
  }
}
