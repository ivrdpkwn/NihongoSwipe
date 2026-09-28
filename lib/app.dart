import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/sample_data.dart';
import 'models/deck.dart';
import 'models/user_profile.dart';
import 'screens/deck_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'services/storage_service.dart';
import 'services/deck_repository.dart';
import 'theme/app_theme.dart';

export 'screens/deck_list_screen.dart';
export 'screens/favorites_screen.dart';
export 'screens/home_screen.dart';
export 'screens/learning_screen.dart';
export 'screens/onboarding_screen.dart';
export 'screens/profile_screen.dart';

class NihongoSwipeApp extends StatelessWidget {
  const NihongoSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日语唰唰唰',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late StorageService _storage;
  final DeckRepository _repo = DeckRepository();
  UserProfile _profile = const UserProfile();
  bool _isLoading = true;
  int _selectedIndex = 0;
  List<Deck> _decks = sampleDecks;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _storage = StorageService(prefs);
    final profile = await _storage.loadUserProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      _profile = profile;
      _isLoading = false;
    });

    // Load decks in background; do not block initial rendering (helps tests)
    _repo.loadDeckList().then((decks) {
      if (!mounted) return;
      if (decks.isNotEmpty) {
        setState(() {
          _decks = decks;
        });
      }
    });
  }

  void _saveProfile(UserProfile profile) {
    _profile = profile;
    _storage.saveUserProfile(profile);
    setState(() {});
  }

  Future<void> _startPracticeForDeck(Deck deck) async {
    var deckCards = await _repo.loadCardsForDeck(deck.id);

    if (deckCards.isEmpty) {
      // fallback to built-in sample data for tests / local dev
      deckCards = cardsForDeck(deck.id);
    }

    if (deckCards.isEmpty) {
      return;
    }

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LearningScreen(
          deck: deck,
          cards: deckCards,
          profile: _profile,
          onProfileUpdated: _saveProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile.level == null || !_profile.onboardingCompleted) {
      return OnboardingScreen(
        onComplete: (level) {
          final updatedProfile = _profile.copyWith(
            level: level,
            onboardingCompleted: true,
          );
          _saveProfile(updatedProfile);
        },
      );
    }

    final pages = <Widget>[
      HomeScreen(
        profile: _profile,
        decks: _decks,
        onStartPractice: () => _startPracticeForDeck(
          _decks.firstWhere(
            (deck) => deck.id == (_profile.currentDeckId ?? _decks.first.id),
            orElse: () => _decks.first,
          ),
        ),
        onOpenDecks: () => setState(() => _selectedIndex = 1),
      ),
      DeckListScreen(
        decks: _decks,
        onDeckSelected: _startPracticeForDeck,
      ),
      FavoritesScreen(
        cards: sampleCards
            .where((card) => _profile.favorites.contains(card.id))
            .toList(),
        onOpenCard: (card) {
          final deck = sampleDecks.firstWhere(
            (item) => item.id == card.deckId,
            orElse: () => sampleDecks.first,
          );
          _startPracticeForDeck(deck);
        },
      ),
      ProfileScreen(
        profile: _profile,
        onProfileChanged: _saveProfile,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.style_outlined), label: '牌组'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}