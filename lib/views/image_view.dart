import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  const ImageView({
    super.key,
    required this.imgUrl,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      await GallerySaver.saveImage(widget.imgUrl)
                          .then((success) {
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 60.0.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1B1B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                      ),
                      Container(
                        height: 60.0.h,
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0.w,
                          vertical: 8.0.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white30,
                            width: 1.0.w,
                          ),
                          borderRadius: BorderRadius.circular(40.0.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Set Wallpaper',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0.sp,
                              ),
                            ),
                            Text(
                              'Image will be saved in Gallery',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
