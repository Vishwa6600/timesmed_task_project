import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class ProductIncrement extends ProductEvent {
  final int incrementCount;

  const ProductIncrement({required this.incrementCount});

  @override
  List<Object> get props => [incrementCount];
}

class ProductDecrement extends ProductEvent {
  final int decrementCount;

  const ProductDecrement({required this.decrementCount});

  @override
  List<Object> get props => [decrementCount];
}
