part of 'drive_search_cubit.dart';

abstract class DriveSearchState extends Equatable {
  const DriveSearchState();

  @override
  List<Object> get props => [];
}

class DriveSearchInitial extends DriveSearchState {}

class DriveSearchLoading extends DriveSearchState {}

class DriveSearchLoaded extends DriveSearchState {
  final List<DriveSearchResult> searchResults;
  final String lastQuery;
  final String accessToken;

  const DriveSearchLoaded({
    required this.searchResults,
    required this.lastQuery,
    required this.accessToken,
  });

  @override
  List<Object> get props => [searchResults, lastQuery, accessToken];
}

class DriveSearchEmpty extends DriveSearchState {
  const DriveSearchEmpty();
}

class DriveSearchError extends DriveSearchState {
  final String message;

  const DriveSearchError({required this.message});

  @override
  List<Object> get props => [message];
}
