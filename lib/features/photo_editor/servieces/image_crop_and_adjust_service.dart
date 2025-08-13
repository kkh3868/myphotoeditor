import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// 이미지를 자르는 기능을 수행하고, 잘린 파일 객체를 반환
class ImageCropAndAdjustService {
  Future<File?> cropImage(BuildContext context, String imagePath) async {
    final cropper = ImageCropper();

    final List<CropAspectRatioPreset> commonAspectRatioPresets = [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9,
      CropAspectRatioPreset.original,
    ];

    // 자르기 UI 설정
    final List<PlatformUiSettings> uiSettings = [
      AndroidUiSettings(
        toolbarTitle: '자르기 및 조정',
        toolbarColor: Theme.of(context).primaryColor, // 앱의 기본 테마 색상
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original, // 초기 화면 비율
        lockAspectRatio: false, // 사용자가 비율을 변경할 수 있도록 함
        aspectRatioPresets: commonAspectRatioPresets,
      ),
    ];
    
    // ImageCropper를 사용하여 이미지 자르기 UI를 표시하고 결과를 받음
    CroppedFile? croppedFile = await cropper.cropImage(
      sourcePath: imagePath,
      uiSettings: uiSettings,
    );
    
    // Case1: 사용자가 자르기를 완료하고 파일을 선택한 경우
    if (croppedFile != null) {
      return File(croppedFile.path); // 잘린 이미지 파일을  File 객체로 반환
    }

    // Case2: 사용자가 자르기를 취소한 경우
    return null;
  }
}