import 'package:WallpaperHub/views/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/photos_model.dart';

Widget wallpaperList(List<PhotosModel> wallpapers, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
    child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: const ClampingScrollPhysics(),
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0.h,
      crossAxisSpacing: 6.0.w,
      children: wallpapers.map((data) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(
                    imgUrl: data.src!.portrait as String,
                  ),
                ),
              );
            },
            child: Hero(
              tag: data.src!.medium as String,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.network(
                  data.src!.medium as String,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
