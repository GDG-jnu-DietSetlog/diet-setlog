import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_exception.dart';
import '../../core/providers.dart';
import '../../data/models/common.dart';
import '../../data/models/enums.dart';
import '../../data/models/record_create.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../design/widgets/calorie_chip.dart';
import '../../design/widgets/nutrition.dart';
import '../../design/widgets/primary_button.dart';
import '../../design/widgets/app_top_bar.dart';
import '../../core/date_utils.dart';
import '../../routing/route_paths.dart';
import '../calendar/calendar_providers.dart';
import '../home/home_providers.dart';
import 'record_args.dart';

/// FoodRecordEdit — 기록 작성(`1:230`). AI 결과 확인·수정 후 저장. screens.md §8.
class RecordEditScreen extends ConsumerStatefulWidget {
  const RecordEditScreen({super.key, required this.args});
  final RecordEditArgs args;

  @override
  ConsumerState<RecordEditScreen> createState() => _RecordEditScreenState();
}

class _RecordEditScreenState extends ConsumerState<RecordEditScreen> {
  late final TextEditingController _title;
  late final TextEditingController _memo;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  late final TextEditingController _total;
  late MealType _meal;
  bool _editMode = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final r = widget.args.analysis.result;
    _title = TextEditingController(text: r?.dishName ?? '');
    _memo = TextEditingController();
    _protein = TextEditingController(text: _fmt(r?.macros.proteinG ?? 0));
    _carbs = TextEditingController(text: _fmt(r?.macros.carbsG ?? 0));
    _fat = TextEditingController(text: _fmt(r?.macros.fatG ?? 0));
    _total = TextEditingController(text: (r?.totalCalories ?? 0).toString());
    _meal = _defaultMeal();
  }

  static String _fmt(num v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

  MealType _defaultMeal() {
    final h = DateTime.now().hour;
    if (h >= 4 && h <= 10) return MealType.breakfast;
    if (h >= 11 && h <= 15) return MealType.lunch;
    if (h >= 16 && h <= 21) return MealType.dinner;
    return MealType.snack;
  }

  @override
  void dispose() {
    for (final c in [_title, _memo, _protein, _carbs, _fat, _total]) {
      c.dispose();
    }
    super.dispose();
  }

  int get _kcal => int.tryParse(_total.text) ?? 0;
  bool get _valid => _title.text.trim().isNotEmpty && _kcal >= 0;

  Future<void> _submit() async {
    if (!_valid || _submitting) return;
    setState(() => _submitting = true);
    final a = widget.args.analysis;
    final req = RecordCreateRequest(
      analysisId: a.analysisId.isEmpty ? null : a.analysisId,
      mealType: _meal,
      eatenAt: DateTime.now(),
      title: _title.text.trim(),
      totalCalories: _kcal,
      macros: Macros(
        proteinG: double.tryParse(_protein.text) ?? 0,
        carbsG: double.tryParse(_carbs.text) ?? 0,
        fatG: double.tryParse(_fat.text) ?? 0,
      ),
      memo: _memo.text.trim().isEmpty ? null : _memo.text.trim(),
      items: [
        for (final it in a.result?.items ?? const [])
          ItemInput(
            name: it.name,
            amount: it.amount,
            calories: it.calories,
            proteinG: it.proteinG,
            carbsG: it.carbsG,
            fatG: it.fatG,
          ),
      ],
      publishToFeed: true,
    );
    try {
      final res = await ref.read(recordsApiProvider).create(req);
      ref.invalidate(homeProvider); // 홈 요약 갱신
      ref.invalidate(dailySummaryProvider(ymd(DateTime.now()))); // 캘린더 오늘 갱신
      if (!mounted) return;
      context.pushReplacement(Routes.uploadComplete, extra: res);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.userMessage)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppTopBar(title: '기록 작성'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _image(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('✓ AI 분석 완료',
                                style: AppType.label(
                                    color: AppColors.successText2,
                                    w: FontWeight.w600)),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _editMode = !_editMode),
                              child: Text(_editMode ? '완료' : '수정',
                                  style: AppType.caption(
                                      color: AppColors.primary)),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        _nameField(),
                        SizedBox(height: 16.h),
                        _macros(),
                        SizedBox(height: 24.h),
                        Text('끼니',
                            style: AppType.bodyBold(color: AppColors.text4D)),
                        SizedBox(height: 8.h),
                        _mealChips(),
                        SizedBox(height: 24.h),
                        Text('메모',
                            style: AppType.bodyBold(color: AppColors.text4D)),
                        SizedBox(height: 8.h),
                        _memoField(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
              child: PrimaryButton(
                label: '피드에 올리기',
                loading: _submitting,
                enabled: _valid,
                onPressed: _valid ? _submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    final path = widget.args.localPath;
    final url = widget.args.analysis.imageUrl;
    final img = path != null
        ? Image.file(File(path),
            height: 186.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(height: 186.h, color: AppColors.skeleton))
        : Image.network(url,
            height: 186.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(height: 186.h, color: AppColors.skeleton));
    return Stack(
      children: [
        img,
        Positioned(left: 18.w, bottom: -21.h, child: CalorieChip(kcal: _kcal)),
      ],
    );
  }

  Widget _nameField() {
    return TextField(
      controller: _title,
      style: AppType.appBar(),
      cursorColor: AppColors.primary,
      maxLength: 50,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        counterText: '',
        hintText: '음식명',
      ),
    );
  }

  Widget _macros() {
    if (!_editMode) {
      return Row(
        children: [
          Expanded(
              child: NutritionBox(
                  macro: Macro.protein,
                  grams: double.tryParse(_protein.text) ?? 0)),
          SizedBox(width: 17.w),
          Expanded(
              child: NutritionBox(
                  macro: Macro.carbs,
                  grams: double.tryParse(_carbs.text) ?? 0)),
          SizedBox(width: 17.w),
          Expanded(
              child: NutritionBox(
                  macro: Macro.fat, grams: double.tryParse(_fat.text) ?? 0)),
        ],
      );
    }
    return Column(
      children: [
        _editRow('총 칼로리(kcal)', _total, digitsOnly: true),
        SizedBox(height: 8.h),
        _editRow('단백질(g)', _protein),
        SizedBox(height: 8.h),
        _editRow('탄수화물(g)', _carbs),
        SizedBox(height: 8.h),
        _editRow('지방(g)', _fat),
      ],
    );
  }

  Widget _editRow(String label, TextEditingController ctrl,
      {bool digitsOnly = false}) {
    return Row(
      children: [
        Expanded(
            child: Text(label, style: AppType.body(color: AppColors.text4D))),
        SizedBox(
          width: 100.w,
          height: 40.h,
          child: TextField(
            controller: ctrl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.numberWithOptions(decimal: !digitsOnly),
            inputFormatters:
                digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
            style: AppType.value(),
            cursorColor: AppColors.primary,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.r12.r)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mealChips() {
    return Row(
      children: [
        for (final m in MealType.values) ...[
          if (m != MealType.breakfast) SizedBox(width: 8.w),
          Expanded(child: _mealChip(m)),
        ],
      ],
    );
  }

  Widget _mealChip(MealType m) {
    final selected = _meal == m;
    return GestureDetector(
      onTap: () => setState(() => _meal = m),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD0FFE4) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          border: Border.all(
              color: selected ? const Color(0xFF00C321) : AppColors.border),
        ),
        child: Text(m.labelKo,
            style: AppType.body(
                color:
                    selected ? AppColors.successText : const Color(0xFF858588),
                w: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _memoField() {
    return TextField(
      controller: _memo,
      maxLength: 200,
      maxLines: 3,
      minLines: 2,
      style: AppType.body(),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: '메모를 남겨보세요 (최대 200자)',
        hintStyle: AppType.body(color: AppColors.textC5),
        contentPadding: EdgeInsets.all(12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
