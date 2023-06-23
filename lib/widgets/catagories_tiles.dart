import 'package:WallpaperHub/views/categorie_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesTiles extends StatelessWidget {
  final String imgUrl, title;
  const CategoriesTiles({super.key, required this.imgUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoriesScreenView(
                    categorieName: title.toLowerCase(),
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 4.w),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0.r),
            child: Image.network(
              imgUrl,
              height: 50.0.h,
              width: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 50.0.h,
            width: 100.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8.0.r),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
