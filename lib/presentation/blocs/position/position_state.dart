class PositionState {
  final bool isLoading;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? errorMessage;

  const PositionState({
    this.isLoading = false,
    this.latitude,
    this.longitude,
    this.city,
    this.errorMessage,
  });

  PositionState copyWith({
    bool? isLoading,
    double? latitude,
    double? longitude,
    String? city,
    String? errorMessage,
  }) {
    return PositionState(
      isLoading: isLoading ?? this.isLoading,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PositionState.initial() => const PositionState();

  factory PositionState.loading() => const PositionState(isLoading: true);

  factory PositionState.success(double? latitude, double? longitude, String? city) {
    return PositionState(latitude: latitude, longitude: longitude, city: city);
  }

  factory PositionState.failure(String errorMessage) => PositionState(errorMessage: errorMessage);
}
