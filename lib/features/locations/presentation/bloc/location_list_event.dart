import 'package:equatable/equatable.dart';

abstract class LocationListEvent extends Equatable {
  const LocationListEvent();

  @override
  List<Object?> get props => [];
}

class LocationListStarted extends LocationListEvent {
  const LocationListStarted();
}

class LocationListRefreshRequested extends LocationListEvent {
  const LocationListRefreshRequested();
}

class LocationSearchChanged extends LocationListEvent {
  final String query;

  const LocationSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
