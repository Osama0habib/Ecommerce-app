import 'package:flutter/material.dart';

class PreviewImageFullScreen extends StatelessWidget {
   const PreviewImageFullScreen({Key? key,required this.id, required this.image}) : super(key: key);

  final dynamic id;
  final ImageProvider<Object> image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: id,
          child: Image(image: image,fit: BoxFit.cover,),
        ),
      ),
    );
  }
}