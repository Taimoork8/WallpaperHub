import 'dart:convert';
import 'package:WallpaperHub/data/data.dart';
import 'package:WallpaperHub/widgets/appbar_widget.dart';
import 'package:WallpaperHub/widgets/wallpapers_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../models/photos_model.dart';

class SearchScreenView extends StatefulWidget {
  final String searchQuery;
  const SearchScreenView({super.key, required this.searchQuery});

  @override
  State<SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<SearchScreenView> {
  TextEditingController searchController = TextEditingController();
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
    wallpapers.clear();
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
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
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
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f8fd),
                      borderRadius: BorderRadius.circular(25.0.r),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search wallpapers',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();
                            await getSearchWallpapers(
                                searchController.text.toString());
                            setState(() {});
                          },
                          child: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
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
