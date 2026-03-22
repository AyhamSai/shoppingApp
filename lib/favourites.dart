import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/shoes.dart';

class FavouriteProvider with ChangeNotifier {
  List<Shoes> favouriteItems = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  CollectionReference get userFavourite =>
      firestore.collection('users').doc(userId).collection('favourites');
  List<Shoes> getFavouriteItems() {
    return favouriteItems.where((shoe) => shoe.isFavourite).toList();
  }

  void toggleFavouriteState(Shoes shoe) async {
    shoe.isFavourite = !shoe.isFavourite;
    if (shoe.isFavourite) {
      favouriteItems.add(shoe);
      if (userId != null) {
        await userFavourite.doc(shoe.name).set({
          'name': shoe.name,
          'price': shoe.price.toDouble(),
          'image': shoe.image,
          'discription': shoe.discription,
          'rating': shoe.rating.toDouble(),
          'isFavourite': true,
        });
      }
    } else {
      favouriteItems.removeWhere((element) => element.name == shoe.name);
      if (userId != null) {
        await userFavourite.doc(shoe.name).delete();
      }
    }
    notifyListeners();
  }

  Future<void> fetchFavouriteFromFirebase() async {
    if (userId == null) return;
    try {
      final snapshot = await userFavourite.get();
      favouriteItems.clear();
      List<String> favNames = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'].toString();
      }).toList();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        favouriteItems.add(
          Shoes(
            name: data['name'] ?? '',
            price: double.tryParse(data['price'].toString()) ?? 0.0,
            discription: data['discription'],
            image: data['image'],
            rating: double.tryParse(data['rating'].toString()) ?? 0.0,
            isFavourite: true,
          ),
        );
      }
      for (var shoe in favouriteItems) {
        if (favNames.contains(shoe.name)) {
          shoe.isFavourite = true;
        } else {
          shoe.isFavourite = false;
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching favourites");
    }
  }

  Stream<List<Shoes>> getfavouritesStreams() {
    if (userId == null) return Stream.value([]);

    return userFavourite.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Shoes(
          name: data['name'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          discription: data['discription'] ?? '',
          image: data['image'] ?? '',
          rating: (data['rating'] ?? 0.0).toDouble(),
          isFavourite: true,
        );
      }).toList();
    });
  }
}
