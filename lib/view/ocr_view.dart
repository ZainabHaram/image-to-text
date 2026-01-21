import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/ocr_controller.dart';

class OcrView extends StatefulWidget {
  const OcrView({super.key});

  @override
  State<OcrView> createState() => _OcrViewState();
}

class _OcrViewState extends State<OcrView> {
  final OcrController controller = OcrController();
  bool isLoading = false;

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      /// 🔹 CLEAN HEADER (NOT APPBAR)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔹 TOP TITLE
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image to Text',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload an image and extract readable text',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 SELECT IMAGE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.image_rounded, size: 20),
                  label: Text(
                    'Select Image',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () async {
                    setState(() => isLoading = true);
                    await controller.pickImageAndExtractText();
                    setState(() => isLoading = false);

                    if (controller.model.extractedText.isNotEmpty) {
                      showSnack('Text extracted successfully');
                    }
                  },
                ),
              ),

              const SizedBox(height: 18),

              /// 🔹 RESULT CARD (GPT STYLE)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: isLoading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Extracting text…',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            /// 🔹 HEADER WITH COPY
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Extracted Text',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (controller.model.extractedText.isNotEmpty)
                                    IconButton(
                                      tooltip: 'Copy',
                                      icon: const Icon(
                                        Icons.copy_rounded,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        await controller.copyText();
                                        showSnack('Copied to clipboard');
                                      },
                                    ),
                                ],
                              ),
                            ),

                            /// 🔹 TEXT AREA
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(12),
                                child: SelectableText(
                                  controller.model.extractedText.isEmpty
                                      ? 'No text extracted yet.\n\nSelect an image to start OCR.'
                                      : controller.model.extractedText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.7,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
