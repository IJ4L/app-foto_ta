import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/data/services/event_service.dart';

// States
abstract class EventImagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventImagesInitial extends EventImagesState {}

class EventImagesLoading extends EventImagesState {
  final List<Map<String, String>> currentImages;
  final bool isLoadingMore;

  EventImagesLoading({required this.currentImages, this.isLoadingMore = false});

  @override
  List<Object?> get props => [currentImages, isLoadingMore];
}

class EventImagesLoaded extends EventImagesState {
  final List<Map<String, String>> images;
  final bool hasMoreImages;
  final int currentPage;

  EventImagesLoaded({
    required this.images,
    required this.hasMoreImages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [images, hasMoreImages, currentPage];

  EventImagesLoaded copyWith({
    List<Map<String, String>>? images,
    bool? hasMoreImages,
    int? currentPage,
  }) {
    return EventImagesLoaded(
      images: images ?? this.images,
      hasMoreImages: hasMoreImages ?? this.hasMoreImages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class EventImagesError extends EventImagesState {
  final String message;
  final List<Map<String, String>> currentImages;

  EventImagesError({required this.message, required this.currentImages});

  @override
  List<Object?> get props => [message, currentImages];
}

// Cubit
class EventImagesCubit extends Cubit<EventImagesState> {
  EventImagesCubit() : super(EventImagesInitial());

  void initializeStaticImages() {
    final staticImages = [
      {'image': 'https://picsum.photos/id/237/200/300', 'name': 'Foto 1'},
      {'image': 'https://picsum.photos/id/238/200/300', 'name': 'Foto 2'},
      {'image': 'https://picsum.photos/id/239/200/300', 'name': 'Foto 3'},
      {'image': 'https://picsum.photos/id/240/200/300', 'name': 'Foto 4'},
      {'image': 'https://picsum.photos/id/241/200/300', 'name': 'Foto 5'},
      {'image': 'https://picsum.photos/id/242/200/300', 'name': 'Foto 6'},
    ];

    emit(
      EventImagesLoaded(
        images: staticImages,
        hasMoreImages: false,
        currentPage: 1,
      ),
    );
  }

  void initializeFromList(List<String> imageUrls, int itemsPerPage) {
    if (imageUrls.isEmpty) {
      initializeStaticImages();
      return;
    }

    final endIdx = itemsPerPage < imageUrls.length
        ? itemsPerPage
        : imageUrls.length;
    final initialImages = imageUrls.sublist(0, endIdx).map((url) {
      return {'image': url, 'name': url.split('/').last};
    }).toList();

    emit(
      EventImagesLoaded(
        images: initialImages,
        hasMoreImages: imageUrls.length > initialImages.length,
        currentPage: 1,
      ),
    );
  }

  void loadMoreFromList(List<String> allImages, int itemsPerPage) async {
    final currentState = state;
    if (currentState is! EventImagesLoaded) return;

    if (!currentState.hasMoreImages) return;

    emit(
      EventImagesLoading(
        currentImages: currentState.images,
        isLoadingMore: true,
      ),
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay

    final startIdx = currentState.images.length;
    final endIdx = startIdx + itemsPerPage;

    if (startIdx >= allImages.length) {
      // No more images
      emit(currentState.copyWith(hasMoreImages: false));
      return;
    }

    final newImages = allImages
        .sublist(
          startIdx,
          endIdx < allImages.length ? endIdx : allImages.length,
        )
        .map((url) {
          return {'image': url, 'name': url.split('/').last};
        })
        .toList();

    final updatedImages = [...currentState.images, ...newImages];

    emit(
      EventImagesLoaded(
        images: updatedImages,
        hasMoreImages: allImages.length > updatedImages.length,
        currentPage: currentState.currentPage + 1,
      ),
    );
  }

  // Function to load data from API through EventService directly
  Future<void> loadFromApi(
    int eventId,
    String accessToken,
    EventService eventService, {
    int page = 1,
    int limit = 10,
  }) async {
    if (state is EventImagesInitial || page <= 1) {
      emit(EventImagesLoading(currentImages: [], isLoadingMore: false));
    } else if (state is EventImagesLoaded) {
      final currentState = state as EventImagesLoaded;
      emit(
        EventImagesLoading(
          currentImages: currentState.images,
          isLoadingMore: true,
        ),
      );
    }

    try {
      final result = await eventService.getEventImages(
        eventId,
        accessToken,
        page: page,
        limit: limit,
      );

      final List<Map<String, String>> newImages = [];

      if (result.images.isNotEmpty) {
        for (final image in result.images) {
          newImages.add({'image': image.url, 'name': 'Foto ${image.id}'});
        }
      }

      if (state is EventImagesLoading &&
          (state as EventImagesLoading).isLoadingMore) {
        // Adding more images to existing list
        final currentImages = (state as EventImagesLoading).currentImages;
        final updatedImages = [...currentImages, ...newImages];

        emit(
          EventImagesLoaded(
            images: updatedImages,
            hasMoreImages: page < result.totalPages,
            currentPage: page,
          ),
        );
      } else {
        // Initial load
        emit(
          EventImagesLoaded(
            images: newImages,
            hasMoreImages: page < result.totalPages,
            currentPage: page,
          ),
        );
      }
    } catch (e) {
      if (state is EventImagesLoading &&
          (state as EventImagesLoading).isLoadingMore) {
        // Error while adding more, keep existing images
        final currentImages = (state as EventImagesLoading).currentImages;
        emit(
          EventImagesError(
            message: 'Failed to load more images: $e',
            currentImages: currentImages,
          ),
        );
      } else {
        // Error on initial load
        emit(
          EventImagesError(
            message: 'Failed to load images: $e',
            currentImages: [],
          ),
        );
      }
    }
  }

  Future<void> loadMoreFromApi(
    int eventId,
    String accessToken,
    EventService eventService,
  ) async {
    final currentState = state;
    if (currentState is! EventImagesLoaded) return;
    if (!currentState.hasMoreImages) return;

    final nextPage = currentState.currentPage + 1;
    await loadFromApi(eventId, accessToken, eventService, page: nextPage);
  }
}
