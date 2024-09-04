class Recipe {
  final String label;
  final String image;
  final String source;
  final String url;
  final List<String> ingredientLines;
  final int totalTime;

  Recipe({
    required this.label,
    required this.image,
    required this.source,
    required this.url,
    required this.ingredientLines,
    required this.totalTime,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['label'],
      image: json['image'],
      source: json['source'],
      url: json['url'],
      ingredientLines: List<String>.from(json['ingredientLines']),
      totalTime:
          (json['totalTime'] as num).toInt(), // Ensure this is cast to int
    );
  }
}
