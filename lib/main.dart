import 'package:flutter/material.dart';
import 'screens/photo_picker_screen.dart'; // 파일 경로에 맞게 조정

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '사진 편집기',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhotoPickerScreen(),
    );
  }
}
