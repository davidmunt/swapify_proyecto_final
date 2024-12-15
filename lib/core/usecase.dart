import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}