import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopedia/features/add_product_screen.dart';
import 'package:shopedia/features/edit_product_screen.dart';
import 'package:shopedia/features/utils/loading_screen.dart';
import 'package:shopedia/features/utils/message_screen.dart';
import 'package:shopedia/helpers/colours.dart';

import '../helpers/strings.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'detail_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Provider.of<ProductProvider>(context, listen: false).getProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<ProductProvider>(context, listen: false).getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: productProvider.isLoading ? Center(child: LoadingScreen(),) : GridView.builder(
            controller: _scrollController,
            itemCount: productProvider.dataProducts.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, i) {
              return ChildProduct(productProvider.dataProducts[i]);
            },
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorPrimary,
        child: Icon(Icons.add, color: Colors.white,),
        shape: CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProduct()));
        },
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(idProduct: productModel.id ?? 0,)),);
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
