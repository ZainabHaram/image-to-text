import 'dart:html' as html;
// ignore: deprecated_member_use
import 'dart:js_util' as js_util;
import 'package:flutter/services.dart';
import '../model/ocr_model.dart';

class OcrController {
  final OcrModel model = OcrModel();

  Future<void> pickImageAndExtractText() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    await input.onChange.first;
    final file = input.files!.first;

    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;

    final imageData = reader.result;

    final result = await js_util.promiseToFuture(
      js_util.callMethod(html.window, 'extractTextFromImage', [imageData]),
    );

    model.extractedText = result.toString();
  }

  /// 📋 COPY FUNCTION
  Future<void> copyText() async {
    if (model.extractedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: model.extractedText));
    }
  }
}
