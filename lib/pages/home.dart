import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahabat_bumil_v2/db/checklist_db.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:format_indonesia/format_indonesia.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage, totalDays;
  String imageUrl = '', imgChecklist = '';
  PageController pageController;
  List<QueryDocumentSnapshot> document, checkListData, listArticle, homeImage;
  var db = ChecklistDb();

  @override
  void initState() {
    super.initState();

    prefs.setFirstlaunch(false);

    if (prefs.getBasecount != '') {
      DateTime hpht = DateTime(
          int.parse(prefs.getHPHT.substring(4, 8)),
          int.parse(prefs.getHPHT.substring(2, 4)),
          int.parse(prefs.getHPHT.substring(0, 2))
      );

      DateTime hpl = DateTime(
          int.parse(prefs.getHPL.substring(4, 8)),
          int.parse(prefs.getHPL.substring(2, 4)),
          int.parse(prefs.getHPL.substring(0, 2))
      );

      currentPage = (DateTime.now().difference(hpht).inDays);
      pageController = PageController(initialPage: currentPage);
      totalDays = (hpl.difference(hpht).inDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () => MinimizeApp.minimizeApp(),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('home').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPulse(
                    color: Colors.white,
                  ),
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              homeImage = snapshot.data.docs;
              homeImage.shuffle();
            }
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection('timeline').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitPulse(
                        color: Colors.white,
                      ),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  document = snapshot.data.docs;
                }
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('article').get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitPulse(
                            color: Colors.white,
                          ),
                        ],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      listArticle = snapshot.data.docs;
                      listArticle.shuffle();
                    }
                    return Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          height: 100.0.h,
                          width: 100.0.w,
                          color: Theme.of(context).primaryColor,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 100.0.w,
                                    height: 74.0.h,
                                    child: Image.network(
                                      prefs.getBasecount == ''
                                          ? homeImage[0].get('image')
                                          : document[currentPage].get('image'),
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: prefs.getBasecount == ''
                                                  ? EdgeInsets.only(top: 22.8.h)
                                                  : EdgeInsets.only(top: 15.8.h),
                                              child: SpinKitPulse(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 26.0.h,
                                  ),
                                ],
                              ),
                              prefs.getBasecount == '' ? Container() : Container(
                                height: 45.6.h,
                                padding: EdgeInsets.only(right: 7.2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Stack(
                                          alignment: AlignmentDirectional.topCenter,
                                          children: [
                                            Text(
                                              'Pekan',
                                              style: TextStyle(
                                                fontSize: 16.0.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 1.7.h),
                                              child: Text(
                                                document[currentPage].get('week').toString(),
                                                style: TextStyle(
                                                  fontSize: 60.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.8.h,)
                                      ],
                                    ),
                                    SizedBox(width: 3.8.w,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Stack(
                                          alignment: AlignmentDirectional.topCenter,
                                          children: [
                                            Text(
                                              'Hari',
                                              style: TextStyle(
                                                fontSize: 11.0.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 1.4.h,),
                                              child: Text(
                                                document[currentPage].get('day').toString(),
                                                style: TextStyle(
                                                  fontSize: 32.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.0.h,)
                                      ],
                                    ),
                                    SizedBox(width: 2.8.w,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            'Usia kehamilan',
                                            style: TextStyle(
                                              fontSize: 12.0.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.4.h,)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 36.0.w,
                                padding: EdgeInsets.only(right: 72.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Stack(
                                          alignment: AlignmentDirectional.topCenter,
                                          children: [
                                            Text(
                                              'Hari ini',
                                              style: TextStyle(
                                                fontSize: 12.0.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 1.4.h),
                                              child: Text(
                                                DateTime.now().day.toString(),
                                                style: TextStyle(
                                                  fontSize: 44.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.8.h,),
                                      ],
                                    ),
                                    SizedBox(width: 1.1.w,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            Waktu(DateTime.now()).yMMM(),
                                            style: TextStyle(
                                              fontSize: 12.0.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.4.h,)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.54,
                            minChildSize: 0.54,
                            maxChildSize: 1.0,
                            builder: (context, scrollController) {
                              return SingleChildScrollView(
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                child: Container(
                                  width: 100.0.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(56),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 1.8.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 8.6.w,
                                                  height: 0.5.h,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).secondaryHeaderColor,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.3.h,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                                              child: InkWell(
                                                onTap: () => Navigator.pushNamed(context, '/search'),
                                                child: Container(
                                                  height: 11.7.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                                      border: Border.all(
                                                          color: Theme.of(context).backgroundColor,
                                                      ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'images/ic_search.png',
                                                        height: 5.3.w,
                                                      ),
                                                      SizedBox(width: 3.3.w,),
                                                      Text(
                                                        'Cari artikel',
                                                        style: TextStyle(
                                                          fontSize: 12.0.sp,
                                                          color: Theme.of(context).primaryColorDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 3.0.h,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 5.2.w),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 16.7.w,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            prefs.setRoute('/home');
                                                            if (prefs.getBasecount == '') {
                                                              prefs.setGoRoute('/monitoring');
                                                              Navigator.pushNamed(context, '/addpregnancy');
                                                            }
                                                            else
                                                              Navigator.pushNamed(context, '/monitoring');
                                                          },
                                                          child: Stack(
                                                            alignment: AlignmentDirectional.center,
                                                            children: [
                                                              Container(
                                                                width: 11.1.w,
                                                                height: 11.1.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(30),
                                                                  ),
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 5.6.w,
                                                                height: 5.6.w,
                                                                child: FittedBox(
                                                                  child: Image.asset(
                                                                    'images/ic_bumil.png',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.5.w,),
                                                        Text(
                                                          'Pemantau',
                                                          style: TextStyle(
                                                            color: Theme.of(context).backgroundColor,
                                                            fontSize: 10.0.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(
                                                    width: 16.7.w,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            prefs.setRoute('/home');
                                                            Navigator.pushNamed(context, '/babysname');
                                                          },
                                                          child: Stack(
                                                            alignment: AlignmentDirectional.center,
                                                            children: [
                                                              Container(
                                                                width: 11.1.w,
                                                                height: 11.1.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(30),
                                                                  ),
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 5.6.w,
                                                                height: 5.6.w,
                                                                child: FittedBox(
                                                                  child: Image.asset(
                                                                    'images/ic_baby_white.png',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.5.w,),
                                                        Text(
                                                          'Nama Bayi',
                                                          style: TextStyle(
                                                            color: Theme.of(context).backgroundColor,
                                                            fontSize: 10.0.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(
                                                    width: 16.7.w,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            prefs.setRoute('/home');
                                                            if (prefs.getBasecount == '') {
                                                              prefs.setGoRoute('/home');
                                                              Navigator.pushNamed(context, '/addpregnancy');
                                                            }
                                                            else
                                                              Navigator.pushNamed(context, '/updpregnancy');
                                                          },
                                                          child: Stack(
                                                            alignment: AlignmentDirectional.center,
                                                            children: [
                                                              Container(
                                                                width: 11.1.w,
                                                                height: 11.1.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(30),
                                                                  ),
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 5.6.w,
                                                                height: 5.6.w,
                                                                child: FittedBox(
                                                                  child: Image.asset(
                                                                    'images/ic_profil.png',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.5.w,),
                                                        Text(
                                                          'Profil',
                                                          style: TextStyle(
                                                            color: Theme.of(context).backgroundColor,
                                                            fontSize: 10.0.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(
                                                    width: 16.7.w,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            prefs.setRoute('/home');
                                                            Navigator.pushReplacementNamed(context, '/aqiqah');
                                                          },
                                                          child: Stack(
                                                            alignment: AlignmentDirectional.center,
                                                            children: [
                                                              Container(
                                                                width: 11.1.w,
                                                                height: 11.1.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(30),
                                                                  ),
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 5.6.w,
                                                                height: 5.6.w,
                                                                child: FittedBox(
                                                                  child: Image.asset(
                                                                    'images/ic_aqiqah.png',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.5.w,),
                                                        Text(
                                                          'Aqiqah',
                                                          style: TextStyle(
                                                            color: Theme.of(context).backgroundColor,
                                                            fontSize: 10.0.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 3.8.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'images/ic_article.png',
                                                  height: 3.2.w,
                                                ),
                                                SizedBox(width: 1.4.w,),
                                                Text(
                                                  'Artikel',
                                                  style: TextStyle(
                                                    fontSize: 10.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 2.8.h,),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listArticle.length > 3 ? 3 : listArticle.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.only(top: 0),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  width: 86.6.w,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(context).shadowColor,
                                                          blurRadius: 6.0,
                                                          offset: Offset(0,3),
                                                        ),
                                                      ]
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(12),
                                                          topRight: Radius.circular(12),
                                                        ),
                                                        child: Container(
                                                          child: Image.network(
                                                            listArticle[index].get('image'),
                                                            height: 43.0.w,
                                                            width: 86.6.w,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                              if (loadingProgress == null) return child;
                                                              return SizedBox(
                                                                height: 43.0.w,
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
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(3.8.w,5.0.w,3.8.w,5.6.w),
                                                        child: Text(
                                                          listArticle[index].get('title'),
                                                          style: TextStyle(
                                                            color: Theme.of(context).backgroundColor,
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
                                              SizedBox(height: 3.8.w,)
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(height: 11.2.h,),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                        Column(
                          children: [
                            SizedBox(height: 5.6.h,),
                            Padding(
                              padding: EdgeInsets.only(right: 6.6.w,),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/features');
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Opacity(
                                      opacity: .8,
                                      child: Container(
                                        width: 12.5.w,
                                        height: 12.5.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6.0,
                                              color: Theme.of(context).shadowColor,
                                              offset: Offset(0, 3),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 5.6.w,
                                      height: 5.6.w,
                                      child: FittedBox(
                                        child: Image.asset(
                                          'images/ic_menu.png',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}