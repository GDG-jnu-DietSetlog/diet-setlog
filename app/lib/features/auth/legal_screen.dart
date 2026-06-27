import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../design/app_colors.dart';

/// 약관/개인정보 등 정적 법무 문서 한 조항.
class LegalSection {
  const LegalSection(this.heading, {this.intro, this.body = const [], this.ordered = false});
  final String heading;
  final String? intro; // 항목 앞 안내 문장(선택)
  final List<String> body; // 문단 또는 번호 항목
  final bool ordered; // true면 "1. 2. 3." 번호 매김
}

/// 온보딩6(서비스 이용약관)·온보딩7(개인정보 처리방침) 공통 레이아웃. screens: `51:579`, `51:610`.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.title, required this.sections});
  final String title;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.r, color: AppColors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  height: 32 / 20,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 56.h),
              for (var i = 0; i < sections.length; i++) ...[
                _SectionView(sections[i]),
                if (i != sections.length - 1) SizedBox(height: 36.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView(this.section);
  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    final headingStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 24 / 16,
      color: AppColors.black,
    );
    final bodyStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      height: 28 / 13,
      color: AppColors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.heading, style: headingStyle),
        SizedBox(height: 16.h),
        if (section.intro != null) ...[
          Text(section.intro!,
              style: bodyStyle.copyWith(fontWeight: FontWeight.w500)),
          if (section.body.isNotEmpty) SizedBox(height: 8.h),
        ],
        for (var i = 0; i < section.body.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == section.body.length - 1 ? 0 : 2.h),
            child: section.ordered
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                        child: Text('${i + 1}.', style: bodyStyle),
                      ),
                      Expanded(child: Text(section.body[i], style: bodyStyle)),
                    ],
                  )
                : Text(section.body[i], style: bodyStyle),
          ),
      ],
    );
  }
}

// ⚠️ 아래 약관/방침은 오늘냠 서비스에 맞춰 작성한 **임시 초안**이다.
//    법률 검토를 거치지 않았으므로 정식 출시 전 반드시 법무 검토/교체할 것.
//    (시안 원문의 'YAMOYO·팀 협업/회의 관리' 등 타 서비스 잔재를 대체함.)

/// 서비스 이용약관(온보딩6) — 임시 초안.
const kTermsSections = <LegalSection>[
  LegalSection(
    '제1조 (목적)',
    body: [
      '본 약관은 오늘냠(이하 "회사")이 제공하는 식단 기록 및 친구 공유 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.',
    ],
  ),
  LegalSection(
    '제2조 (회원가입 및 이용)',
    ordered: true,
    body: [
      '본 서비스는 카카오 계정을 통한 소셜 로그인 방식으로 회원가입이 가능합니다.',
      '하나의 카카오 계정은 하나의 회원 계정으로 관리됩니다.',
      '이용자는 가입 및 이용 시 정확한 정보를 제공해야 합니다.',
    ],
  ),
  LegalSection(
    '제3조 (서비스 제공)',
    ordered: true,
    body: [
      '회사는 식단 사진 기록, AI 영양 분석, 칼로리 관리, 친구와의 식단 공유 및 응원 기능을 제공합니다.',
      '회사는 운영상 또는 기술상 필요에 따라 서비스의 일부를 변경하거나 종료할 수 있습니다.',
    ],
  ),
  LegalSection(
    '제4조 (회원의 책임)',
    intro: '이용자는 다음 행위를 하여서는 안 됩니다.',
    ordered: true,
    body: [
      '타인의 계정 도용 또는 부정 사용',
      '서비스 운영을 방해하거나 다른 이용자에게 피해를 주는 행위',
      '관련 법령을 위반하는 행위',
    ],
  ),
  LegalSection(
    '제5조 (게시물)',
    ordered: true,
    body: [
      '이용자가 등록한 식단 기록·사진·댓글 등 게시물의 권리와 책임은 작성자에게 있습니다.',
      '회사는 서비스 운영 및 노출에 필요한 범위에서 게시물을 사용할 수 있습니다.',
      '회사는 관련 법령 또는 본 약관을 위반하는 게시물을 사전 통지 없이 삭제할 수 있습니다.',
    ],
  ),
  LegalSection(
    '제6조 (서비스 중단)',
    body: [
      '시스템 점검, 장애 등 불가피한 사유가 발생한 경우 서비스 제공을 일시적으로 중단할 수 있습니다.',
    ],
  ),
  LegalSection(
    '제7조 (탈퇴 및 이용 종료)',
    ordered: true,
    body: [
      '이용자는 언제든지 서비스 내 탈퇴 기능을 통해 이용 계약을 해지할 수 있습니다.',
      '탈퇴 시 계정 정보 및 게시물은 관련 법령에 따른 보관 의무가 없는 한 지체 없이 삭제되며, 삭제된 정보는 복구되지 않습니다.',
    ],
  ),
  LegalSection(
    '제8조 (면책)',
    body: [
      '본 서비스가 제공하는 AI 영양 분석 및 칼로리 정보는 참고용이며, 의학적 진단이나 전문가의 조언을 대체하지 않습니다.',
    ],
  ),
  LegalSection(
    '제9조 (준거법)',
    body: ['본 약관은 대한민국 법률을 준거법으로 합니다.'],
  ),
];

/// 개인정보 처리방침(온보딩7) — 임시 초안.
const kPrivacySections = <LegalSection>[
  LegalSection(
    '제1조 (수집하는 개인정보)',
    intro: '회사는 서비스 제공을 위해 다음의 개인정보를 수집합니다.',
    body: [
      '카카오 로그인 정보: 카카오 회원번호, 닉네임, 프로필 사진',
      '이용자 입력 정보: 성별, 출생연도, 키, 체중, 목표 정보',
      '서비스 이용 정보: 식단 사진 및 기록, 친구 관계, 게시물·댓글·좋아요',
    ],
  ),
  LegalSection(
    '제2조 (개인정보 이용 목적)',
    intro: '수집한 개인정보는 다음 목적을 위해 이용됩니다.',
    body: [
      '회원 식별 및 로그인 처리',
      '식단 기록·AI 분석·칼로리 관리 등 핵심 기능 제공',
      '친구 공유 및 피드 소통 기능 제공',
      '서비스 운영, 개선 및 안내 알림 제공',
    ],
  ),
  LegalSection(
    '제3조 (보유 및 이용 기간)',
    body: [
      '개인정보는 회원 탈퇴 시까지 보유하며, 탈퇴 시 지체 없이 삭제합니다. 다만 관련 법령에 따라 보관이 필요한 경우 해당 기간 동안 보관합니다.',
    ],
  ),
  LegalSection(
    '제4조 (개인정보 제3자 제공)',
    intro: '회사는 이용자의 개인정보를 원칙적으로 제3자에게 제공하지 않습니다. 다만 다음의 경우는 예외로 합니다.',
    ordered: true,
    body: [
      '이용자가 사전에 동의한 경우',
      '법령에 따라 요구되는 경우',
    ],
  ),
  LegalSection(
    '제5조 (개인정보 처리 위탁)',
    body: [
      '회사는 카카오 로그인 및 클라우드 인프라 운영 등을 위해 필요한 범위에서 개인정보 처리를 위탁할 수 있으며, 위탁 시 관련 사항을 고지합니다.',
    ],
  ),
  LegalSection(
    '제6조 (이용자의 권리)',
    body: [
      '이용자는 언제든지 개인정보 열람, 수정, 삭제 및 처리 정지를 요청할 수 있습니다.',
    ],
  ),
];
