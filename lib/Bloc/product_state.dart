import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInit extends ProductState {
  final int? productcount;

  const ProductInit({required this.productcount});

  @override
  List<Object> get props => [productcount!];
}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {}

class ProductLoadingFailed extends ProductState {}
