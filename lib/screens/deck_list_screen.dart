import 'package:flutter/material.dart';

import '../models/deck.dart';

class DeckListScreen extends StatelessWidget {
  const DeckListScreen({
    super.key,
    required this.decks,
    required this.onDeckSelected,
  });

  final List<Deck> decks;
  final ValueChanged<Deck> onDeckSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('牌组')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: decks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final deck = decks[index];
          return Card(
            child: ListTile(
              title: Text(deck.name),
              subtitle: Text(deck.description),
              trailing: const Icon(Icons.play_arrow_rounded),
              onTap: () => onDeckSelected(deck),
            ),
          );
        },
      ),
    );
  }
}
