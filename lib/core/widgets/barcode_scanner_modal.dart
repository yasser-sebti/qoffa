import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../app/theme/qoffa_colors.dart';
import '../../app/theme/qoffa_tokens.dart';

class BarcodeScannerModal extends StatefulWidget {
  const BarcodeScannerModal({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BarcodeScannerModal(),
    );
  }

  @override
  State<BarcodeScannerModal> createState() => _BarcodeScannerModalState();
}

class _BarcodeScannerModalState extends State<BarcodeScannerModal> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool _hasDetected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(
        color: QoffaColors.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(QoffaTokens.radiusMajor)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'مسح باركود المنتج',
                  style: TextStyle(
                    fontFamily: 'Hero Sandwich Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: _controller,
                    onDetect: (capture) {
                      if (_hasDetected) return;
                      final barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final val = barcode.rawValue;
                        if (val != null && val.trim().isNotEmpty) {
                          _hasDetected = true;
                          Navigator.of(context).pop(val.trim());
                          break;
                        }
                      }
                    },
                  ),
                  // Reticle frame
                  Container(
                    width: 250,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: QoffaColors.brandGreen, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'وجه الكاميرا نحو باركود المنتج لمسحه تلقائياً',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
