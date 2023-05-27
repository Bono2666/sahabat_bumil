import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/db/branch_db.dart';
import 'package:sahabat_bumil_v2/db/checklist_db.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sahabat_bumil_v2/model/branch_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage, totalDays;
  String imageUrl = '', imgChecklist = '', basecount = '', isAdmin = '0';
  PageController pageController;
  List<QueryDocumentSnapshot> document, checkListData, listArticle, homeImage;
  List dbBranch, dbNotifications, dbQuestionNotif, dbQuestions, dbReply, dbProfile;
  List<_MenuItem> item = [
    _MenuItem('Pemantau', 'images/ic_bumil.png'),
    _MenuItem('Tanya ke Forum', 'images/ic_forum.png'),
    _MenuItem('Nama Bayi', 'images/ic_baby_white.png'),
    _MenuItem('Aqiqah', 'images/ic_aqiqah.png'),
    _MenuItem('Profil', 'images/ic_profil.png'),
    _MenuItem('Artikel', 'images/ic_white_article.png'),
  ];
  var db = ChecklistDb();
  var branchDb = BranchDb();
  var lat, long;

  Future getNotifications() async {
    var url;
    if (isAdmin == '0') {
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_notifications.php?phone=${prefs.getPhone}');
    } else {
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_adm_notif.php');
    }
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getQuestionNotif() async {
    var url, response;
    if (isAdmin == '0') {
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_question_notif.php?status=${'2'}');
    } else {
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_question_notif.php?status=${'0'}');
    }
    response = await http.get(url);
    return json.decode(response.body);
  }

  Future getQuestions() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_all_questions.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getReply(String id) async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_reply.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getUser() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_user.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getBranches() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_branches.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updLatLong() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/upd_latlong.php?phone=${prefs.getPhone}&lat=${prefs.getCurrLat}&long=${prefs.getCurrLong}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    prefs.setFirstlaunch(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('home').get(),
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
                        color: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      listArticle = snapshot.data.docs;
                      listArticle.shuffle();
                    }
                    return FutureBuilder(
                      future: getBranches(),
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
                        if (snapshot.connectionState == ConnectionState.done) {
                          dbBranch = snapshot.data;
                          for (int i=0; i < dbBranch.length; i++) {
                            if (double.parse(dbBranch[i]['latitude']) != 0) {
                              double startLat = prefs.getCurrLat;
                              double startLong = prefs.getCurrLong;
                              double endLat = double.parse(dbBranch[i]['latitude']);
                              double endLong = double.parse(dbBranch[i]['longitude']);
                              double distance = Geolocator.distanceBetween(
                                  startLat, startLong, endLat, endLong);

                              var _distance = Branch(
                                branchId: int.parse(dbBranch[i]['id']),
                                branchDistance: distance,
                              );
                              branchDb.updateDistance(_distance);
                            }
                          }
                        }
                        return FutureBuilder(
                          future: getQuestions(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                              return
                                SizedBox(
                                    width: 100.0.w,
                                    height: 100.0.h,
                                    child: Center(
                                        child: SpinKitPulse(
                                          color: Theme.of(context).primaryColor,
                                        )
                                    )
                                );
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              dbQuestions = snapshot.data as List;
                            }
                            return FutureBuilder(
                              future: getUser(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                  return
                                    SizedBox(
                                        width: 100.0.w,
                                        height: 100.0.h,
                                        child: Center(
                                            child: SpinKitPulse(
                                              color: Theme.of(context).primaryColor,
                                            )
                                        )
                                    );
                                }
                                if (snapshot.connectionState == ConnectionState.done) {
                                  dbProfile = snapshot.data as List;

                                  if (prefs.getIsSignIn) {
                                    updLatLong();
                                    isAdmin = dbProfile[0]['midwife'];
                                    if (dbProfile[0]['basecount'] == '') {
                                      if (prefs.getBasecount != '') {
                                        basecount = prefs.getBasecount;
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
                                        currentPage = DateTime.now().difference(hpht).inDays;
                                        if (currentPage > 286) currentPage = 286;
                                        pageController = PageController(initialPage: currentPage);
                                        totalDays = hpl.difference(hpht).inDays;
                                      }
                                    } else {
                                      basecount = dbProfile[0]['basecount'];
                                      DateTime hpht = DateTime(
                                          int.parse(dbProfile[0]['hpht'].substring(0, 4)),
                                          int.parse(dbProfile[0]['hpht'].substring(5, 7)),
                                          int.parse(dbProfile[0]['hpht'].substring(8, 10))
                                      );
                                      DateTime hpl = DateTime(
                                          int.parse(dbProfile[0]['hpl'].substring(0, 4)),
                                          int.parse(dbProfile[0]['hpl'].substring(5, 7)),
                                          int.parse(dbProfile[0]['hpl'].substring(8, 10))
                                      );
                                      currentPage = (DateTime.now().difference(hpht).inDays);
                                      if (currentPage > 286) currentPage = 286;
                                      pageController = PageController(initialPage: currentPage);
                                      totalDays = hpl.difference(hpht).inDays;
                                    }
                                  } else {
                                    if (prefs.getBasecount != '') {
                                      basecount = prefs.getBasecount;
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
                                      currentPage = DateTime.now().difference(hpht).inDays;
                                      if (currentPage > 286) currentPage = 286;
                                      pageController = PageController(initialPage: currentPage);
                                      totalDays = hpl.difference(hpht).inDays;
                                    }
                                  }
                                }
                                return FutureBuilder(
                                  future: getNotifications(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                      return
                                        SizedBox(
                                            width: 100.0.w,
                                            height: 100.0.h,
                                            child: Center(
                                                child: SpinKitPulse(
                                                  color: Theme.of(context).primaryColor,
                                                )
                                            )
                                        );
                                    }
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      dbNotifications = snapshot.data as List;
                                    }
                                    return FutureBuilder(
                                      future: getQuestionNotif(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                          return
                                            SizedBox(
                                                width: 100.0.w,
                                                height: 100.0.h,
                                                child: Center(
                                                    child: SpinKitPulse(
                                                      color: Theme.of(context).primaryColor,
                                                    )
                                                )
                                            );
                                        }
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          dbQuestionNotif = snapshot.data as List;
                                        }
                                        return Stack(
                                          alignment: AlignmentDirectional.bottomEnd,
                                          children: [
                                            SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              child: Container(
                                                width: 100.0.w,
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          width: 100.0.w,
                                                          height: 88.9.w,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).primaryColor,
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(60),
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(60),
                                                            ),
                                                            child: Image.network(
                                                              basecount == ''
                                                                  ? homeImage[0].get('image')
                                                                  : document[currentPage].get('image'),
                                                              fit: BoxFit.cover,
                                                              loadingBuilder: (context, child, loadingProgress) {
                                                                if (loadingProgress == null) return child;
                                                                return Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: basecount == ''
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
                                                        ),
                                                        basecount == '' ? Container() : Container(
                                                          height: 85.6.w,
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
                                                                      DateFormat('MMM yyyy', 'id_ID').format(DateTime.now()),
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
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 4.4.h,),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                                                            child: InkWell(
                                                              onTap: () => Navigator.pushNamed(context, '/search'),
                                                              child: Container(
                                                                height: 11.7.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(24)),
                                                                  border: Border.all(
                                                                    color: Theme.of(context).colorScheme.background,
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
                                                                      'Cari pertanyaan, artikel',
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
                                                          SizedBox(height: 3.8.h,),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 24.8.w,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: item.length,
                                                        physics: BouncingScrollPhysics(),
                                                        padding: EdgeInsets.fromLTRB(11.8.w, 0, 9.0.w, 3.1.w),
                                                        scrollDirection: Axis.horizontal,
                                                        itemBuilder: (context, index) {
                                                          return Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  switch (index) {
                                                                    case 0:
                                                                      prefs.setRoute('/home');
                                                                      prefs.setGoRoute('/monitoring');
                                                                      if (!prefs.getIsSignIn) {
                                                                        Navigator.pushNamed(context, '/register');
                                                                      } else {
                                                                        if (basecount == '') {
                                                                          Navigator.pushNamed(context, '/updpregnancy');
                                                                        } else {
                                                                          Navigator.pushNamed(context, '/monitoring');
                                                                        }
                                                                      }
                                                                      break;
                                                                    case 1:
                                                                      prefs.setBackRoute('/home');
                                                                      if (!prefs.getIsSignIn) {
                                                                        prefs.setGoRoute('/newquestion');
                                                                        Navigator.pushNamed(context, '/register');
                                                                      } else {
                                                                        Navigator.pushNamed(context, '/newquestion');
                                                                      }
                                                                      break;
                                                                    case 2:
                                                                      prefs.setRoute('/home');
                                                                      Navigator.pushNamed(context, '/babysname');
                                                                      break;
                                                                    case 3:
                                                                      prefs.setRoute('/home');
                                                                      Navigator.pushNamed(context, '/aqiqah');
                                                                      break;
                                                                    case 4:
                                                                      prefs.setRoute('/home');
                                                                      if (!prefs.getIsSignIn) {
                                                                        prefs.setGoRoute('/profile');
                                                                        Navigator.pushNamed(context, '/register');
                                                                      } else {
                                                                        Navigator.pushNamed(context, '/profile');
                                                                      }
                                                                      break;
                                                                    case 5:
                                                                      Navigator.pushNamed(context, '/articles');
                                                                      break;
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                  width: 16.7.w,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Stack(
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
                                                                                item[index].icon,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 2.5.w,),
                                                                      Text(
                                                                        item[index].title,
                                                                        style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.background,
                                                                          fontSize: 10.0.sp,
                                                                        ),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(width: 3.3.w,)
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(height: 3.0.h,),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 6.6.w,),
                                                      child: Row(
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
                                                              color: Theme.of(context).colorScheme.background,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.8.h,),
                                                    SizedBox(
                                                      height: 69.6.w,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: listArticle.length > 3 ? 3 : listArticle.length,
                                                        physics: BouncingScrollPhysics(),
                                                        padding: EdgeInsets.fromLTRB(6.6.w, 0, 2.4.w, 3.1.w),
                                                        scrollDirection: Axis.horizontal,
                                                        itemBuilder: (context, index) {
                                                          return Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  prefs.setArticleId(listArticle[index].id);
                                                                  Navigator.pushNamed(context, '/viewarticle');
                                                                },
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
                                                                            color: Theme.of(context).colorScheme.background,
                                                                            fontSize: 13.0.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(width: 3.9.w,)
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 6.6.w,),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Image.asset(
                                                                'images/ic_forum_color.png',
                                                                height: 3.2.w,
                                                              ),
                                                              SizedBox(width: 1.4.w,),
                                                              Column(
                                                                children: [
                                                                  SizedBox(height: 0.8.w,),
                                                                  Text(
                                                                    'Forum',
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 10.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 2.8.h,),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: dbQuestions.length,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                                                        itemBuilder: (context, index) {
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    prefs.setBackRoute('/home');
                                                                    prefs.setQuestionId(dbQuestions[index]['id']);
                                                                    Navigator.pushNamed(context, '/questionView');
                                                                  },
                                                                  child: Container(
                                                                    width: 86.6.w,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: const BorderRadius.all(
                                                                          Radius.circular(12),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color: Theme.of(context).shadowColor,
                                                                            blurRadius: 6.0,
                                                                            offset: const Offset(0, 3),
                                                                          ),
                                                                        ]),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        dbQuestions[index]['photo'] == '' ? Container() : ClipRRect(
                                                                          borderRadius:
                                                                          const BorderRadius.only(
                                                                            topLeft:
                                                                            Radius.circular(12),
                                                                            topRight:
                                                                            Radius.circular(12),
                                                                          ),
                                                                          child: Container(
                                                                            color: Theme.of(context).primaryColor,
                                                                            child: Image.network(
                                                                              dbQuestions[index]['photo'],
                                                                              height: 43.0.w,
                                                                              width: 86.6.w,
                                                                              fit: BoxFit.cover,
                                                                              loadingBuilder: (context,
                                                                                  child,
                                                                                  loadingProgress) {
                                                                                if (loadingProgress ==
                                                                                    null) {
                                                                                  return child;
                                                                                }
                                                                                return SizedBox(
                                                                                  height: 43.0.w,
                                                                                  child: const Center(
                                                                                    child:
                                                                                    SpinKitPulse(
                                                                                      color: Colors
                                                                                          .white,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(4.4.w, 5.6.w, 4.4.w, 5.6.w),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                dbQuestions[index]['title'],
                                                                                style: TextStyle(
                                                                                  color: Theme.of(context).colorScheme.background,
                                                                                  fontSize: 13.0.sp,
                                                                                  fontWeight: FontWeight.w700,
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 2.8.w,),
                                                                              Text(
                                                                                dbQuestions[index]['description'],
                                                                                style: TextStyle(
                                                                                  color: Theme.of(context).primaryColorDark,
                                                                                  fontSize: 13.0.sp,
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 3.3.w,),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Stack(
                                                                                    alignment: AlignmentDirectional.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 6.7.w,
                                                                                        height: 6.7.w,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                                                          color: Theme.of(context).primaryColor,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 3.1.w,
                                                                                        height: 3.1.w,
                                                                                        child: FittedBox(
                                                                                          child: Image.asset(
                                                                                            'images/ic_profil.png',
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: 1.4.w,),
                                                                                  Column(
                                                                                    children: [
                                                                                      SizedBox(height: 0.8.w,),
                                                                                      Text(
                                                                                        dbQuestions[index]['name'] == '' ? 'Anonymous' : dbQuestions[index]['name'],
                                                                                        style: TextStyle(
                                                                                          color: Theme.of(context).colorScheme.background,
                                                                                          fontSize: 10.0.sp,
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const Expanded(child: SizedBox()),
                                                                                  FutureBuilder(
                                                                                    future: getReply(dbQuestions[index]['id']),
                                                                                    builder: (context, snapshot) {
                                                                                      if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                                                                        return Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            SpinKitThreeBounce(
                                                                                              color: Theme.of(context).primaryColor,
                                                                                              size: 16,
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      }
                                                                                      if (snapshot.connectionState == ConnectionState.done) {
                                                                                        dbReply = snapshot.data as List;
                                                                                      }
                                                                                      return dbReply.isEmpty ? Container() : Text(
                                                                                        '${dbReply.length.toString()} Tanggapan',
                                                                                        style: TextStyle(
                                                                                          color: Theme.of(context).colorScheme.background,
                                                                                          fontSize: 10.0.sp,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 3.3.w,),
                                                                              InkWell(
                                                                                child: Container(
                                                                                  width: 78.9.w,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                                                                                    border: Border.all(
                                                                                      color: Theme.of(context).colorScheme.background,
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 4.4.w,),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        SizedBox(height: 3.3.w,),
                                                                                        Text(
                                                                                          'Ketik komentar…',
                                                                                          style: TextStyle(
                                                                                            color: Theme.of(context).shadowColor,
                                                                                            fontSize: 13.0.sp,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 3.3.w,),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  prefs.setBackRoute('/home');
                                                                                  prefs.setQuestionId(dbQuestions[index]['id']);
                                                                                  if (!prefs.getIsSignIn) {
                                                                                    prefs.setGoRoute('/questionView');
                                                                                    Navigator.pushNamed(context, '/register');
                                                                                  } else {
                                                                                    Navigator.pushNamed(context, '/questionView');
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 2.5.h,),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.8.h,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(height: 5.6.h,),
                                                Padding(
                                                  padding: EdgeInsets.only(right: 6.6.w,),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Visibility(
                                                        visible: prefs.getIsSignIn ? true : false,
                                                        child: InkWell(
                                                          onTap: () {
                                                            prefs.setBackRoute('/home');
                                                            Navigator.pushNamed(context, '/notifications');
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
                                                                    color: Colors.white,
                                                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Theme.of(context).shadowColor,
                                                                        blurRadius: 6.0,
                                                                        offset: const Offset(0,3),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5.6.w,
                                                                height: 5.6.w,
                                                                child: FittedBox(
                                                                  child: Image.asset('images/ic_forum_color.png'),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: dbNotifications.isNotEmpty || dbQuestionNotif.isNotEmpty ? true : false,
                                                                child: Positioned(
                                                                  left: 7.8.w,
                                                                  top: 2.2.w,
                                                                  child: Container(
                                                                    width: 2.2.w,
                                                                    height: 2.2.w,
                                                                    decoration: BoxDecoration(
                                                                        color: Theme.of(context).colorScheme.error,
                                                                        borderRadius: const BorderRadius.all(
                                                                          Radius.circular(50),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2.2.w,),
                                                      InkWell(
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
                                                    ],
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
                            );
                          },
                        );
                      },
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

class _MenuItem {
  _MenuItem(this.title, this.icon);

  final String title;
  final String icon;
}