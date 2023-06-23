import 'dart:convert';
import 'package:WallpaperHub/data/data.dart';
import 'package:WallpaperHub/widgets/wallpapers_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/photos_model.dart';
import 'package:http/http.dart' as http;

import '../widgets/appbar_widget.dart';

class CategoriesScreenView extends StatefulWidget {
  final String categorieName;

  const CategoriesScreenView({
    super.key,
    required this.categorieName,
  });

  @override
  State<CategoriesScreenView> createState() => _CategoriesScreenViewState();
}

class _CategoriesScreenViewState extends State<CategoriesScreenView> {
  List<PhotosModel> wallpapers = [];
  bool isLoading = true;

  getSearchWallpapers(String query) async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=80"),
      headers: {
        "Authorization": apiKey,
      },
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      PhotosModel wallpaperModel = PhotosModel();
      wallpaperModel = PhotosModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getSearchWallpapers(widget.categorieName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: brandName(),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0.h,
                  ),
                  wallpaperList(wallpapers = wallpapers, context = context),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.white60,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ));
  }
}
