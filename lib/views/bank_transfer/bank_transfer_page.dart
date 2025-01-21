import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_kommerce/views/bank_transfer/bank_detail.dart';
import 'package:v_kommerce/views/payment_success/payment_success_page.dart';

class BankTransferPage extends StatelessWidget {
  final double total;
  final Map<String, String> address;

  const BankTransferPage(
      {super.key, required this.total, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Account Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    const BankDetail(
                      title: 'Bank Name',
                      value: 'Example Bank',
                    ),
                    const BankDetail(
                      title: 'Account Number',
                      value: '1234567890',
                    ),
                    const BankDetail(
                      title: 'Account Name',
                      value: 'E-Commerce Store',
                    ),
                    const Divider(),
                    BankDetail(
                      title: 'Total Amount',
                      value:
                          'Rp ${NumberFormat('#,##0', 'id_ID').format(total)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Instructions:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '1. Transfer the exact amount to the bank account above\n'
              '2. Keep your transfer receipt\n'
              '3. Click the button below to confirm payment',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _confirmPayment(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('I Have Made the Transfer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPayment(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Create transaction record
      final transactionRef =
          await FirebaseFirestore.instance.collection('transactions').add({
        'userId': user.uid,
        'total': total,
        'address': address,
        'status': 'pending',
        'paymentMethod': 'bank_transfer',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear cart
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Navigate to success page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            transactionId: transactionRef.id,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to process payment')),
      );
    }
  }
}
