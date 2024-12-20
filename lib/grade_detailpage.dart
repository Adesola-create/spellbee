import 'package:WordPro/constants.dart';
import 'package:WordPro/spell_grade.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class GradeDetailPage extends StatefulWidget {
  final String grade;
  final String imagePath;
  final String price;
  final String description;
  final String productid;

  const GradeDetailPage({
    super.key,
    required this.grade,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.productid,
  });

  @override
  _GradeDetailPageState createState() => _GradeDetailPageState();
}

class _GradeDetailPageState extends State<GradeDetailPage> {
  late InAppPurchase _inAppPurchase;
  late StreamSubscription<List<PurchaseDetails>> _purchaseUpdatedSubscription;
  //bool _isAvailable = false;
  List<ProductDetails> _products = [];
  String _productPrice = '';
  String _currencyCode = '';

  @override
  void initState() {
    super.initState();
    _inAppPurchase = InAppPurchase.instance;
    _purchaseUpdatedSubscription =
        _inAppPurchase.purchaseStream.listen(_purchaseUpdated);
    _initializeInAppPurchase();
  }

  void _initializeInAppPurchase() async {
    //  final bool available = await _inAppPurchase.isAvailable();
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails([widget.productid].toSet());

    setState(() {
      // _isAvailable = available;
      _products = response.productDetails;
      _productPrice = _products.first.price;
      _currencyCode = _products.first.currencyCode;
    });
  }

  void _purchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // If the purchase is successful, deliver the purchase and call deliverPurchase()
        await deliverPurchase();
        _inAppPurchase
            .completePurchase(purchaseDetails); // Mark purchase as complete
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending purchase if necessary

        print("Purchase is pending...");
      }

      // Handle errors in purchases
      if (purchaseDetails.error != null) {
        print("Purchase failed: ${purchaseDetails.error?.message}");
        // You can show an error message to the user
      }
    }
  }

  String calculateDiscountPrice(
      String productPrice, double discountPercentage) {
    // Remove any currency symbols and commas from the string
    String strippedPrice = productPrice.replaceAll(RegExp(r'[^0-9.]'), '');

    // Convert the stripped string to a double
    double price = double.tryParse(strippedPrice) ?? 0.0;

    // Calculate the discount
    double discount = price * (discountPercentage / 100);

    // Calculate the discounted price
    double discountedPrice = price + discount;
    final formatter = NumberFormat("#,##0.00");
    return formatter.format(discountedPrice);
  }

  Future<void> deliverPurchase() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final url = Uri.parse('https://spellbee.braveiq.net/v1/purchased');
    final body = {
      'grade': widget.grade,
      'purchased': 'true',
      'userid': userId,
    };

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        //navigate to exercise page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpellGradePage(),
          ),
        );
      } else {
        // Handle error here
      }
    } catch (e) {
      // Handle network or other errors
    }
  }

  @override
  void dispose() {
    _purchaseUpdatedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double originalPrice = double.parse(widget.price); // Original price
    double discountPercentage = 25.0; // Discount percentage

    // double discountPrice = originalPrice - (originalPrice * discountPercentage / 100);

    String discountPrice =
        calculateDiscountPrice(_productPrice, discountPercentage);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _productPrice,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '$_currencyCode $discountPrice',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white,
                  ),
                ),
                trailing: Text(
                  '$discountPercentage%',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.grade} Resources',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'This grade features:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '- Over 1,000 English learning words\n'
                    '- Suitable for vocabulary development\n'
                    '- Word mastery for everyday usage\n'
                    '- Spelling Bee competition preparatory',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () async {
            final ProductDetailsResponse response = await _inAppPurchase
                .queryProductDetails([widget.productid].toSet());
            if (response.productDetails.isNotEmpty) {
              final ProductDetails productDetails =
                  response.productDetails.first;
              final PurchaseParam purchaseParam =
                  PurchaseParam(productDetails: productDetails);
              _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
              // print('The new price is ${productDetails.price}');
            } else {
              print("Product not available");
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 60),
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Buy Now ',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
