import 'package:equatable/equatable.dart';
import 'package:field_track/features/auth/domain/entities/user.dart';

enum HomeStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final User? user;
  final bool loggedOut;

  const HomeState({
    this.status = HomeStatus.initial,
    this.user,
    this.loggedOut = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    User? user,
    bool? loggedOut,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }

  @override
  List<Object?> get props => [status, user, loggedOut];
}
