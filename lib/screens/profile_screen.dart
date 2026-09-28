import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileChanged,
  });

  final UserProfile profile;
  final ValueChanged<UserProfile> onProfileChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '当前水平',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: profile.level ?? 'N3',
              items: const [
                DropdownMenuItem(value: 'N5', child: Text('N5')),
                DropdownMenuItem(value: 'N4', child: Text('N4')),
                DropdownMenuItem(value: 'N3', child: Text('N3')),
                DropdownMenuItem(value: 'N2', child: Text('N2')),
                DropdownMenuItem(value: 'N1', child: Text('N1')),
              ],
              onChanged: (level) {
                if (level != null) {
                  onProfileChanged(profile.copyWith(level: level));
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '每日目标',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 10, label: Text('10')),
                ButtonSegment(value: 20, label: Text('20')),
                ButtonSegment(value: 30, label: Text('30')),
                ButtonSegment(value: 50, label: Text('50')),
              ],
              selected: {profile.dailyTarget},
              onSelectionChanged: (newSelection) {
                final target = newSelection.first;
                onProfileChanged(profile.copyWith(dailyTarget: target));
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '学习统计',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text('今日完成：8 / ${profile.dailyTarget}'),
          ],
        ),
      ),
    );
  }
}
