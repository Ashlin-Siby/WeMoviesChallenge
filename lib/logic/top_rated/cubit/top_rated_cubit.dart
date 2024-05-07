import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:prac/data/models/movies.models.dart';
import 'package:prac/data/repository/movie.repository.dart';
import 'package:prac/helper/app_cache.service.dart';

part 'top_rated_state.dart';

class TopRatedCubit extends Cubit<TopRatedState> {
  TopRatedCubit() : super(TopRatedLoadingState()) {
    fetchTopRatedMovies();
  }
  MovieRepository movieRepository = MovieRepository();

  void fetchTopRatedMovies(
      {bool retry = false, bool getCached = true, int page = 1}) async {
    try {
      if (retry) {
        emit(TopRatedLoadingState());
      }
      List<MovieModel> movies = await movieRepository.fetchTopRatedMovies(
          getCached: getCached, page: page);
      emit(TopRatedLoadedState(movies, AppCacheService().topPages, page));
    } catch (ex) {
      emit(TopRatedErrorState(""));
    }
  }
}
