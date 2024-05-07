import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:prac/data/models/movies.models.dart';
import 'package:prac/data/repository/movie.repository.dart';
import 'package:prac/helper/app_cache.service.dart';

part 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingLoadingState()) {
    fetchNowPlayingMovies();
  }
  MovieRepository movieRepository = MovieRepository();

  void fetchNowPlayingMovies(
      {bool retry = false, bool getCached = true, int page = 1}) async {
    try {
      if (retry) {
        emit(NowPlayingLoadingState());
      }
      List<MovieModel> movies = await movieRepository.fetchNowPlayingMovies(
          getCached: getCached, page: page);
      emit(NowPlayingLoadedState(
          movies, AppCacheService().nowPlayingPages, page));
    } catch (ex) {
      emit(NowPlayingErrorState(""));
    }
  }
}
