class Shoes {
  final String name;
  final double price;
  final String discription;
  final String image;
  final double rating;
  bool isFavourite;
  bool isCart;

  Shoes({
    required this.name,
    required this.price,
    required this.discription,
    required this.image,
    required this.rating,
    this.isFavourite = false,
    this.isCart = false
  });
}
