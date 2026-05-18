class ApiWatchModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;

  ApiWatchModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  factory ApiWatchModel.fromJson(Map<String, dynamic> json) {
    return ApiWatchModel(
      id: json['id'],

      title: json['title'],

      price: (json['price'] as num).toDouble(),

      description: json['description'],

      image: json['image'],
    );
  }
}
