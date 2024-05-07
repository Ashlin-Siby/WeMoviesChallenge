import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prac/helper/puzzle_card_clipper.dart';
import 'package:prac/logic/now_playing/cubit/now_playing_cubit.dart';
import 'package:prac/logic/top_rated/cubit/top_rated_cubit.dart';
import 'package:prac/presentation/widgets/now_playing.widget.dart';
import 'package:prac/presentation/widgets/top_rated.widget.dart';

class WeMoviesPage extends StatefulWidget {
  const WeMoviesPage({super.key});

  @override
  State<WeMoviesPage> createState() => _WeMoviesPageState();
}

class _WeMoviesPageState extends State<WeMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<NowPlayingCubit>(context)
            .fetchNowPlayingMovies(getCached: false);
        BlocProvider.of<TopRatedCubit>(context)
            .fetchTopRatedMovies(getCached: false);
        return;
      },
      child: const SingleChildScrollView(
        child: Column(
          children: [WelcomWidget(), NowPlayingWidget(), TopRatedWidget()],
        ),
      ),
    );
  }
}

class WelcomWidget extends StatelessWidget {
  const WelcomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        children: [
          ClipPath(
            clipper: PuzzleCardClipperclass(cornerRadius: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFB6A0A4),
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width - 32,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      "We Movies",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    BlocBuilder<NowPlayingCubit, NowPlayingState>(
                      builder: (context, state) {
                        String movieCount = (state is NowPlayingLoadedState)
                            ? (state.moviesList.length.toString())
                            : "--";
                        return Text(
                            "$movieCount movies are loaded in now playing");
                      },
                    )
                  ]),
            ),
          ),
          Positioned(
            top: 4,
            left: 16,
            child: Text(
              DateFormat('dd MMM yyyy').format(DateTime.now()).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
