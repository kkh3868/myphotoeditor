import 'package:flutter/material.dart';

/// 편집 도구를 나타내는 개별 아이템 위젯
class EditorToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected; // 현재 선택된 도구인지 여부

  const EditorToolItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 선택된 아이템에 시각적 피드백을 주기 위한 색상
    final Color itemColor = isSelected ? Theme.of(context).colorScheme.primary
        : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final Color backgroundColor = isSelected
        ? Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()) // opacity 0.1을 alpha 값으로 변환
        : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0), // 터치 효과를 위한 경계 반경
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 컬럼이 내용만큼만 크기 차지
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: itemColor, size: 20.0), // 아이콘 크기 조절
              const SizedBox(height: 4.0), // 아이콘과 텍스트 사이 간격
              Text(
                label,
                style: TextStyle(color: itemColor, fontSize: 12.0), // 텍스트 크기 조절
              ),
            ],
          ),
        ),
      ),
    );
  }
}