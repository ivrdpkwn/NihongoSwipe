import 'package:flutter/material.dart';

import '../models/deck.dart';
import '../models/learning_card.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../widgets/circle_icon_button.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({
    super.key,
    required this.deck,
    required this.cards,
    required this.profile,
    required this.onProfileUpdated,
  });

  final Deck deck;
  final List<LearningCard> cards;
  final UserProfile profile;
  final ValueChanged<UserProfile> onProfileUpdated;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late UserProfile _profile;
  late TextEditingController _answerController;

  int _index = 0;
  bool _isInputMode = false;
  double _dragY = 0;

  final Map<String, bool> _answered = {};
  final Map<String, bool> _answerResults = {};

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  LearningCard get currentCard => widget.cards[_index];

  bool get currentAnswered => _answered[currentCard.id] ?? false;

  bool get currentCorrect => _answerResults[currentCard.id] ?? false;

  void _toggleFavorite() {
    final favoriteSet = Set<String>.from(_profile.favorites);

    if (favoriteSet.contains(currentCard.id)) {
      favoriteSet.remove(currentCard.id);
    } else {
      favoriteSet.add(currentCard.id);
    }

    final updatedProfile = _profile.copyWith(favorites: favoriteSet);

    setState(() {
      _profile = updatedProfile;
    });

    widget.onProfileUpdated(updatedProfile);
  }

  void _submitAnswer() {
    final input = _answerController.text.trim();

    if (input.isEmpty || currentAnswered) {
      return;
    }

    final isCorrect = currentCard.matchesAnswer(input);

    setState(() {
      _answered[currentCard.id] = true;
      _answerResults[currentCard.id] = isCorrect;
    });

    final updatedProfile = _profile.copyWith(
      currentDeckId: widget.deck.id,
      currentCardIndex: _index,
    );

    _profile = updatedProfile;
    widget.onProfileUpdated(updatedProfile);
    _answerController.clear();
  }

  void _simulateSpeech() {
    if (currentAnswered) {
      return;
    }

    final fallback = currentCard.acceptedAnswers.isNotEmpty
        ? currentCard.acceptedAnswers.first
        : currentCard.answer;

    final isCorrect = currentCard.matchesAnswer(fallback);

    setState(() {
      _answered[currentCard.id] = true;
      _answerResults[currentCard.id] = isCorrect;
    });

    final updatedProfile = _profile.copyWith(
      currentDeckId: widget.deck.id,
      currentCardIndex: _index,
    );

    _profile = updatedProfile;
    widget.onProfileUpdated(updatedProfile);
  }

  void _goToNextCard() {
    if (_index >= widget.cards.length - 1) {
      _showFinishedDialog();
      return;
    }

    setState(() {
      _index++;
      _isInputMode = false;
      _answerController.clear();
      _dragY = 0;
    });
  }

  void _goToPreviousCard() {
    if (_index <= 0) {
      return;
    }

    setState(() {
      _index--;
      _isInputMode = false;
      _answerController.clear();
      _dragY = 0;
    });
  }

  void _handleVerticalDragEnd() {
    const threshold = 100.0;

    if (_dragY < -threshold) {
      _goToNextCard();
    } else if (_dragY > threshold) {
      _goToPreviousCard();
    }

    if (mounted) {
      setState(() {
        _dragY = 0;
      });
    }
  }

  void _showFinishedDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: const Text(
            '这一组唰完啦！',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            '你已经完成「${widget.deck.name}」的全部 ${widget.cards.length} 道题。',
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('继续查看'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 44),
              ),
              child: const Text('完成'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('这个牌组还没有题目'),
        ),
      );
    }

    final card = currentCard;
    final progress = (_index + 1) / widget.cards.length;
    final isFavorite = _profile.favorites.contains(card.id);
    String displayedSentence(LearningCard c) {
      if (!currentAnswered) return c.sentence;
      // Replace common blank characters with the full answer when answered.
      return c.sentence.replaceAll('＿', c.answer).replaceAll('_', c.answer);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.deck.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${_index + 1} / ${widget.cards.length}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: isFavorite ? AppColors.pink : AppColors.text,
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _dragY += details.delta.dy;
                  });
                },
                onVerticalDragEnd: (_) => _handleVerticalDragEnd(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(0, _dragY * 0.18, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: AppColors.background,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.image_rounded,
                                          size: 72,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Positioned(
                                        top: 16,
                                        left: 16,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.92,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            card.level,
                                            style: const TextStyle(
                                              color: AppColors.text,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      20,
                                      24,
                                      22,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          card.promptZh,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          displayedSentence(card),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppColors.text,
                                            fontSize: 32,
                                            height: 1.25,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        if (currentAnswered) ...[
                                          const SizedBox(height: 18),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 13,
                                            ),
                                            decoration: BoxDecoration(
                                              color: currentCorrect
                                                  ? AppColors.success
                                                      .withValues(alpha: 0.12)
                                                  : AppColors.error
                                                      .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  currentCorrect
                                                      ? '✓ 正确'
                                                      : '再想一下',
                                                  style: TextStyle(
                                                    color: currentCorrect
                                                        ? AppColors.success
                                                        : AppColors.error,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  card.answer,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: AppColors.text,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          flex: 3,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: _isInputMode
                                ? _buildKeyboardMode()
                                : _buildMicrophoneMode(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicrophoneMode() {
    return Stack(
      key: const ValueKey('microphone-mode'),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: currentAnswered ? null : _simulateSpeech,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: currentAnswered
                      ? AppColors.textSecondary.withValues(alpha: 0.25)
                      : AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: currentAnswered
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.24,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: const Icon(
                  Icons.mic,
                  size: 38,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              currentAnswered ? '本题已回答' : '点击麦克风回答',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isInputMode = true;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_alt_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildKeyboardMode() {
    return Stack(
      key: const ValueKey('keyboard-mode'),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _answerController,
              autofocus: true,
              enabled: !currentAnswered,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitAnswer(),
              decoration: const InputDecoration(
                hintText: '输入你要说的日语',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              '输入答案后按提交',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: currentAnswered ? null : _submitAnswer,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: currentAnswered
                      ? AppColors.textSecondary.withValues(alpha: 0.18)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  '提交',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isInputMode = false;
                    _answerController.clear();
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
