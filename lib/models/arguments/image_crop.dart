import 'package:flutter/material.dart';
import 'package:idol/models/arguments/base.dart';
import 'package:idol/screen/module_store/image_crop.dart';

@immutable
class ImageCropArguments implements Arguments{
  final String filePath;
  final CropType cropType;

  const ImageCropArguments(this.filePath, {this.cropType = CropType.custom});
}