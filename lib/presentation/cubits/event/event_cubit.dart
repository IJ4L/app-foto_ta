import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/data/repositories/event_repository.dart';
import 'package:foto_ta/data/services/event_service.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventAccessLoading extends EventState {}

class EventAccessSuccess extends EventState {
  final String accessToken;
  final String tokenType;

  EventAccessSuccess({required this.accessToken, required this.tokenType});

  @override
  List<Object?> get props => [accessToken, tokenType];
}

class EventAccessError extends EventState {
  final String message;

  EventAccessError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventImagesLoading extends EventState {}

class EventImagesLoaded extends EventState {
  final List<EventImage> images;
  final int totalPages;
  final int currentPage;
  final String accessToken;

  EventImagesLoaded({
    required this.images,
    required this.totalPages,
    required this.currentPage,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [images, totalPages, currentPage, accessToken];
}

class EventImagesError extends EventState {
  final String message;

  EventImagesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventCubit extends Cubit<EventState> {
  final EventRepository _eventRepository;

  EventCubit({required EventRepository eventRepository})
    : _eventRepository = eventRepository,
      super(EventInitial());

  Future<void> accessEvent(int eventId, String password) async {
    emit(EventAccessLoading());

    final result = await _eventRepository.accessEvent(eventId, password);
    if (result.success &&
        result.accessToken != null &&
        result.tokenType != null) {
      emit(
        EventAccessSuccess(
          accessToken: result.accessToken!,
          tokenType: result.tokenType!,
        ),
      );

      await getEventImages(eventId, result.accessToken!);
    } else {
      emit(EventAccessError(message: result.message));
    }
  }

  Future<void> getEventImages(
    int eventId,
    String accessToken, {
    int page = 1,
    int limit = 10,
  }) async {
    if (page <= 1) {
      emit(EventImagesLoading());
    }

    final result = await _eventRepository.getEventImages(
      eventId,
      accessToken,
      page: page,
      limit: limit,
    );

    if (result.success && result.images != null) {
      emit(
        EventImagesLoaded(
          images: result.images!,
          totalPages: result.totalPages ?? 1,
          currentPage: result.currentPage ?? 1,
          accessToken: accessToken,
        ),
      );
    } else {
      emit(EventImagesError(message: result.message));
    }
  }
}
