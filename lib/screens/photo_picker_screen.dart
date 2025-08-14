import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myphotoeditor/screens/photo_editor_screen.dart';
import 'package:myphotoeditor/database/database_helper.dart';
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
  List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadImagesFromDb();
  }

  Future<void> _loadImagesFromDb() async {
    final List<String> loadedPaths = await _dbHelper.getAllImagePaths();
    
    // 마운트 상태 확인
    if (!mounted) return;

    setState(() {
      _imagePaths = loadedPaths;
    });
  }

  /// 갤러리에서 사진을 선택하는 함수
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // 마운트 상태 확인
    if (!mounted) return;

    if (pickedFile != null){
      _navigateToEditor(pickedFile.path, isNewImage: true);
    }
  }

  Future<void> _navigateToEditor(String imagePath, {int? indexToReplace, bool isNewImage = false}) async {
    // 마운트 상태 확인
    if (!mounted) return;

    // PhotoEditorScreen을 호출하고 결과를 기다림
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoEditorScreen(imagePath: imagePath)),
    );

    // 마운트 상태 재확인
    if (!mounted) return;

    // PhotoEditorScreen에서 반환한 결과를 처리
    if (result != null && result.isNotEmpty) {
      // Case1: 새 이미지를 DB에 추가
      if (isNewImage) {
        await _dbHelper.insertImage(result);
      }
      // Case2: 기존 이미지를 편집한 경우
      else if (indexToReplace != null) {
        String oldPath = _imagePaths[indexToReplace];
        if(oldPath != result) {
          await _dbHelper.deleteImage(oldPath);
          await _dbHelper.insertImage(result);
        }
      }
      // DB에서 최신 이미지 목록을 다시 로드
      _loadImagesFromDb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 선택'),
      ),
      body: _imagePaths.isEmpty
          ? const Center(
        child: Column( // 아이콘과 텍스트를 함께 보여주기 위한 Column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('갤러리에 사진이 없습니다.',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('아래 버튼을 눌러 사진을 추가해보세요!', style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : Padding( // 그리드 전체에 패딩 추가
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 한 줄에 3개의 이미지 표시
            crossAxisSpacing: 8.0, // 이미지 간 가로 간격
            mainAxisSpacing: 8.0, // 이미지 간 세로 간격
            childAspectRatio: 1.0, // 이미지의 가로세로 비율 (1.0은 정사각형)
          ),
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            final imagePath = _imagePaths[index];
            return GestureDetector( // 이미지 탭 감지
              onTap: () {
                _navigateToEditor(imagePath, indexToReplace: index);
              },
              child: Stack( // 이미지 위에 삭제 버튼 등을 올리기 위한 Stack
                fit: StackFit.expand,
                children: [
                  Card( // 액자 느낌을 위한 Card 위젯
                    elevation: 4.0, // 그림자 효과
                    clipBehavior: Clip.antiAlias, // Card의 경계에 맞춰 이미지 자르기
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
                    ),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover, // 이미지가 Card를 꽉 채우도록
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(
                            Icons.broken_image, size: 40, color: Colors.grey));
                      },
                    ),
                  ),
                  Positioned( // 삭제 버튼 위치 지정
                    top: 4,
                    right: 4,
                    child: InkWell( // 터치 영역을 넓히고 시각적 피드백 제공
                      onTap: () {
                        // 삭제 확인 다이얼로그 (선택 사항)
                        showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) { // 'context' 변수명 수정
                              return AlertDialog(
                                title: const Text('이미지 삭제'),
                                content: const Text('이 이미지를 삭제하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('삭제', style: TextStyle(color: Colors.red)),
                                    onPressed: () async {
                                      await _dbHelper.deleteImage(imagePath);
                                      if (!mounted) return;
                                      Navigator.of(dialogContext).pop();
                                      _loadImagesFromDb();
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close, // 삭제 아이콘 변경 (close가 더 적절할 수 있음)
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // 우측 하단의 플로팅 액션 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: '사진 추가',
        child: Icon(Icons.photo_library),
      ),
    );
  }
}