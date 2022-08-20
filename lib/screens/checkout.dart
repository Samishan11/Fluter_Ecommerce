import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/cartmodel.dart';

import 'package:e_commerce/provider/product_provider.dart';
import 'package:e_commerce/screens/homepage.dart';
import 'package:e_commerce/widgets/checkout_singleproduct.dart';
import 'package:e_commerce/widgets/mybutton.dart';
import 'package:e_commerce/widgets/notification_button.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextStyle myStyle = TextStyle(
    fontSize: 18,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductProvider productProvider;

  Widget _buildBottomSingleDetail({String startName, String endName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          startName,
          style: myStyle,
        ),
        Text(
          endName,
          style: myStyle,
        ),
      ],
    );
  }

  User user;
  double total;
  var product;
  List<CartModel> myList;
  Widget _buildButton() {
    return Column(
        children: productProvider.userModelList.map((e) {
      return Container(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        MyButton(
                          name: "Buy",
                          onPressed: () {
                            if (productProvider
                                .getCheckOutModelList.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection("Order")
                                  .add({
                                "Product": productProvider.getCheckOutModelList
                                    .map((c) => {
                                          "ProductName": c.name,
                                          "ProductPrice": c.price,
                                          "ProductQuetity": c.quentity,
                                          "ProductImage": c.image,
                                          "Product Color": c.color,
                                          "Product Size": c.size,
                                        })
                                    .toList(),
                                "TotalPrice": total.toStringAsFixed(2),
                                "UserName": e.userName,
                                "UserEmail": e.userEmail,
                                "UserNumber": e.userPhoneNumber,
                                "UserAddress": e.userAddress,
                                "UserId": user.uid,
                              });
                              setState(() {
                                myList.clear();
                              });

                              productProvider.addNotification("Notification");
                            } else {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("No Item Yet"),
                                ),
                              );
                            }
                          },
                        ),
                        ESewaPaymentButton(
                          this._esewaPnp,
                          color:Color(0xff746bc9),
                          amount: 100.00,
                          callBackURL: "https://example.com",
                          productId: "abc123",
                          productName: "Flutter SDK Example",
                          onSuccess: (result) {
                           if (productProvider
                                .getCheckOutModelList.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection("Order")
                                  .add({
                                "Product": productProvider.getCheckOutModelList
                                    .map((c) => {
                                          "ProductName": c.name,
                                          "ProductPrice": c.price,
                                          "ProductQuetity": c.quentity,
                                          "ProductImage": c.image,
                                          "Product Color": c.color,
                                          "Product Size": c.size,
                                        })
                                    .toList(),
                                "TotalPrice": total.toStringAsFixed(2),
                                "UserName": e.userName,
                                "UserEmail": e.userEmail,
                                "UserNumber": e.userPhoneNumber,
                                "UserAddress": e.userAddress,
                                "UserId": user.uid,
                              });
                              setState(() {
                                myList.clear();
                              });

                              productProvider.addNotification("Notification");
                            } else {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("No Item Yet"),
                                ),
                              );
                            }
                          },
                          onFailure: (e) {
                            print('Payment failed');
                          },
                        )
                      ],
                    );
                  });
            },
            child: Text('Payment'),
          )

          // ESewaPaymentButton(
          //       this._esewaPnp,
          //         amount: 100.00,
          //         callBackURL: "https://example.com",
          //         productId: "abc123",
          //         productName: "Flutter SDK Example",
          //         onSuccess: (result) {
          //          print('Payment Success');
          //         },
          //         onFailure: (e) {
          //           print('Payment failed');
          //         },
          //       )
          // child: MyButton(
          //   name: "Buy",
          //   onPressed: () {
          //     // if (productProvider.getCheckOutModelList.isNotEmpty) {
          //     //   FirebaseFirestore.instance.collection("Order").add({
          //     //     "Product": productProvider.getCheckOutModelList
          //     //         .map((c) => {
          //     //               "ProductName": c.name,
          //     //               "ProductPrice": c.price,
          //     //               "ProductQuetity": c.quentity,
          //     //               "ProductImage": c.image,
          //     //               "Product Color": c.color,
          //     //               "Product Size": c.size,
          //     //             })
          //     //         .toList(),
          //     //     "TotalPrice": total.toStringAsFixed(2),
          //     //     "UserName": e.userName,
          //     //     "UserEmail": e.userEmail,
          //     //     "UserNumber": e.userPhoneNumber,
          //     //     "UserAddress": e.userAddress,
          //     //     "UserId": user.uid,
          //     //   });
          //     //   setState(() {
          //     //     myList.clear();
          //     //   });

          //     //   productProvider.addNotification("Notification");
          //     // } else {
          //     //   _scaffoldKey.currentState.showSnackBar(
          //     //     SnackBar(
          //     //       content: Text("No Item Yet"),
          //     //     ),
          //     //   );
          //     // }
          //   },
          // ),
          );
    }).toList());
  }

  ESewaPnp _esewaPnp;
  ESewaConfiguration _configuration;
  @override
  void initState() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    myList = productProvider.checkOutModelList;
    super.initState();
    _configuration = ESewaConfiguration(
      clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      environment: ESewaConfiguration.ENVIRONMENT_TEST,
    );
    _esewaPnp = ESewaPnp(configuration: _configuration);
  }

  double _amount = 0;

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    double subTotal = 0;
    double discount = 3;
    double discountRupees;
    double shipping = 60;

    productProvider = Provider.of<ProductProvider>(context);
    productProvider.getCheckOutModelList.forEach((element) {
      subTotal += element.price * element.quentity;
    });

    discountRupees = discount / 100 * subTotal;
    total = subTotal + shipping - discountRupees;
    if (productProvider.checkOutModelList.isEmpty) {
      total = 0.0;
      discount = 0.0;
      shipping = 0.0;
    }

    return WillPopScope(
      onWillPop: () async {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomePage(),
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("CheckOut Page", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => HomePage(),
                ),
              );
            },
          ),
          actions: <Widget>[
            NotificationButton(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          width: 100,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(bottom: 15),
          child: _buildButton(),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: ListView.builder(
                    itemCount: myList.length,
                    itemBuilder: (ctx, myIndex) {
                      return CheckOutSingleProduct(
                        index: myIndex,
                        color: myList[myIndex].color,
                        size: myList[myIndex].size,
                        image: myList[myIndex].image,
                        name: myList[myIndex].name,
                        price: myList[myIndex].price,
                        quentity: myList[myIndex].quentity,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildBottomSingleDetail(
                        startName: "Subtotal",
                        endName: "\$ ${subTotal.toStringAsFixed(2)}",
                      ),
                      _buildBottomSingleDetail(
                        startName: "Discount",
                        endName: "${discount.toStringAsFixed(2)}%",
                      ),
                      _buildBottomSingleDetail(
                        startName: "Shipping",
                        endName: "\$ ${shipping.toStringAsFixed(2)}",
                      ),
                      _buildBottomSingleDetail(
                        startName: "Total",
                        endName: "\$ ${total.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// _initPayment(Map<String,dynamic> product) async{
  
//   ESewaConfiguration _configuration = ESewaConfiguration(clientID: 'clientID', secretKey: 'secretKey', environment: ESewaConfiguration.ENVIRONMENT_TEST);
//   ESewaPnp _esewaPnp = ESewaPnp(configuration: _configuration);
//   ESewaPayment _payment = ESewaPayment(amount: 100.0, productName: 'productName', productID: '12345', callBackURL: 'htttps://example.com');

//  ESewaPaymentButton(
//               ESewaPnp(configuration: _configuration),
//                 amount: 100.00,
//                 callBackURL: "https://example.com",
//                 productId: "abc123",
//                 productName: "Flutter SDK Example",
//                 onSuccess: (result) {
                  
//                 },
//                 onFailure: (e) {
                 
//                 },
//               );
// }
