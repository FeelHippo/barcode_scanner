import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode_scanner/scanner_error_widget.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerWithController> createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;

  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true, useNewCameraSelector: true,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    // returnImage: false,
  );

  int? numberOfCameras;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              startDelay: true,
              controller: controller,
              onScannerStarted: (arguments) {
                if (mounted && arguments?.numberOfCameras != null) {
                  numberOfCameras = arguments!.numberOfCameras;
                  setState(() {});
                }
              },
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              fit: BoxFit.contain,
              onDetect: (barcode) {
                setState(() {
                  this.barcode = barcode;
                });
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        height: 50,
                        child: FittedBox(
                          child: Text(
                            barcode?.barcodes.first.rawValue ??
                                'Scan something!',
                            overflow: TextOverflow.fade,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: ValueListenableBuilder<CameraFacing>(
                        valueListenable: controller.cameraFacingState,
                        builder: (context, state, child) {
                          switch (state) {
                            case CameraFacing.front:
                              return const Icon(Icons.camera_front);
                            case CameraFacing.back:
                              return const Icon(Icons.camera_rear);
                          }
                        },
                      ),
                      iconSize: 32.0,
                      onPressed: (numberOfCameras ?? 0) < 2
                          ? null
                          : () => controller.switchCamera(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}