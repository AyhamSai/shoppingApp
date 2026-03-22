import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/favourites.dart';
import 'package:shopping_app/shoes.dart';
import 'package:shopping_app/show_card.dart';

import 'language_provider.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          lang.translate('المفضلة', "Favourite"),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Icon(Icons.favorite, color: Colors.white),
      ),
      body: StreamBuilder<List<Shoes>>(
        stream: Provider.of<FavouriteProvider>(
          context,
          listen: false,
        ).getfavouritesStreams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                lang.translate(
                  'قائمة المفضلة فارغة',
                  'Favourite Page is Empty',
                ),
              ),
            );
          }
          final favouriteItems = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.5,
            ),
            itemCount: favouriteItems.length,
            itemBuilder: (context, index) {
              return ShowCard(shoe: favouriteItems[index]);
            },
          );
        },
      ),
    );
  }
}
