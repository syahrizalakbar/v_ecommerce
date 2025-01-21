import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:v_kommerce/views/cart/cart_item.dart';
import 'package:v_kommerce/views/cart/checkout_summary.dart';
import 'package:v_kommerce/views/shipping_address/shipping_address_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(user?.uid)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final total = snapshot.data!.docs.fold<double>(
            0,
            (dynamic sum, item) => sum + (item['price'] * item['quantity']),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index];
                    return CartItem(item: item);
                  },
                ),
              ),
              CheckoutSummary(
                total: total,
                onCheckout: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShippingAddressPage(total: total),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
