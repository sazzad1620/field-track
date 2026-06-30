import 'package:equatable/equatable.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';

enum LocationListStatus { initial, loading, loaded, failure }

class LocationListState extends Equatable {
  final LocationListStatus status;
  final List<Location> locations;
  final String searchQuery;
  final String? errorMessage;

  const LocationListState({
    this.status = LocationListStatus.initial,
    this.locations = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  List<Location> get filteredLocations {
    if (searchQuery.trim().isEmpty) return locations;
    final q = searchQuery.toLowerCase();
    return locations
        .where((l) => l.locationName.toLowerCase().contains(q))
        .toList();
  }

  LocationListState copyWith({
    LocationListStatus? status,
    List<Location>? locations,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LocationListState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, locations, searchQuery, errorMessage];
}
