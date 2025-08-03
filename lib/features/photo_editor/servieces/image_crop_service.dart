import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// 이미지를 자르는 기능을 수행하고, 잘린 파일 객체를 반환
class ImageCropService {
  Future<File?> cropImage(BuildContext context, String imagePath) async {
    final cropper = ImageCropper();
    
    // 자르기 UI 설정
    final List<PlatformUiSettings> uiSettings = [
      AndroidUiSettings(
       toolbarTitle: '이미지 자르기', 
          toolbarColor: Theme.of(context).primaryColor, // 앱의 기본 테마 색상
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original, // 초기 화면 비율
          lockAspectRatio: false, // 사용자가 비율을 변경할 수 있도록 함
      ),
    ];

    // 다양한 자르기 비율 옵션
    final List<CropAspectRatioPreset> aspectRatioPresets = [
      CropAspectRatioPreset.square, // 정사각형
      CropAspectRatioPreset.ratio3x2, // 3:2 비율
      CropAspectRatioPreset.ratio4x3, // 4:3 비율
      CropAspectRatioPreset.ratio5x3, // 5:3 비율
      CropAspectRatioPreset.ratio5x4, // 5:4 비율
      CropAspectRatioPreset.ratio7x5, // 7:5 비율
      CropAspectRatioPreset.ratio16x9, // 16:9 비율
      CropAspectRatioPreset.original // 원본 비율
    ];
    
    // ImageCropper를 사용하여 이미지 자르기 UI를 표시하고 결과를 받음
    CroppedFile? croppedFile = await cropper.cropImage(
      sourcePath: imagePath,
      uiSettings: uiSettings,
      aspectRatioPresets: aspectRatioPresets,
    );
    
    // Case1: 사용자가 자르기를 완료하고 파일을 선택한 경우
    if (croppedFile != null) {
      return File(croppedFile.path); // 잘린 이미지 파일을  File 객체로 반환
    }

    // Case2: 사용자가 자르기를 취소한 경우
    return null;
  }
}