class Deck {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> cardIds;
  final bool enabled;

  const Deck({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.cardIds,
    this.enabled = true,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: (json['description'] as String?) ?? '',
      cardIds: List<String>.from(json['cardIds'] as List? ?? const []),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'cardIds': cardIds,
      'enabled': enabled,
    };
  }
}
