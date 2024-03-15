// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesmed_task_project/API_Base/api_base.dart';
import 'package:timesmed_task_project/Bloc/product_bloc.dart';
import 'package:timesmed_task_project/Bloc/product_event.dart';
import 'package:timesmed_task_project/Bloc/product_state.dart';
import 'package:timesmed_task_project/DataHub/app_strings.dart';
import 'package:timesmed_task_project/Model/product_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:timesmed_task_project/Screens/product_details_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> products = [];
  bool isAddButtonClicked = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProductBLoc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return CircularProgressIndicator();
          }
          return BlocBuilder<ProductBLoc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return CircularProgressIndicator();
              }
              if (state is ProductInit) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.green,
                    centerTitle: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.r),
                      ),
                    ),
                    elevation: 10.0,
                    leading: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      AppStrings.appName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          Positioned(
                              right: 5,
                              top: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 10,
                                child: Text(
                                  state.productcount == 0
                                      ? "0"
                                      : state.productcount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                  body: isLoading == true
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return _buildProductCard(products[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              }
              return SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      color: Colors.white,
      elevation: 10.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                    product: product,
                  )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    product.productSmallImg,
                    height: 70.h,
                    width: 80.w,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    product.productName,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '₹${product.priceList[0].productMRP}', // Format price
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      isAddButtonClicked == false
                          ? SizedBox(
                              height: 30.h,
                              width: 70.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isAddButtonClicked = true;
                                  });
                                },
                                child: Text(
                                  AppStrings.addText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            )
                          : Flexible(
                              child: Container(
                                width: 95.w,
                                height: 30.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        size: 16.sp,
                                      ),
                                      onPressed: () {
                                        if (product.quantityCount > 0) {
                                          setState(() {
                                            product.quantityCount--;
                                          });
                                          BlocProvider.of<ProductBLoc>(context)
                                              .add(ProductDecrement(
                                                  decrementCount:
                                                      product.quantityCount));
                                        }
                                      },
                                    ),
                                    Text(
                                      product.quantityCount.toString(),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        size: 16.sp,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          product.quantityCount++;
                                        });
                                        BlocProvider.of<ProductBLoc>(context)
                                            .add(ProductIncrement(
                                                incrementCount:
                                                    product.quantityCount));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(ApiBase.productListAPI));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['Data'];
      setState(() {
        products = List<Product>.from(data.map((x) => Product.fromJson(x)));
        isLoading = false;
      });
    } else {
      throw Exception(AppStrings.failedErrMsg);
    }
  }
}
