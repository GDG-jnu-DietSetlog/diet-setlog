import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../data/models/enums.dart';
import '../../data/models/profile.dart';
import '../session/session_providers.dart';

/// 온보딩 입력 draft(STEP1·2·3). API 호출 전까지 클라에 보관(spec-lock §3).
class OnboardingDraft {
  const OnboardingDraft({
    this.displayName = '',
    this.gender,
    this.birthYear,
    this.heightCm,
    this.currentWeightKg,
    this.targetWeightKg,
    this.targetDate,
  });

  final String displayName;
  final Gender? gender;
  final int? birthYear;
  final double? heightCm;
  final double? currentWeightKg;
  final double? targetWeightKg;
  final DateTime? targetDate;

  OnboardingDraft copyWith({
    String? displayName,
    Gender? gender,
    int? birthYear,
    double? heightCm,
    double? currentWeightKg,
    double? targetWeightKg,
    DateTime? targetDate,
  }) {
    return OnboardingDraft(
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  // ── 단계별 유효성(클라 검증, spec-lock §7) ──
  bool get step1Valid =>
      displayName.trim().isNotEmpty && displayName.trim().length <= 50;

  bool get step2Valid =>
      gender != null &&
      birthYear != null &&
      birthYear! >= 1920 &&
      birthYear! <= DateTime.now().year - 14 &&
      heightCm != null &&
      heightCm! >= 80 &&
      heightCm! <= 250 &&
      currentWeightKg != null &&
      currentWeightKg! >= 20 &&
      currentWeightKg! <= 400;

  bool get step3Valid =>
      targetWeightKg != null &&
      targetWeightKg! >= 20 &&
      targetWeightKg! <= 400 &&
      targetDate != null;
}

class OnboardingDraftNotifier extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  void update(OnboardingDraft Function(OnboardingDraft) f) => state = f(state);
  void setName(String v) => state = state.copyWith(displayName: v);
  void setGender(Gender v) => state = state.copyWith(gender: v);
  void setBirthYear(int? v) => state = OnboardingDraft(
        displayName: state.displayName,
        gender: state.gender,
        birthYear: v,
        heightCm: state.heightCm,
        currentWeightKg: state.currentWeightKg,
        targetWeightKg: state.targetWeightKg,
        targetDate: state.targetDate,
      );
  void setHeight(double? v) => state = OnboardingDraft(
        displayName: state.displayName,
        gender: state.gender,
        birthYear: state.birthYear,
        heightCm: v,
        currentWeightKg: state.currentWeightKg,
        targetWeightKg: state.targetWeightKg,
        targetDate: state.targetDate,
      );
  void setCurrentWeight(double? v) => state = OnboardingDraft(
        displayName: state.displayName,
        gender: state.gender,
        birthYear: state.birthYear,
        heightCm: state.heightCm,
        currentWeightKg: v,
        targetWeightKg: state.targetWeightKg,
        targetDate: state.targetDate,
      );
  void setTargetWeight(double? v) => state = OnboardingDraft(
        displayName: state.displayName,
        gender: state.gender,
        birthYear: state.birthYear,
        heightCm: state.heightCm,
        currentWeightKg: state.currentWeightKg,
        targetWeightKg: v,
        targetDate: state.targetDate,
      );
  void setTargetDate(DateTime v) => state = state.copyWith(targetDate: v);

  /// STEP3 제출(PUT /v1/me/profile). 성공 시 profile provider 갱신.
  /// `targetDate` 는 YYYY-MM-DD(date-only)로 직렬화.
  Future<ProfileResponse> submit() async {
    final d = state;
    final req = ProfileUpsertRequest(
      displayName: d.displayName.trim(),
      gender: d.gender!,
      birthYear: d.birthYear!,
      heightCm: d.heightCm!,
      currentWeightKg: d.currentWeightKg!,
      targetWeightKg: d.targetWeightKg!,
      targetDate: _ymd(d.targetDate!),
    );
    final res = await ref.read(profileApiProvider).putProfile(req);
    ref.read(profileStateProvider.notifier).set(res);
    return res;
  }
}

final onboardingDraftProvider =
    NotifierProvider<OnboardingDraftNotifier, OnboardingDraft>(
        OnboardingDraftNotifier.new);

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
