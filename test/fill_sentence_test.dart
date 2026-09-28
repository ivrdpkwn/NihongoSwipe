import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nihongo_swipe/screens/learning_screen.dart';
import 'package:nihongo_swipe/data/sample_data.dart';
import 'package:nihongo_swipe/models/user_profile.dart';
import 'package:nihongo_swipe/models/learning_card.dart';

void main() {
  testWidgets('filled sentence shows answer after correct response', (tester) async {
    final deck = sampleDecks.first;
    final cards = sampleCards.where((c) => c.deckId == deck.id).toList();

    // Use the first card which has sentence with a placeholder.
    final card = cards.firstWhere((c) => c.sentence.contains('＿') || c.sentence.contains('_'));

    await tester.pumpWidget(MaterialApp(
      home: LearningScreen(
        deck: deck,
        cards: cards,
        profile: const UserProfile(level: 'N3', onboardingCompleted: true),
        onProfileUpdated: (_) {},
      ),
    ));

    // Ensure initial sentence shows placeholder
    expect(find.textContaining('＿'), findsWidgets);

    // Tap the mic (simulate speech/accept)
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    // After answering, the sentence should include the full answer text
    expect(find.textContaining(card.answer), findsWidgets);
  });
}
