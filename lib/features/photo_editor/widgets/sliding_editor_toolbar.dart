import 'package:flutter/material.dart';
import 'editor_tool_item.dart'; // 방금 만든 EditorToolItem 임포트

// 각 편집 도구를 나타내는 데이터 클래스 (선택적이지만, 관리 용이)
class EditingTool {
  final String id; // 각 도구를 식별하기 위한 고유 ID
  final IconData icon;
  final String label;
  final VoidCallback action; // 이 도구가 선택되었을 때 실행될 액션

  EditingTool({
    required this.id,
    required this.icon,
    required this.label,
    required this.action,
  });
}

class SlidingEditorToolbar extends StatefulWidget {
  final List<EditingTool> tools;

  // final String? selectedToolId; // 현재 선택된 도구의 ID (EditorToolItem의 isSelected를 위해)

  const SlidingEditorToolbar({
    Key? key,
    required this.tools,
    // this.selectedToolId,
  }) : super(key: key);

  @override
  State<SlidingEditorToolbar> createState() => _SlidingEditorToolbarState();
}

class _SlidingEditorToolbarState extends State<SlidingEditorToolbar> {
  // 만약 도구 선택 시 하위 옵션 메뉴가 나타나는 등의 복잡한 상태 관리가 필요하면
  // 여기서 상태 변수 (예: selectedToolId)를 관리할 수 있습니다.
  // 지금은 간단하게 각 도구의 action을 직접 호출하는 방식으로 구현합니다.

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0, // 툴바의 높이 (아이콘과 텍스트 크기에 맞게 조절)
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 수평 스크롤
        itemCount: widget.tools.length,
        itemBuilder: (context, index) {
          final tool = widget.tools[index];
          return EditorToolItem(
            icon: tool.icon,
            label: tool.label,
            onTap: tool.action, // 각 도구에 정의된 action을 직접 실행
            // isSelected: tool.id == widget.selectedToolId, // 선택 상태 반영
          );
        },
      ),
    );
  }
}