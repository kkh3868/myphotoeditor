import 'dart:io';
import 'package:flutter/material.dart';

class PhotoEditorScreen extends StatefulWidget{
  final String imagePath; // 전달받은 이미지 경로

  const PhotoEditorScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PhotoEditorScreenState createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen>{
  late File _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 상단 바 제목
      appBar: AppBar(
        title: Text('사진 편집'),
      ),
      body: Center(
        child: Image.file(_imageFile),
      ),
    );
  }
}