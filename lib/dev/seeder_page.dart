import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductSeeder {
  final FirebaseFirestore _firestore;

  ProductSeeder(this._firestore);

  final List<Map<String, dynamic>> _productData = [
    {
      "id": "product1",
      "name": "Nike Air Max Running Shoes",
      "description": "Premium running shoes with air cushioning technology",
      "price": 1999000,
      "category": "Shoes",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_1280.jpg",
      "stock": 50,
      "rating": 4.5
    },
    {
      "id": "product2",
      "name": "Classic Leather Backpack",
      "description": "Stylish and durable leather backpack for everyday use",
      "price": 1199000,
      "category": "Bags",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_1280.jpg",
      "stock": 30,
      "rating": 4.2
    },
    {
      "id": "product3",
      "name": "Wireless Bluetooth Headphones",
      "description": "High-quality wireless headphones with noise cancellation",
      "price": 2299000,
      "category": "Electronics",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2018/09/17/14/27/headphones-3683983_1280.jpg",
      "stock": 25,
      "rating": 4.8
    },
    {
      "id": "product4",
      "name": "Smart Fitness Watch",
      "description": "Track your fitness goals with this advanced smartwatch",
      "price": 2999000,
      "category": "Electronics",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2015/02/02/11/08/office-620817_1280.jpg",
      "stock": 20,
      "rating": 4.9
    },
    {
      "id": "product5",
      "name": "Organic Cotton T-Shirt",
      "description": "Comfortable and eco-friendly cotton t-shirt",
      "price": 399000,
      "category": "Clothing",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2016/11/23/06/57/isolated-t-shirt-1852114_1280.png",
      "stock": 100,
      "rating": 4.0
    },
    {
      "id": "product6",
      "name": "Stainless Steel Water Bottle",
      "description": "Durable water bottle for your daily hydration needs",
      "price": 299000,
      "category": "Accessories",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2015/02/02/11/09/office-620822_1280.jpg",
      "stock": 75,
      "rating": 4.3
    },
    {
      "id": "product7",
      "name": "Yoga Mat",
      "description": "Non-slip yoga mat for your workout sessions",
      "price": 499000,
      "category": "Sports",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_1280.jpg",
      "stock": 40,
      "rating": 4.6
    },
    {
      "id": "product8",
      "name": "Smartphone Camera Lens Kit",
      "description": "Professional camera lens attachments for your smartphone",
      "price": 699000,
      "category": "Electronics",
      "imageUrl":
          "https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_1280.jpg",
      "stock": 15,
      "rating": 4.7
    }
  ];

  Future<void> seedProducts() async {
    try {
      // Create batch
      final batch = _firestore.batch();

      // Add each product to batch
      for (final product in _productData) {
        final docRef = _firestore.collection('products').doc(product['id']);
        batch.set(docRef, {
          ...product,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Commit the batch
      await batch.commit();
      if (kDebugMode) {
        print('Successfully seeded ${_productData.length} products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error seeding products: $e');
      }
      rethrow;
    }
  }

  Future<void> clearProducts() async {
    try {
      // Get all products
      final snapshot = await _firestore.collection('products').get();

      // Create batch
      final batch = _firestore.batch();

      // Add delete operation for each document to batch
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }
}

// Usage example in a Flutter widget
class SeedDataPage extends StatelessWidget {
  const SeedDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final seeder = ProductSeeder(FirebaseFirestore.instance);
                  await seeder.seedProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Products seeded successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error seeding products'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Seed Products'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final seeder = ProductSeeder(FirebaseFirestore.instance);
                  await seeder.clearProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Products cleared successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error clearing products'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Clear Products'),
            ),
          ],
        ),
      ),
    );
  }
}
