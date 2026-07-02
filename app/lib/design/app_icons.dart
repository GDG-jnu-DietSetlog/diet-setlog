import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/mi.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:iconify_flutter/icons/uit.dart';

/// iconify 아이콘 매핑(spec-lock §11). iconify_flutter 0.0.7 에 번들된 세트
/// (mdi/mi/tabler/uit)만 직접 사용하고, 미번들 세트(solar/iconamoon/mynaui/weui)는
/// 시각적으로 동등한 mdi 아이콘으로 대체한다.
abstract final class AppIcons {
  static const search = Mdi.magnify;
  static const bell = Mdi.bell_outline; // mdi:bell (피드 알림)
  static const back = Mdi.arrow_left; // weui:back 대체
  static const close = Mdi.close;
  static const plus = Mdi.plus;
  static const accountPlus = Mdi.account_plus_outline;
  static const check = Mdi.check;
  static const chevronRight = Mdi.chevron_right;
  static const more = Mdi.dots_horizontal;

  // bottom nav (solar:home-*/camera-linear, uit:calender, iconamoon:profile-fill)
  static const navHome = Mdi.home;
  static const navHomeOutline = Mdi.home_outline;
  static const navCamera = Mdi.camera_outline; // solar:camera-linear 대체
  static const navCalendar = Uit.calender;
  static const navProfile = Mdi.account; // iconamoon:profile-fill 대체
  static const navProfileOutline = Mdi.account_outline;

  // feed 액션
  static const heart = Mdi.heart; // tabler:heart-filled 대체(채움)
  static const heartOutline = Tabler.heart; // tabler:heart(빈)
  static const comment = Mdi.comment_outline; // mynaui:chat 대체
  static const send = Mi.send; // mi:send
  static const bookmark = Mdi.bookmark_outline;

  static const calendar = Uit.calender;
}
