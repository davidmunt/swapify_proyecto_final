import 'package:swapify/domain/entities/recomendation_price.dart';

class RecomendationPriceState {
  final bool isLoading;
  final RecomendationPriceEntity? recomendationPriceEntity;
  final String? errorMessage;

  const RecomendationPriceState({
    this.isLoading = false,
    this.recomendationPriceEntity,
    this.errorMessage,
  });

  RecomendationPriceState copyWith({
    bool? isLoading,
    RecomendationPriceEntity? recomendationPriceEntity,
    String? errorMessage,
  }) {
    return RecomendationPriceState(
      isLoading: isLoading ?? this.isLoading,
      recomendationPriceEntity: recomendationPriceEntity ?? this.recomendationPriceEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecomendationPriceState.initial() => const RecomendationPriceState();

  factory RecomendationPriceState.loading() => const RecomendationPriceState(isLoading: true);

  factory RecomendationPriceState.success(RecomendationPriceEntity recomendationPriceEntity) {
    return RecomendationPriceState(recomendationPriceEntity: recomendationPriceEntity);
  }

  factory RecomendationPriceState.failure(String errorMessage) => RecomendationPriceState(errorMessage: errorMessage);
}