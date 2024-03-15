class Product {
  final String productName;
  final String productSmallImg;
  final String productDescription;
  int quantityCount;
  bool isAddedtocart;
  final List<Price> priceList;

  Product({
    required this.productName,
    required this.productSmallImg,
    required this.productDescription,
    required this.priceList,
    required this.quantityCount,
    required this.isAddedtocart,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['product_name'],
      productSmallImg: json['product_small_img'],
      productDescription: json['ProductDescription'],
      quantityCount: 0,
      isAddedtocart: false,
      priceList:
          List<Price>.from(json['PriceList'].map((x) => Price.fromJson(x))),
    );
  }
}

class Price {
  final String productMRP;

  Price({required this.productMRP});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      productMRP: json['product_MRP'],
    );
  }
}
