import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// 사진을 갤러리에서 선택해 보여주는 화면
/// StatefulWidget을 사용하여 사진 선택 후 UI를 갱신
class PhotoPickerScreen extends StatefulWidget {
  @override
  _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
}

/// 상태를 관리하는 클래스
/// 사진 파일을 저장하고, 갤러리에서 사진을 선택하는 기능 포함
class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  File? _image;

  /// 갤러리에서 사진을 선택하는 함수
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null){
      setState((){
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 상단 바 제목
      appBar: AppBar(
        title: Text('사진 불러오기'), 
      ),
      // 사진이 선택되지 않았다면 안내 텍스트 표시, 선택되었다면 사진을 화면에 Display
      body: Center(
        child: _image == null ? Text('갤러리에서 사진을 선택해주세요.') : Image.file(_image!),
      ),
      // 우측 하단의 플로팅 액션 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.photo_library),
      ),
    );
  }
}