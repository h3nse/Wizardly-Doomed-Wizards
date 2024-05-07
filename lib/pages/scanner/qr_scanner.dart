import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';
import 'package:wizardly_fucked_wizards/Pages/Scanner/scanner_error_widget.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner>
    with SingleTickerProviderStateMixin {
  String scanResult = '';
  bool isReadyToScan = false;
  late Timer timer;

  void _updateResult(BarcodeCapture capture) {
    setState(() {
      scanResult = capture.barcodes.first.rawValue ?? '';
      isReadyToScan = true;
    });
  }

  void _onTimerTimeout(Timer timer) {
    if (!isReadyToScan) {
      setState(() {
        scanResult = '';
      });
    } else {
      isReadyToScan = false;
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 750), _onTimerTimeout);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (scanResult.isNotEmpty)
            ? const Text('Ready to scan')
            : const Text(''),
        backgroundColor: (scanResult.isNotEmpty)
            ? Colors.green[400]
            : Theme.of(context).colorScheme.primary,
        foregroundColor: (scanResult.isNotEmpty)
            ? Colors.black
            : Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                fit: BoxFit.contain,
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                onDetect: (capture) {
                  _updateResult(capture);
                  // String result = capture.barcodes.first.rawValue ?? '';
                  // Future.microtask(() => Navigator.pop(context, result));
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, scanResult);
        },
        child: const Icon(Icons.barcode_reader),
      ),
    );
  }
}
