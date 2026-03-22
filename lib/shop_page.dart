import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/acount_page.dart';
import 'package:shopping_app/cart_page.dart';
import 'package:shopping_app/favourit.dart';
import 'package:shopping_app/favourites.dart';
import 'package:shopping_app/language_provider.dart';
import 'package:shopping_app/shoes.dart';
import 'package:shopping_app/sidebar_drawer.dart';
import 'my_searc_delegate.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/show_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<StatefulWidget> createState() => _ShopPageState();
}

int currentIndex = 0;

class _ShopPageState extends State<ShopPage> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouriteProvider>(
        context,
        listen: false,
      ).fetchFavouriteFromFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    final List<Widget> pages = [
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                lang.translate(
                  'لا توجد منتجات حاليا',
                  'There is no products now',
                ),
              ),
            );
          }
          final docs = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.5,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              final favProvider = Provider.of<FavouriteProvider>(
                context,
                listen: false,
              );
              bool isSaved = favProvider.favouriteItems.any(
                (element) => element.name == data['name'],
              );
              Shoes currentShoe = Shoes(
                name: data['name'] ?? '',
                price: (data['price'] ?? 0.0).toDouble(),
                discription: data['discription'] ?? '',
                image: data['main_image'] ?? '',
                rating: (data['rating'] ?? 0.0).toDouble(),
                isFavourite: isSaved,
                isCart: data['is_cart'] ?? false,
              );
              return ShowCard(shoe: currentShoe);
            },
          );
        },
      ),
      FavouritePage(),
      CartPage(),
      AcountPage(userId: FirebaseAuth.instance.currentUser!.uid),
    ];

    return Scaffold(
      key: scaffoldkey,
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            scaffoldkey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.white, size: 35),
        ),
        title: Row(
          children: [
            Icon(Icons.shopping_cart_outlined, size: 35, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Step_Up_Shop',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
            icon: Icon(Icons.search, size: 30, color: Colors.white),
          ),
        ],
      ),
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2),
            label: lang.translate('المتجر', 'shop'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: lang.translate('المفضلة', 'Favourite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: lang.translate('السلة', 'Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: lang.translate('حسابي', 'My Account'),
          ),
        ],
      ),
    );
  }
}
