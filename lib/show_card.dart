import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/carts.dart';
import 'package:shopping_app/favourites.dart';
import 'package:shopping_app/shoes.dart';
import 'language_provider.dart';

class ShowCard extends StatefulWidget {
  final Shoes shoe;
  final bool isCartPage;
  const ShowCard({super.key, required this.shoe, this.isCartPage = false});

  @override
  State<ShowCard> createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  color: Colors.blue,
                  child: Text(
                    widget.shoe.rating.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (!widget.isCartPage)
                  Consumer<FavouriteProvider>(
                    builder: (context, favouriteProvider, child) {
                      return IconButton(
                        onPressed: () {
                          favouriteProvider.toggleFavouriteState(widget.shoe);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.shoe.isFavourite
                                    ? lang.translate(
                                        'أضيفت للمفضلة',
                                        'added to favourite',
                                      )
                                    : lang.translate(
                                        'حذفت من المفضلة',
                                        'deleted from favourit',
                                      ),
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: Icon(
                          widget.shoe.isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.shoe.isFavourite
                              ? Colors.red
                              : Colors.grey,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.shoe.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingPrograss) {
                  if (loadingPrograss == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image_sharp, size: 100),
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(
                  widget.shoe.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.shoe.discription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.shoe.price}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!widget.isCartPage)
                      TextButton(
                        onPressed: () {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).addToCart(widget.shoe);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                lang.translate('أضيفت للسلة', 'Added to Cart'),
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          lang.translate('إضافة إلى السلة', 'Add to Cart'),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                if (widget.isCartPage)
                  IconButton(
                    onPressed: () {
                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).removeFromCart(widget.shoe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            lang.translate(
                              'حذفت من السلة',
                              'Removed from Cart',
                            ),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
