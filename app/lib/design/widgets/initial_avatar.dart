import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';

/// 이니셜 아바타 — design-system §1.5 색세트. avatarUrl 있으면 이미지, 없으면 이니셜.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 46,
    this.seedId,
  });

  final String name;
  final String? avatarUrl;
  final double size;

  /// 색 세트 선택용 시드(보통 userId). 없으면 name 사용.
  final String? seedId;

  @override
  Widget build(BuildContext context) {
    final d = size.r;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl!,
          width: d,
          height: d,
          fit: BoxFit.cover,
          placeholder: (_, __) => _initial(d),
          errorWidget: (_, __, ___) => _initial(d),
        ),
      );
    }
    return _initial(d);
  }

  Widget _initial(double d) {
    final seed = (seedId ?? name);
    final idx = seed.isEmpty
        ? 0
        : seed.codeUnits.fold<int>(0, (a, b) => a + b) %
            AppColors.avatarSets.length;
    final (bg, fg) = AppColors.avatarSets[idx];
    final ch = name.isEmpty ? '?' : name.characters.first;
    return Container(
      width: d,
      height: d,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(
        ch,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: (d * 0.4),
          color: fg,
        ),
      ),
    );
  }
}
