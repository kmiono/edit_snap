import "package:flutter/material.dart";
import 'package:edit_snap/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as image_lib;

class ImageSelectScreen extends StatefulWidget {
  const ImageSelectScreen({super.key});

  @override
  State<ImageSelectScreen> createState() => _ImageSelectScreenState();
}

class _ImageSelectScreenState extends State<ImageSelectScreen> {
  /* ImagePicker
  image_pickerライブラリが提供するクラス
  画像ライブラリやカメラにアクセスする権限を持つ
  */
  final ImagePicker _picker = ImagePicker();

  /* Unit8List
  8bit符号なし整数のリスト
  */
  Uint8List? _imageBitmap;

  Future<void> _selectImage() async {
    /* XFile
  ファイルの抽象化クラス
  */
    // 画像を選択する
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    // ファイルオブジェクトから画像データを取得する
    final imageBitmap = await imageFile?.readAsBytes();
    assert(imageBitmap != null);
    if (imageBitmap == null) return;

    // 画像データをデコードする
    final image = image_lib.decodeImage(imageBitmap);
    assert(image != null);
    if (image == null) return;

    /* image
    画像データとメタデータを内包したクラス
    */
    final image_lib.Image resizedImage;
    if (image.width > image.height) {
      // 横長の画像なら横幅を500pxにリサイズする
      resizedImage = image_lib.copyResize(image, width: 500);
    } else {
      // 縦長の画像なら縦幅を500pxにリサイズする
      resizedImage = image_lib.copyResize(image, height: 500);
    }

    // 画像をエンコードして更新する
    setState(() {
      _imageBitmap = image_lib.encodeBmp(resizedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final imageBitmap = _imageBitmap;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageSelectScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageBitmap != null) Image.memory(imageBitmap),
            ElevatedButton(
              onPressed: () => _selectImage(),
              child: Text(l10n.imageSelect),
            ),
            if (imageBitmap != null)
              ElevatedButton(onPressed: () {}, child: Text(l10n.imageEdit)),
          ],
        ),
      ),
    );
  }
}
