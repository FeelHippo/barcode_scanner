import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWithController extends StatelessWidget {
  final _barcodes = <String>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        fit: BoxFit.contain,
        controller: MobileScannerController(),
        onDetect: (capture) {

          // current implementation
          final rawValue = capture.raw;
          if (rawValue == null || _barcodes.contains(rawValue)) {
            debugPrint('~~~ rawValue == null');
            return;
          }
          _barcodes.add(rawValue.toString());
          debugPrint('~~~ Starlight reads: ${capture.toString()}');
          // TODO: check onScanCompleted handler for each tenant
          // lib/presentation/scan_barcode/scan_barcode_screen.dart
          scanAdapterWidgetOnScanCompleted(capture);

          // documentation implementation
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('~~~ Documentation: ${barcode.rawValue}');
          }
        },
      ),
    );
  }
  // lib/presentation/scan_barcode/adapter/scan/scan_adapter_widget.dart
  void scanAdapterWidgetOnScanCompleted(barcode) {
    final value = barcode.raw.toString();
    // lib/presentation/scan_barcode/adapter/bloc/install_adapter_bloc.dart
    final serialNumber = value;

    if (serialNumber != null) {
      final String formattedSerialNumber = serialNumber.contains("/")
          ? serialNumber.split("/")[1]
          : serialNumber;
      debugPrint('~~~ scanAdapterWidget formattedSerialNumber: $formattedSerialNumber');
      if (serialNumber.length >= 10 || serialNumber.length == 15) {
        debugPrint('~~~ scanAdapterWidget success: $formattedSerialNumber');
      } else {
        debugPrint('~~~ scanAdapterWidget failure: $formattedSerialNumber');
      }
    }
  }
  // lib/presentation/fuel_selection/echarging/widgets/charge_scanner_widget.dart
  void chargeScannerWidgetOnScanCompleted(barcode) {
    if (barcode.barcodes.first.format == BarcodeFormat.qrCode) {
      final String? value = barcode.barcodes.first.rawValue;
      if (value != null && value.isNotEmpty) {
        if (value.startsWith('https://')) {
          final Uri uri = Uri.parse(value);
          final Map<String, dynamic> queryParams =
              uri.queryParameters;
          debugPrint('ChargeScannerWidget success: ${queryParams['shortcode'].toString()}');
        } else {
          debugPrint('ChargeScannerWidget failure');
        }
      } else {
        debugPrint('ChargeScannerWidget failure');
      }
    } else {
      debugPrint('ChargeScannerWidget failure');
    }
  }

  // lib/presentation/scan_barcode/garage/scan/scan_garage_widget.dart
  // only used to scan AMAG garage employeed from QR
  void scanGarageWidgetOnScanCompleted(barcode) {
    if (barcode.barcodes.first.format == BarcodeFormat.qrCode) {
      final value = barcode.barcodes.first.rawValue;
      // lib/presentation/scan_barcode/garage/bloc/preferred_garage_bloc.dart
      if (value != null && value.startsWith("user_id=")) {
        final dealerUserId = value.replaceAll("user_id=", "");
        debugPrint('ScanGarageWidget success: $dealerUserId');
      } else {
        debugPrint('ScanGarageWidget failure');
      }
    }
  }
}