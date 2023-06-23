import 'dart:convert';
import 'package:WallpaperHub/data/data.dart';
import 'package:WallpaperHub/models/categories_model.dart';
import 'package:WallpaperHub/models/photos_model.dart';
import 'package:WallpaperHub/views/search.dart';
import 'package:WallpaperHub/widgets/catagories_tiles.dart';
import 'package:WallpaperHub/widgets/wallpapers_listview.dart';
import 'package:flutter/material.dart';
import 'package:WallpaperHub/widgets/appbar_widget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoriesModel> categories = [];
  List<PhotosModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  getTrandingWallpapers() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=85"),
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
    getTrandingWallpapers();
    categories = getCategories();
    initialization();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                      InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreenView(
                                searchQuery: searchController.text.toString(),
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                SizedBox(
                  height: 80.0.h,
                  child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemBuilder: ((context, index) {
                      return CategoriesTiles(
                        imgUrl: categories[index].imgUrl,
                        title: categories[index].categorieName,
                      );
                    }),
                  ),
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
      ),
    );
  }
}
