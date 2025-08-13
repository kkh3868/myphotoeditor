import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myphotoeditor/features/photo_editor/servieces/image_crop_and_adjust_service.dart';
import 'package:myphotoeditor/features/photo_editor/widgets/sliding_editor_toolbar.dart';

/// 사진을 편집하는 기능을 제공하는 화면
/// StatefulWidget을 사용하여 이미지 편집 상태에 따라 UI를 갱신할 수 있음 (향후 편집 기능 추가 시)
class PhotoEditorScreen extends StatefulWidget{
  final String imagePath; // 전달받은 이미지 경로

  /// [imagePath]는 필수 인자로, 편집할 이미지의 경로를 받음
  const PhotoEditorScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PhotoEditorScreenState createState() => _PhotoEditorScreenState();
}

/// PhotoEditorScreen 위젯의 상태를 관리하는 클래스
/// 전달받은 이미지 파일을 로드하고, 향후 편집 관련 상태 및 로직을 포함하게 됨
class _PhotoEditorScreenState extends State<PhotoEditorScreen>{
  File? _editedImageFile;
  final ImageCropAndAdjustService _cropService = ImageCropAndAdjustService();

  // 위젯이 처음 생성될 때 호출되는 초기화 메소드
  @override
  void initState() {
    super.initState();
    _editedImageFile = File(widget.imagePath);
  }

  Future<void> _performCrop() async {
    if(_editedImageFile == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('자르기할 이미지 파일이 없습니다.'))
      );
      return;
    }
    final File? croppedResult = await _cropService.cropImage(context, _editedImageFile!.path);
    if(croppedResult != null){
      setState(() {
        _editedImageFile = croppedResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<EditingTool> editorTools =[
      EditingTool(
        id: 'crop_transform',
        icon: Icons.crop,
        label: '자르기 및 조정',
        action: _performCrop,
      ),
    ];

    return Scaffold(
      // 앱 상단 바 제목
      appBar: AppBar(
        title: Text('사진 편집'),
      ),
      body: Center(
        child: Image.file(_editedImageFile!),
      ),
      bottomNavigationBar: SlidingEditorToolbar(tools: editorTools),
    );
  }
}