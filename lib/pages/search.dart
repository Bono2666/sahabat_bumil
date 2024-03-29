import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var keyText = TextEditingController();
  String keySearch = '';
  List<QueryDocumentSnapshot> listArticle;
  List dbForum;
  int articleCount = 0;
  int forumNotEmpty = 0;

  Future getForum() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_search_forum.php?keyword=$keySearch');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: [
      GestureType.onTap,
      GestureType.onVerticalDragDown,
    ],
    child: Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('article').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitPulse(
                  color: Theme.of(context).primaryColor,
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done)
            listArticle = snapshot.data.docs;
          if (articleCount == 0) {
            for (int i = 0; i < listArticle.length; i++)
              if ((listArticle[i].get('title').toString().toLowerCase()
                  .contains(keySearch.toLowerCase()) ||
                  listArticle[i].get('content').toString().toLowerCase()
                      .contains(keySearch.toLowerCase())) && keySearch != '')
                articleCount = 1;
          }
          return FutureBuilder(
            future: getForum(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitDoubleBounce(
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                dbForum = snapshot.data as List;
              }
              if (keySearch != '' && dbForum.isNotEmpty) {
                forumNotEmpty = 1;
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 19.0.h,),
                        forumNotEmpty == 0 ? Container() : Padding(
                          padding: EdgeInsets.only(left: 6.7.w),
                          child: Text(
                            'FORUM',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                        ),
                        forumNotEmpty == 0 ? Container() : SizedBox(height: 1.8.h,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbForum.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            if (keySearch != '') {
                              return Column(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            child: Container(
                                              color: Theme.of(context).primaryColor,
                                              child: dbForum[index]['photo'] == ''
                                                  ? Image.asset(
                                                'images/no_img.png',
                                                height: 13.3.w,
                                                width: 13.3.w,
                                                fit: BoxFit.cover,
                                              )
                                                  : Image.network(
                                                dbForum[index]['photo'],
                                                height: 13.3.w,
                                                width: 13.3.w,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return SizedBox(
                                                    height: 13.3.w,
                                                    child: const Center(
                                                      child: SpinKitDoubleBounce(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.4.w,),
                                          Flexible(
                                            child: Text(
                                              dbForum[index]['title'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      prefs.setQuestionId(dbForum[index]['id']);
                                      prefs.setBackRoute('/home');
                                      Navigator.pushNamed(context, '/questionView');
                                    },
                                  ),
                                  SizedBox(height: 2.2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.0.h,),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        forumNotEmpty == 0 ? Container() : SizedBox(height: 3.8.h,),
                        articleCount == 0 ? Container() : Padding(
                          padding: EdgeInsets.only(left: 6.7.w),
                          child: Text(
                            'ARTIKEL',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                        ),
                        articleCount == 0 ? Container() : SizedBox(height: 1.8.h,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: listArticle.length,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            if ((listArticle[index].get('title').toString().toLowerCase()
                                .contains(keySearch.toLowerCase()) ||
                                listArticle[index].get('content').toString().toLowerCase()
                                    .contains(keySearch.toLowerCase())) && keySearch != '') {
                              return Column(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            child: Container(
                                              child: Image.network(
                                                listArticle[index].get('image'),
                                                height: 13.3.w,
                                                width: 13.3.w,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return SizedBox(
                                                    height: 13.3.w,
                                                    child: Center(
                                                      child: SpinKitPulse(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(width: 4.4.w,),
                                          Flexible(
                                            child: Text(
                                              listArticle[index].get('title'),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.background,
                                                fontSize: 13.0.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      prefs.setArticleId(listArticle[index].id);
                                      Navigator.pushNamed(context, '/viewarticle');
                                    },
                                  ),
                                  SizedBox(height: 2.2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context).secondaryHeaderColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.0.h,),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        SizedBox(height: 12.5.h,),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 4.0.h,
                        color: Colors.white,
                      ),
                      Container(
                        height: 11.0.h,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white, Colors.white.withOpacity(0.0),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 22.8.w),
                    child: SizedBox(
                      height: 15.0.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.2.h),
                            child: Container(
                              width: 70.5.w,
                              height: 11.7.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(24)),
                                border: Border.all(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0.w),
                                    child: Image.asset(
                                      'images/ic_search.png',
                                      height: 5.3.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 36.4.w, right: 18.8.w),
                    child: SizedBox(
                      height: 15.0.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.2.h),
                            child: SizedBox(
                              height: 11.7.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    controller: keyText,
                                    onChanged: (String str) {
                                      setState(() {
                                        keySearch = str;
                                        articleCount = 0;
                                      });
                                    },
                                    autofocus: true,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Cari pertanyaan, artikel',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).shadowColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  keyText.text == '' ? Container() : SizedBox(
                    height: 15.0.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 11.0.w, bottom: 2.2.h),
                              child: SizedBox(
                                height: 11.7.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          keyText.text = '';
                                          keySearch = '';
                                          articleCount = 0;
                                        });
                                      },
                                      child: Image.asset(
                                        'images/ic_clear.png',
                                        height: 4.4.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 19.0.w,
                              height: 15.0.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  SizedBox(
                                    width: 19.0.w,
                                    height: 19.0.w,
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: 5.2.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    ),
  );
}
