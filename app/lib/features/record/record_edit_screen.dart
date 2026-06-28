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

/// 한 음식 항목의 입력 상태(이름·탄단지). aiCalories 가 있으면 AI 분석 항목.
class _ItemFields {
  _ItemFields({
    String name = '',
    num protein = 0,
    num carbs = 0,
    num fat = 0,
    this.aiCalories,
  })  : isAi = aiCalories != null,
        name_ = TextEditingController(text: name),
        proteinC = TextEditingController(text: _fmt(protein)),
        carbsC = TextEditingController(text: _fmt(carbs)),
        fatC = TextEditingController(text: _fmt(fat));

  final bool isAi;
  final int? aiCalories;
  final TextEditingController name_;
  final TextEditingController proteinC;
  final TextEditingController carbsC;
  final TextEditingController fatC;

  double get protein => double.tryParse(proteinC.text) ?? 0;
  double get carbs => double.tryParse(carbsC.text) ?? 0;
  double get fat => double.tryParse(fatC.text) ?? 0;

  /// 항목 칼로리 — AI 항목은 분석값, 직접 입력은 Atwater(4/4/9)로 추정.
  int get calories => aiCalories ?? (protein * 4 + carbs * 4 + fat * 9).round();

  bool get hasName => name_.text.trim().isNotEmpty;

  static String _fmt(num v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

  void dispose() {
    name_.dispose();
    proteinC.dispose();
    carbsC.dispose();
    fatC.dispose();
  }
}

/// FoodRecordEdit — 기록 작성(`1:230` / 2차 `51:866`).
/// AI 분석 항목 + 직접 입력 항목(여러 개)을 한 끼니로 기록. screens.md §8.
class RecordEditScreen extends ConsumerStatefulWidget {
  const RecordEditScreen({super.key, required this.args});
  final RecordEditArgs args;

  @override
  ConsumerState<RecordEditScreen> createState() => _RecordEditScreenState();
}

class _RecordEditScreenState extends ConsumerState<RecordEditScreen> {
  final _memo = TextEditingController();
  final List<_ItemFields> _items = [];
  late MealType _meal;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final r = widget.args.analysis.result;
    if (r != null) {
      _items.add(_ItemFields(
        name: r.dishName,
        protein: r.macros.proteinG,
        carbs: r.macros.carbsG,
        fat: r.macros.fatG,
        aiCalories: r.totalCalories,
      ));
    } else {
      _items.add(_ItemFields());
    }
    _meal = _defaultMeal();
  }

  MealType _defaultMeal() {
    final h = DateTime.now().hour;
    if (h >= 4 && h <= 10) return MealType.breakfast;
    if (h >= 11 && h <= 15) return MealType.lunch;
    if (h >= 16 && h <= 21) return MealType.dinner;
    return MealType.snack;
  }

  @override
  void dispose() {
    _memo.dispose();
    for (final it in _items) {
      it.dispose();
    }
    super.dispose();
  }

  int get _totalKcal => _items.fold(0, (sum, it) => sum + it.calories);

  bool get _valid => _items.every((it) => it.hasName);

  void _addItem() {
    setState(() => _items.add(_ItemFields()));
  }

  void _removeItem(_ItemFields item) {
    setState(() {
      _items.remove(item);
      item.dispose();
    });
  }

  Future<void> _submit() async {
    if (!_valid || _submitting) return;
    setState(() => _submitting = true);
    final a = widget.args.analysis;
    final macros = Macros(
      proteinG: _items.fold<double>(0, (s, it) => s + it.protein),
      carbsG: _items.fold<double>(0, (s, it) => s + it.carbs),
      fatG: _items.fold<double>(0, (s, it) => s + it.fat),
    );
    final req = RecordCreateRequest(
      analysisId: a.analysisId.isEmpty ? null : a.analysisId,
      mealType: _meal,
      eatenAt: DateTime.now(),
      title: _items.first.name_.text.trim(),
      totalCalories: _totalKcal,
      macros: macros,
      memo: _memo.text.trim().isEmpty ? null : _memo.text.trim(),
      items: [
        for (final it in _items)
          ItemInput(
            name: it.name_.text.trim(),
            calories: it.calories,
            proteinG: it.protein,
            carbsG: it.carbs,
            fatG: it.fat,
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
      backgroundColor: AppColors.bgSheet,
      appBar: const AppTopBar(title: '기록 작성'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _image(),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final item in _items) ...[
                          _itemCard(item),
                          SizedBox(height: 20.h),
                        ],
                        _addItemButton(),
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
    final bytes = widget.args.imageBytes;
    final url = widget.args.analysis.imageUrl;
    final img = bytes != null
        ? Image.memory(bytes,
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
      clipBehavior: Clip.none,
      children: [
        img,
        Positioned(
            left: 18.w, bottom: -21.h, child: CalorieChip(kcal: _totalKcal)),
      ],
    );
  }

  Widget _itemCard(_ItemFields item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.check,
                    size: 18.r,
                    color:
                        item.isAi ? AppColors.successText2 : AppColors.text4D),
                SizedBox(width: 4.w),
                Text(item.isAi ? 'AI 분석 완료' : '직접 입력',
                    style: AppType.label(
                        color: item.isAi
                            ? AppColors.successText2
                            : AppColors.text4D,
                        w: FontWeight.w600)),
              ],
            ),
            if (!item.isAi)
              GestureDetector(
                onTap: () => _removeItem(item),
                child:
                    Text('삭제', style: AppType.caption(color: AppColors.text85)),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        _nameField(item),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(child: _macroField(item, Macro.protein, item.proteinC)),
            SizedBox(width: 12.w),
            Expanded(child: _macroField(item, Macro.carbs, item.carbsC)),
            SizedBox(width: 12.w),
            Expanded(child: _macroField(item, Macro.fat, item.fatC)),
          ],
        ),
      ],
    );
  }

  Widget _nameField(_ItemFields item) {
    return TextField(
      controller: item.name_,
      style: AppType.appBar(),
      cursorColor: AppColors.primary,
      maxLength: 50,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.white,
        counterText: '',
        hintText: '음식 이름을 입력해주세요.',
        hintStyle: AppType.body(color: AppColors.textC5),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  /// 편집 가능한 영양 박스 — 라벨 + 그램 입력(색상별).
  Widget _macroField(
      _ItemFields item, Macro macro, TextEditingController ctrl) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.r12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(macro.label,
              style:
                  AppType.label(color: AppColors.text85, w: FontWeight.w600)),
          SizedBox(
            height: 22.h,
            child: TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: AppType.value(color: macro.textColor)
                  .copyWith(fontSize: 17.sp),
              cursorColor: AppColors.primary,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                suffixText: 'g',
                suffixStyle: AppType.value(color: macro.textColor)
                    .copyWith(fontSize: 17.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addItemButton() {
    return Center(
      child: GestureDetector(
        onTap: _addItem,
        child: Container(
          width: 51.r,
          height: 51.r,
          decoration: const BoxDecoration(
            color: AppColors.primaryTint,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, size: 22.r, color: AppColors.primary),
        ),
      ),
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
        filled: true,
        fillColor: AppColors.white,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.r12.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
