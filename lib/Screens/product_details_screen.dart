import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesmed_task_project/Bloc/product_bloc.dart';
import 'package:timesmed_task_project/Bloc/product_event.dart';
import 'package:timesmed_task_project/DataHub/app_strings.dart';
import 'package:timesmed_task_project/Model/product_response_model.dart'; // Import your product model here

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.productDetailScreenText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.product.productSmallImg,
                  height: 150.h,
                  width: 150.w,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "${AppStrings.productNameText} ${widget.product.productName}",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "${AppStrings.productDespText} ${widget.product.productDescription}",
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.priceText} ₹${widget.product.priceList[0].productMRP}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(5.r)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (widget.product.quantityCount > 0) {
                              setState(() {
                                widget.product.quantityCount--;
                              });
                              BlocProvider.of<ProductBLoc>(context).add(
                                  ProductDecrement(
                                      decrementCount:
                                          widget.product.quantityCount));
                            }
                          },
                        ),
                        Text(
                          widget.product.quantityCount.toString(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              widget.product.quantityCount++;
                            });
                            BlocProvider.of<ProductBLoc>(context).add(
                                ProductIncrement(
                                    incrementCount:
                                        widget.product.quantityCount));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
