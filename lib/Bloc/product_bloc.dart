import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesmed_task_project/Bloc/product_event.dart';
import 'package:timesmed_task_project/Bloc/product_state.dart';

class ProductBLoc extends Bloc<ProductEvent, ProductState> {
  ProductBLoc() : super((const ProductInit(productcount: 0))) {
    int totalcount = 0;
    on<ProductIncrement>((event, emit) async {
      emit(ProductLoading());
      totalcount++;
      emit(ProductInit(productcount: totalcount));
    });
    on<ProductDecrement>((event, emit) async {
      emit(ProductLoading());
      totalcount--;
      emit(ProductInit(productcount: totalcount));
    });
  }
}
