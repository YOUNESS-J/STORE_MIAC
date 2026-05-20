class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;
  final String description;
  final bool isOrganic;
  final bool isLimited;
  final Map<String, String>? specs;
  final String region;
  final double rating; 

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.description,
    this.isOrganic = false,
    this.isLimited = false,
    this.specs,
    this.region = 'Marrakech', 
    this.rating = 4.5,
  });
}