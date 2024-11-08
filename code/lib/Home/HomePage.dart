import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../navBar/navBar.dart';
import './barcodeScanner/Scanner.dart';
import '../style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../BookDetails/Reviewinfos.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}



class _HomePage extends State<HomePage>{


  BarcodeScannerWithScanWindow scanner = BarcodeScannerWithScanWindow();


  final MobileScannerController _controller = MobileScannerController();

  BarcodeCapture? _barcodeCapture;

  Future<void> _analyzeImageFromFile() async {
    try {
      final XFile? file =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (!mounted || file == null) {
        return;
      }

      final BarcodeCapture? barcodeCapture =
      await _controller.analyzeImage(file.path);

      if (mounted) {
        setState(() {
          _barcodeCapture = barcodeCapture;
        });
      }
    } catch (_) {}
  }

  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    if (_barcodeCapture != null) {
      Future.delayed(Duration(milliseconds: 20), (){
        if(context.mounted) {
          Navigator.popAndPushNamed(context, "/bookdetails",
              arguments: Reviewinfos(
                  _barcodeCapture?.barcodes.firstOrNull?.displayValue ??
                      'Error: No barcode detected', -1));
        }
      });



    }

    return Scaffold(
      body: Stack( alignment: Alignment.bottomCenter, children: [ scanner,
      Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            ElevatedButton(
                onPressed: (){
                  Navigator.popAndPushNamed(
                    context,
                    "/search"
                  );
                },
                style: circleBtnStyle,
                child: const Icon(Icons.search)
            ),
            ElevatedButton(
                onPressed:
                  kIsWeb ? null : _analyzeImageFromFile
                ,
                style: circleBtnStyle,
                child: const Icon(Icons.image)

            ),
          ]
        )
      )],
      ),
      bottomNavigationBar: navBar(context),
    );
  }




}
