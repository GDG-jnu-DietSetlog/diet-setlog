import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_typography.dart';

/// Wave 1 골격용 임시 화면. 후속 wave 에서 실제 화면으로 교체된다.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSheet,
      body: Center(
        child: Text('$title\n(구현 예정)',
            textAlign: TextAlign.center,
            style: AppType.body(color: AppColors.text82)),
      ),
    );
  }
}
