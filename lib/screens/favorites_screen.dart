import 'package:flutter/material.dart';

import '../models/learning_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.cards,
    required this.onOpenCard,
  });

  final List<LearningCard> cards;
  final ValueChanged<LearningCard> onOpenCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏')),
      body: cards.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('还没有收藏的表达。'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return ListTile(
                  title: Text(card.answer),
                  subtitle: Text(card.promptZh),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onOpenCard(card),
                );
              },
            ),
    );
  }
}
