import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/deck.dart';
import '../models/learning_card.dart';

class DeckRepository {
  static const _indexPath = 'assets/decks/index.json';

  Future<List<Deck>> loadDeckList() async {
    try {
      final raw = await rootBundle.loadString(_indexPath);
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Deck.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const <Deck>[];
    }
  }

  Future<List<LearningCard>> loadCardsForDeck(String deckId) async {
    final path = 'assets/decks/$deckId.json';
    try {
      final raw = await rootBundle.loadString(path);
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final cards = (map['cards'] as List<dynamic>?) ?? const <dynamic>[];
      return cards
          .map((e) => LearningCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const <LearningCard>[];
    }
  }
}
