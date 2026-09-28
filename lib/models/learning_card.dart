class LearningCard {
  final String id;
  final String deckId;
  final String cluster;
  final String scene;
  final String level;
  final String promptZh;
  final String sentence;
  final String answer;
  final List<String> acceptedAnswers;
  final String imageAsset;
  final String audioAsset;

  const LearningCard({
    required this.id,
    required this.deckId,
    required this.cluster,
    required this.scene,
    required this.level,
    required this.promptZh,
    required this.sentence,
    required this.answer,
    required this.acceptedAnswers,
    required this.imageAsset,
    required this.audioAsset,
  });

  factory LearningCard.fromJson(Map<String, dynamic> json) {
    return LearningCard(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      cluster: json['cluster'] as String,
      scene: json['scene'] as String,
      level: json['level'] as String,
      promptZh: json['promptZh'] as String,
      sentence: json['sentence'] as String,
      answer: json['answer'] as String,
      acceptedAnswers: List<String>.from(json['acceptedAnswers'] as List? ?? const []),
      imageAsset: (json['imageAsset'] as String?) ?? 'assets/images/placeholder.png',
      audioAsset: (json['audioAsset'] as String?) ?? 'assets/audio/placeholder.mp3',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId,
      'cluster': cluster,
      'scene': scene,
      'level': level,
      'promptZh': promptZh,
      'sentence': sentence,
      'answer': answer,
      'acceptedAnswers': acceptedAnswers,
      'imageAsset': imageAsset,
      'audioAsset': audioAsset,
    };
  }

  static String normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s\u3000]'), '')
        .replaceAll('。', '')
        .replaceAll('、', '')
        .replaceAll('！', '')
        .replaceAll('？', '');
  }

  bool matchesAnswer(String answerText) {
    final normalizedInput = normalize(answerText);
    final normalizedAnswer = normalize(answer);
    if (normalizedInput == normalizedAnswer) {
      return true;
    }
    for (final alternative in acceptedAnswers) {
      if (normalize(alternative) == normalizedInput) {
        return true;
      }
    }
    return false;
  }
}
