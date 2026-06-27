import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diet_setlog/design/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders label and fires onPressed',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: PrimaryButton(label: '다음', onPressed: () => tapped = true),
          ),
        ),
      ),
    );
    expect(find.text('다음'), findsOneWidget);
    await tester.tap(find.text('다음'));
    expect(tapped, isTrue);
  });
}
