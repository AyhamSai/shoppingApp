import 'package:flutter/material.dart';
import 'package:shopping_app/shoes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider with ChangeNotifier {
  bool isLoading = false;
  final List<Shoes> items = [];
  String? currentOrderId;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get userCart =>
      firestore.collection('users').doc(userId).collection('cart');

  void addToCart(Shoes shoe) async {
    items.add(shoe);
    notifyListeners();
    if (userId != null) {
      await userCart.doc(shoe.name).set({
        'name': shoe.name,
        'price': shoe.price,
        'image': shoe.image,
        'discription': shoe.discription,
        'rating': shoe.rating,
      });
    }
  }

  void removeFromCart(Shoes shoe) async {
    items.remove(shoe);
    notifyListeners();

    if (userId != null) {
      await userCart.doc(shoe.name).delete();
    }
  }

  Future<void> fetchCartFromFirebase() async {
    isLoading = true;
    notifyListeners();

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await userCart.get();

      items.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        double productPrice = double.tryParse(data['price'].toString()) ?? 0.0;
        items.add(
          Shoes(
            name: data['name']?.toString() ?? 'No Name',
            price: productPrice,
            image: data['image'] ?? '',
            discription: data['discription'] ?? '',
            rating: data['rating'] ?? 0,
          ),
        );
      }
      isLoading = false;
      notifyListeners();
      print("number : ${snapshot.docs.length}");
    } catch (e) {
      print("error fetching cart : $e");
    }
  }

  List<Shoes> getCartItems() {
    return items;
  }

  double getTotalPrice() {
    double total = 0;
    for (var shoe in items) {
      total += shoe.price;
    }
    return total;
  }

  Future<void> clearCart() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    }
    items.clear();
    notifyListeners();
  }

  void toggleCartState(Shoes shoe) {
    int index = items.indexWhere((item) => item.name == shoe.name);
    if (index != -1) items[index].isCart = !items[index].isCart;
    notifyListeners();
  }

  Stream<List<Shoes>> getCartStreams() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            var data = doc.data();
            return Shoes(
              name: data['name'] ?? '',
              price: (data['price'] ?? 0.0).toDouble(),
              discription: data['discription'] ?? '',
              image: data['image'] ?? '',
              rating: (data['rating'] ?? 0.0).toDouble(),
              isCart: true,
            );
          }).toList();
        });
  }
}
