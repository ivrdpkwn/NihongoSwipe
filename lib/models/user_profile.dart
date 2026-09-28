class UserProfile {
  final String? level;
  final int dailyTarget;
  final String? currentDeckId;
  final int currentCardIndex;
  final Set<String> favorites;
  final Map<String, int> cardProgress;
  final bool onboardingCompleted;

  const UserProfile({
    this.level,
    this.dailyTarget = 20,
    this.currentDeckId,
    this.currentCardIndex = 0,
    this.favorites = const {},
    this.cardProgress = const {},
    this.onboardingCompleted = false,
  });

  UserProfile copyWith({
    String? level,
    int? dailyTarget,
    String? currentDeckId,
    int? currentCardIndex,
    Set<String>? favorites,
    Map<String, int>? cardProgress,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      level: level ?? this.level,
      dailyTarget: dailyTarget ?? this.dailyTarget,
      currentDeckId: currentDeckId ?? this.currentDeckId,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      favorites: favorites ?? this.favorites,
      cardProgress: cardProgress ?? this.cardProgress,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'dailyTarget': dailyTarget,
      'currentDeckId': currentDeckId,
      'currentCardIndex': currentCardIndex,
      'favorites': favorites.toList(),
      'cardProgress': cardProgress,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final rawFavorites = json['favorites'] as List? ?? const <dynamic>[];
    final rawProgress = json['cardProgress'] as Map? ?? const <String, dynamic>{};

    return UserProfile(
      level: json['level'] as String?,
      dailyTarget: json['dailyTarget'] as int? ?? 20,
      currentDeckId: json['currentDeckId'] as String?,
      currentCardIndex: json['currentCardIndex'] as int? ?? 0,
      favorites: rawFavorites.map((e) => e.toString()).toSet(),
      cardProgress: rawProgress.map(
        (key, value) => MapEntry(key.toString(), (value as num).toInt()),
      ),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }
}
