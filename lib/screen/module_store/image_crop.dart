// import 'dart:html';
import 'dart:io' as io;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:crop/crop.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/image_crop.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/widgets/centered_slider_track_shape.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

enum CropType{
  custom,
  avatar,
  storeBackground,
}

class ImageCropScreen extends StatefulWidget {

  @override
  _ImageCropScreenState createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  ImageCropArguments imageCropArguments;
  var _cropController;
  double _rotation = 0;
  BoxShape shape = BoxShape.rectangle;

  @override
  void initState() {
    super.initState();
    debugPrint('initState...');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('didChangeDependencies...');
    imageCropArguments = StoreProvider.of<AppState>(context).state.imageCropArguments;
    if(imageCropArguments == null || imageCropArguments.filePath == null || imageCropArguments.filePath.isEmpty){
      IdolRoute.pop(context);
    }
    double aspectRatio = 1000 / 667.0;
    if(CropType.avatar == imageCropArguments.cropType){
      aspectRatio = 1;
      shape = BoxShape.circle;
    }else if(CropType.storeBackground == imageCropArguments.cropType){
      aspectRatio = 16.0 / 9.0;
      shape = BoxShape.rectangle;
    }
    _cropController = CropController(aspectRatio: aspectRatio);
  }

  void _cropImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await _cropController.crop(pixelRatio: pixelRatio);
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      await _saveScreenShot(cropped).then((result) =>  Navigator.of(context).pop(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Crop',
          style: TextStyle(fontSize: 16, color: Colours.color_29292B),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colours.color_444648,
            size: 16,
          ),
          onPressed: () => IdolRoute.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _cropImage,
            tooltip: 'Crop',
            icon: Icon(Icons.crop),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Crop(
                onChanged: (decomposition) {
                  debugPrint(
                      "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                },
                controller: _cropController,
                shape: shape,
                child: Image.file(io.File(imageCropArguments.filePath),
                  fit: BoxFit.cover,
                ),
                /* It's very important to set `fit: BoxFit.cover`.
                   Do NOT remove this line.
                   There are a lot of issues on github repo by people who remove this line and their image is not shown correctly.
                */
                foreground: IgnorePointer(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Foreground Object',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                helper: shape == BoxShape.rectangle
                    ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                )
                    : null,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.undo),
                tooltip: 'Undo',
                onPressed: () {
                  _cropController.rotation = 0;
                  _cropController.scale = 1;
                  _cropController.offset = Offset.zero;
                  setState(() {
                    _rotation = 0;
                  });
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: theme.sliderTheme.copyWith(
                    trackShape: CenteredRectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    divisions: 360,
                    value: _rotation,
                    min: -180,
                    max: 180,
                    label: '$_rotation°',
                    onChanged: (n) {
                      setState(() {
                        _rotation = n.roundToDouble();
                        _cropController.rotation = _rotation;
                      });
                    },
                  ),
                ),
              ),
              ...(CropType.custom == imageCropArguments.cropType) ? [
                PopupMenuButton<BoxShape>(
                  icon: Icon(Icons.crop_free),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Box"),
                      value: BoxShape.rectangle,
                    ),
                    PopupMenuItem(
                      child: Text("Oval"),
                      value: BoxShape.circle,
                    ),
                  ],
                  tooltip: 'Crop Shape',
                  onSelected: (x) {
                    setState(() {
                      shape = x;
                    });
                  },
                ),
                PopupMenuButton<double>(
                  icon: Icon(Icons.aspect_ratio),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Original"),
                      value: 1000 / 667.0,
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      child: Text("16:9"),
                      value: 16.0 / 9.0,
                    ),
                    PopupMenuItem(
                      child: Text("4:3"),
                      value: 4.0 / 3.0,
                    ),
                    PopupMenuItem(
                      child: Text("1:1"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("3:4"),
                      value: 3.0 / 4.0,
                    ),
                    PopupMenuItem(
                      child: Text("9:16"),
                      value: 9.0 / 16.0,
                    ),
                  ],
                  tooltip: 'Aspect Ratio',
                  onSelected: (x) {
                    _cropController.aspectRatio = x;
                    setState(() {});
                  },
                ),
              ] : [],
            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> _saveScreenShot(ui.Image img) async {
  var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  var buffer = byteData.buffer.asUint8List();
  final result = await ImageGallerySaver.saveImage(buffer);
  debugPrint('Image crop result >>> $result');
  return result;
}