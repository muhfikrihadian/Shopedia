import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopedia/features/utils/loading_screen.dart';
import 'package:shopedia/features/utils/message_screen.dart';

import '../helpers/strings.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'detail_product_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String query;
  final String name;

  CategoryScreen({required this.query, required this.name});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name.replaceAll("\n", " "),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      return FutureBuilder<void>(
                        future: provider.getProductsByCategory(widget.query),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingScreen();
                          } else if (snapshot.hasError) {
                            return MessageScreen(message: MsgErrorServer);
                          } else {
                            return GridView.builder(
                              itemCount: provider.dataProductsCat.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, i) {
                                return ChildProduct(provider.dataProductsCat[i]);
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChildProduct extends StatelessWidget {
  ProductModel productModel;
  late num totalPrice;
  late num price;
  late num discount;

  ChildProduct(this.productModel) {
    price = productModel.price ?? 0;
    discount = productModel.discountPercentage ?? 0;
    totalPrice = (price - (price * (discount / 100)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailProductScreen(
                    idProduct: productModel.id ?? 0,
                    category: productModel.category ?? "",
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: SizedBox.fromSize(
                    child: Image.network(
                      productModel.thumbnail ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  productModel.title ?? "-",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '\$${productModel.price?.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ic_official.png",
                            width: 10,
                            height: 10,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            child: Text(
                              productModel.brand ?? "-",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/ic_rating.png",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          productModel.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
