import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/ocr_controller.dart';

class OcrView extends StatefulWidget {
  const OcrView({super.key});

  @override
  State<OcrView> createState() => _OcrViewState();
}

class _OcrViewState extends State<OcrView> with TickerProviderStateMixin {
  final OcrController controller = OcrController();
  bool isLoading = false;

  late final AnimationController _loaderController;

  @override
  void initState() {
    super.initState();
    // Safe loader for Web
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    // Stop animation safely to prevent Web crash
    _loaderController.stop();
    _loaderController.dispose();
    super.dispose();
  }

  // Professional SnackBar
  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive card width
    final double cardWidth = MediaQuery.of(context).size.width * 0.9 > 600
        ? 600
        : MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title inside card
                Text(
                  'Image to Text OCR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Select Image Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    setState(() => isLoading = true);
                    await controller.pickImageAndExtractText();
                    setState(() => isLoading = false);

                    if (controller.model.extractedText.isNotEmpty) {
                      showCustomSnackBar('Text extracted successfully!');
                    }
                  },
                  child: Text(
                    'Select Image',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Loader or Result
                if (isLoading)
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Extracting text...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )
                else
                  // Result Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: SelectableText(
                      controller.model.extractedText.isEmpty
                          ? 'Extracted text will appear here...'
                          : controller.model.extractedText,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                // Copy Button
                if (!isLoading && controller.model.extractedText.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await controller.copyText();
                        showCustomSnackBar('Text copied to clipboard!');
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.black87,
                        size: 18,
                      ),
                      label: Text(
                        'Copy Text',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
