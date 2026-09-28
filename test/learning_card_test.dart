import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nihongo_swipe/app.dart';
import 'package:nihongo_swipe/data/sample_data.dart';
import 'package:nihongo_swipe/models/user_profile.dart';
import 'package:nihongo_swipe/services/storage_service.dart';

void main() {
  test('learning card matches accepted answers', () {
    final card = sampleCards.first;

    expect(card.matchesAnswer('氷が溶けた'), isTrue);
    expect(card.matchesAnswer('溶けた'), isTrue);
    expect(card.matchesAnswer('氷が褪色了'), isFalse);
  });

  test('storage service saves and restores user profile', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = StorageService(prefs);
    const profile = UserProfile(
      level: 'N3',
      dailyTarget: 30,
      currentDeckId: 'daily_home',
      currentCardIndex: 1,
      favorites: {'home_001'},
      onboardingCompleted: true,
    );

    await service.saveUserProfile(profile);
    final loaded = await service.loadUserProfile();

    expect(loaded.level, 'N3');
    expect(loaded.dailyTarget, 30);
    expect(loaded.currentDeckId, 'daily_home');
    expect(loaded.favorites, {'home_001'});
    expect(loaded.onboardingCompleted, isTrue);
  });

  testWidgets('learning screen shows correct feedback for accepted answer', (tester) async {
    final deck = sampleDecks.first;
    final cards = sampleCards.where((card) => card.deckId == deck.id).toList();

    await tester.pumpWidget(
      MaterialApp(
        home: LearningScreen(
          deck: deck,
          cards: cards,
          profile: const UserProfile(level: 'N3', onboardingCompleted: true),
          onProfileUpdated: (_) {},
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pump();

    expect(find.text('✓ 正确'), findsOneWidget);
    expect(find.text('氷が溶けた'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
  });
}
