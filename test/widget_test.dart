// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nihongo_swipe/app.dart';

void main() {
  testWidgets('app starts and shows onboarding before selection', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const NihongoSwipeApp());
    await tester.pumpAndSettle();

    expect(find.text('日语唰唰唰'), findsWidgets);
    expect(find.text('先选择你的日语水平，开始看图说日语。'), findsOneWidget);
  });

  testWidgets('home and deck screens render after onboarding profile is saved', (tester) async {
    SharedPreferences.setMockInitialValues({
      'user_profile': jsonEncode({
        'level': 'N3',
        'dailyTarget': 20,
        'currentDeckId': 'daily_home',
        'currentCardIndex': 0,
        'favorites': <String>[],
        'cardProgress': <String, int>{},
        'onboardingCompleted': true,
      }),
    });

    await tester.pumpWidget(const NihongoSwipeApp());
    await tester.pumpAndSettle();

    expect(find.text('今日唰唰唰'), findsOneWidget);
    expect(find.text('开始唰'), findsOneWidget);

    final deckTab = find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.text('牌组'),
    );
    await tester.tap(deckTab);
    await tester.pumpAndSettle();

    expect(find.text('日常生活・家里'), findsOneWidget);
    expect(find.text('超市'), findsOneWidget);
  });
}
