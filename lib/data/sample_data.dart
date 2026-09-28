import '../models/deck.dart';
import '../models/learning_card.dart';

final List<Deck> sampleDecks = [
  const Deck(
    id: 'daily_home',
    name: '日常生活・家里',
    category: '日常生活',
    description: '家里、天气和日常动作的表达。',
    cardIds: ['home_001', 'home_002', 'home_003'],
  ),
  const Deck(
    id: 'daily_store',
    name: '超市',
    category: '日常生活',
    description: '超市购物中的常用日语表达。',
    cardIds: ['store_001', 'store_002'],
  ),
  const Deck(
    id: 'jlpt_n3',
    name: 'JLPT N3',
    category: 'JLPT',
    description: '适合中级表达与日常情境。',
    cardIds: ['home_001', 'store_001'],
  ),
];

final List<LearningCard> sampleCards = [
  const LearningCard(
    id: 'home_001',
    deckId: 'daily_home',
    cluster: 'ice_melting',
    scene: 'home',
    level: 'N3',
    promptZh: '冰化了',
    sentence: '氷が＿',
    answer: '氷が溶けた',
    acceptedAnswers: ['氷が溶けた', '溶けた'],
    imageAsset: 'assets/images/placeholder.png',
    audioAsset: 'assets/audio/placeholder.mp3',
  ),
  const LearningCard(
    id: 'home_002',
    deckId: 'daily_home',
    cluster: 'room_cleaning',
    scene: 'home',
    level: 'N5',
    promptZh: '房间整理好了',
    sentence: '部屋を＿',
    answer: '部屋を片付けた',
    acceptedAnswers: ['部屋を片付けた', '片付けた'],
    imageAsset: 'assets/images/placeholder.png',
    audioAsset: 'assets/audio/placeholder.mp3',
  ),
  const LearningCard(
    id: 'home_003',
    deckId: 'daily_home',
    cluster: 'rainy_day',
    scene: 'home',
    level: 'N5',
    promptZh: '外面开始下雨了',
    sentence: '外が＿',
    answer: '外が雨で濡れた',
    acceptedAnswers: ['外が雨で濡れた', '雨が降ってきた', '雨が降っている'],
    imageAsset: 'assets/images/placeholder.png',
    audioAsset: 'assets/audio/placeholder.mp3',
  ),
  const LearningCard(
    id: 'store_001',
    deckId: 'daily_store',
    cluster: 'shopping',
    scene: 'store',
    level: 'N5',
    promptZh: '请问这个多少钱？',
    sentence: 'この商品は＿',
    answer: 'この商品はいくらですか',
    acceptedAnswers: ['この商品はいくらですか', 'いくらですか'],
    imageAsset: 'assets/images/placeholder.png',
    audioAsset: 'assets/audio/placeholder.mp3',
  ),
  const LearningCard(
    id: 'store_002',
    deckId: 'daily_store',
    cluster: 'checkout',
    scene: 'store',
    level: 'N4',
    promptZh: '我先用信用卡支付',
    sentence: 'カードで＿',
    answer: 'カードで支払います',
    acceptedAnswers: ['カードで支払います', '支払います'],
    imageAsset: 'assets/images/placeholder.png',
    audioAsset: 'assets/audio/placeholder.mp3',
  ),
];

List<LearningCard> cardsForDeck(String deckId) {
  final deck = sampleDecks.firstWhere(
    (element) => element.id == deckId,
    orElse: () => sampleDecks.first,
  );
  return sampleCards
      .where((card) => deck.cardIds.contains(card.id))
      .toList();
}
