import 'package:flutter/material.dart';
import 'package:v_kommerce/views/bank_transfer/bank_transfer_page.dart';
import 'package:v_kommerce/views/payment_method/payment_method_card.dart';

class PaymentMethodPage extends StatelessWidget {
  final double total;
  final Map<String, String> address;

  const PaymentMethodPage(
      {super.key, required this.total, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Select Payment Method',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          PaymentMethodCard(
            title: 'Bank Transfer',
            subtitle: 'Transfer to our bank account',
            icon: Icons.account_balance,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BankTransferPage(
                  total: total,
                  address: address,
                ),
              ),
            ),
          ),
          PaymentMethodCard(
            title: 'Credit Card',
            subtitle: 'Pay with Visa/Mastercard',
            icon: Icons.credit_card,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Credit Card payment coming soon')),
              );
            },
          ),
          PaymentMethodCard(
            title: 'E-Wallet',
            subtitle: 'Pay with digital wallet',
            icon: Icons.account_balance_wallet,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('E-Wallet payment coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}
