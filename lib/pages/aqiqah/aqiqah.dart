import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/db/prods_db.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

int prodId = 1;
String waNumber;

class Aqiqah extends StatefulWidget {
  @override
  _AqiqahState createState() => _AqiqahState();
}

class _AqiqahState extends State<Aqiqah> {
  int currentPage = 0, prevPage = 0;
  PageController pageController = new PageController();
  AsyncSnapshot<dynamic> dbPackages, dbRecomended;
  List lsRecomended, dbSetup, dbTopProducts, dbRecomendedList, dbPromo, dbBanner,
      dbTestimoni, dbInfo, dbBranch;
  bool onOpen = true;

  Future getBanner() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_banner.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getPackages() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_packages.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getRecomended() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_recomended.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getRecomendedProds() async {
    var url;
    if (prefs.getIsSignIn)
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_recomended_prods.php?phone=${prefs.getPhone}');
    else
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_recomended_prods.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getTopProds() async {
    var url;
    if (prefs.getIsSignIn)
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_top_products.php?phone=${prefs.getPhone}');
    else
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_top_products.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getTestimoni() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_testimoni.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getDummy() async {}

  Future getInfo() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_info.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getPromo() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_promo.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getBranches() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_branches.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addFav(String id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/add_fav.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'fav_prod' : id,
    });
  }

  Future delFav(int id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/del_fav.php';
    await http.post(Uri.parse(url), body: {
      'id' : id.toString(),
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      prevPage = currentPage;

      if (currentPage < (dbBanner.length - 1)) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInSine,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/home');
          return false;
        },
        child: FutureBuilder(
          future: getBanner(),
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
              dbBanner = snapshot.data;
            }
            return FutureBuilder(
              future: getPackages(),
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
                  dbPackages = snapshot;
                }
                return FutureBuilder(
                  future: getPromo(),
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
                      dbPromo = snapshot.data;
                    }
                    return FutureBuilder(
                      future: getRecomended(),
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
                          dbRecomended = snapshot;
                        }
                        return FutureBuilder(
                          future: getRecomendedProds(),
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
                              dbRecomendedList = snapshot.data;
                            }
                            return FutureBuilder(
                              future: getTopProds(),
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
                                  dbTopProducts = snapshot.data;
                                }
                                return FutureBuilder(
                                  future: getSetup(),
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
                                      dbSetup = snapshot.data;
                                      lsRecomended = dbRecomended.data;
                                    }
                                    return FutureBuilder(
                                      future: onOpen ? getTestimoni() : getDummy(),
                                      builder: (context, snapshot) {
                                        if (onOpen) {
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
                                            dbTestimoni = snapshot.data;
                                            dbTestimoni.shuffle();
                                            onOpen = false;
                                          }
                                        }
                                        return FutureBuilder(
                                          future: getInfo(),
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
                                              dbInfo = snapshot.data;
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
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
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
                                                                    child: PageView.builder(
                                                                      itemCount: dbBanner.length,
                                                                      controller: pageController,
                                                                      onPageChanged: (index) {
                                                                        setState(() {
                                                                          currentPage = index;
                                                                        });
                                                                      },
                                                                      itemBuilder: (context, index) {
                                                                        return InkWell(
                                                                          onTap: () {
                                                                            if (int.parse(dbBanner[index]['product']) > 0) {
                                                                              prodId = dbBanner[index]['product'];
                                                                              waNumber = dbSetup[0]['wa_number'];
                                                                              showModalBottomSheet(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(40),
                                                                                    topRight: Radius.circular(40),
                                                                                  ),
                                                                                ),
                                                                                backgroundColor: Colors.white,
                                                                                constraints: BoxConstraints(
                                                                                  minHeight: 165.0.w,
                                                                                  maxHeight: 165.0.w,
                                                                                ),
                                                                                isScrollControlled: true,
                                                                                context: context,
                                                                                builder: (context) => ViewProduct(),
                                                                              );
                                                                            }
                                                                            if (int.parse(dbBanner[index]['package']) > 0) {
                                                                              prefs.setIdPackage(dbBanner[index]['package'].toString());
                                                                              Navigator.pushNamed(context, '/package');
                                                                            }
                                                                            if (dbBanner[index]['link'] != '') {
                                                                              launchUrl(dbBanner[index]['link']);
                                                                            }
                                                                          },
                                                                          child: Image.network(
                                                                            dbBanner[currentPage]['image'],
                                                                            fit: BoxFit.fitWidth,
                                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                              if (loadingProgress == null) return child;
                                                                              return Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(top: 22.8.h),
                                                                                    child: SpinKitPulse(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 85.6.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsets.only(bottom: 1.9.h),
                                                                            child: SmoothPageIndicator(
                                                                              controller: pageController,
                                                                              count: dbBanner.length,
                                                                              effect: WormEffect(
                                                                                dotWidth: 1.5.w,
                                                                                dotHeight: 1.5.w,
                                                                                spacing: 3.0.w,
                                                                                activeDotColor: Theme.of(context).primaryColor,
                                                                                dotColor: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 4.4.h,),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                              child: Text(
                                                                'Apa kata mereka?',
                                                                style: TextStyle(
                                                                  fontSize: 20.0.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Theme.of(context).colorScheme.background,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 2.5.h,),
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: dbTestimoni.length > 3 ? 3 : dbTestimoni.length,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              padding: EdgeInsets.only(top: 0),
                                                              itemBuilder: (context, index) {
                                                                DateTime _date = DateTime.parse(dbTestimoni[index]['time']);
                                                                String _nm = '<b>' + dbTestimoni[index]['name'] + '</b>';
                                                                String _desc = ' | ' + dbTestimoni[index]['description'];
                                                                return Column(
                                                                  children: [
                                                                    Container(
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
                                                                          dbTestimoni[index]['image'] == '' ? Container() : ClipRRect(
                                                                            borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(12),
                                                                              topRight: Radius.circular(12),
                                                                            ),
                                                                            child: Container(
                                                                              child: Image.network(
                                                                                dbTestimoni[index]['image'],
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
                                                                            padding: EdgeInsets.symmetric(horizontal: 4.4.w, vertical: 5.6.w,),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Stack(
                                                                                      alignment: AlignmentDirectional.center,
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 6.7.w,
                                                                                          height: 6.7.w,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(30),
                                                                                            ),
                                                                                            color: Theme.of(context).primaryColor,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 3.1.w,
                                                                                          height: 3.1.w,
                                                                                          child: FittedBox(
                                                                                            child: Image.asset(
                                                                                              'images/ic_profil.png',
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(width: 1.7.w,),
                                                                                    Flexible(
                                                                                      child: Html(
                                                                                        data: dbTestimoni[index]['description'] == '' ? _nm : _nm + _desc,
                                                                                        style: {
                                                                                          'body': Style(
                                                                                            color: Theme.of(context).colorScheme.background,
                                                                                            fontSize: FontSize(10.0.sp),
                                                                                            maxLines: 1,
                                                                                            textOverflow: TextOverflow.ellipsis,
                                                                                            margin: EdgeInsets.all(0),
                                                                                          ),
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 2.2.w,),
                                                                                Text(
                                                                                  '${DateFormat('d MMM yyyy', 'id_ID').format(_date)} ${' '} ${DateFormat.Hm().format(_date)}',
                                                                                  style: TextStyle(
                                                                                    color: Theme.of(context).unselectedWidgetColor,
                                                                                    fontSize: 7.0.sp,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 2.2.w,),
                                                                                Html(
                                                                                  data: dbTestimoni[index]['message'],
                                                                                  style: {
                                                                                    'body': Style(
                                                                                      color: Theme.of(context).primaryColorDark,
                                                                                      fontSize: FontSize(13.0.sp),
                                                                                      margin: EdgeInsets.all(0),
                                                                                    ),
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 3.1.h,)
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(height: 6.7.w,),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.7.w),
                                                              child: InkWell(
                                                                onTap: () => Navigator.pushNamed(context, '/testimoni'),
                                                                child: Container(
                                                                  height: 11.7.w,
                                                                  width: 100.0.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                                                    border: Border.all(
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Lihat semua testimoni',
                                                                      style: TextStyle(
                                                                        fontSize: 10.0.sp,
                                                                        color: Theme.of(context).colorScheme.background,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 5.6.h,),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Image.asset(
                                                                    'images/ic_package.png',
                                                                    height: 2.8.w,
                                                                  ),
                                                                  SizedBox(width: 1.4.w,),
                                                                  Text(
                                                                    'Paket',
                                                                    style: TextStyle(
                                                                      fontSize: 10.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 1.9.h,),
                                                            SizedBox(
                                                              height: 34.0.w,
                                                              child: ListView.builder(
                                                                itemCount: dbPackages.data.length,
                                                                scrollDirection: Axis.horizontal,
                                                                physics: BouncingScrollPhysics(),
                                                                padding: EdgeInsets.only(left: 6.6.w, right: 2.2.w),
                                                                itemBuilder: (context, index) {
                                                                  List lsPackages = dbPackages.data;
                                                                  return Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                                        child: InkWell(
                                                                          child: Container(
                                                                            width: 31.1.w,
                                                                            height: 31.1.w,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  width: 0.5,
                                                                                  color: Theme.of(context).colorScheme.background,
                                                                                ),
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
                                                                            child: Stack(
                                                                              alignment: AlignmentDirectional.bottomStart,
                                                                              children: [
                                                                                Positioned(
                                                                                  left: 4.4.w,
                                                                                  bottom: 8.6.w,
                                                                                  child: SizedBox(
                                                                                    height: 23.3.w,
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Image.network(
                                                                                          lsPackages[index]['image'],
                                                                                          height: 11.1.w,
                                                                                          fit: BoxFit.cover,
                                                                                          loadingBuilder: (context, child, loadingProgress) {
                                                                                            if (loadingProgress == null) return child;
                                                                                            return SizedBox(
                                                                                              height: 11.1.w,
                                                                                              child: Center(
                                                                                                child: SpinKitPulse(
                                                                                                  color: Theme.of(context).primaryColor,
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.all(4.4.w),
                                                                                  child: Text(
                                                                                    lsPackages[index]['name'],
                                                                                    style: TextStyle(
                                                                                      color: Theme.of(context).colorScheme.background,
                                                                                      fontSize: 8.0.sp,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          onTap: () {
                                                                            prefs.setIdPackage(lsPackages[index]['id']);
                                                                            Navigator.pushNamed(context, '/package');
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 4.4.w,)
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(height: 3.8.h,),
                                                            dbPromo.length < 1 ? Container() : Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Promo hari ini',
                                                                    style: TextStyle(
                                                                      fontSize: 20.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 0.6.h,),
                                                                  Text(
                                                                    'Manfaatkan promo jangan dilewatkan',
                                                                    style: TextStyle(
                                                                      fontSize: 10.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            dbPromo.length < 1 ? Container() : SizedBox(height: 1.9.h,),
                                                            dbPromo.length < 1 ? Container() : SizedBox(
                                                              height: 68.9.w,
                                                              child: ListView.builder(
                                                                itemCount: dbPromo.length,
                                                                scrollDirection: Axis.horizontal,
                                                                physics: BouncingScrollPhysics(),
                                                                padding: EdgeInsets.only(left: 3.9.w, right: 4.9.w),
                                                                itemBuilder: (context, index) {
                                                                  return Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                                        child: InkWell(
                                                                          child: Stack(
                                                                            alignment: AlignmentDirectional.bottomStart,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 2.8.w,),
                                                                                child: Container(
                                                                                  width: 61.1.w,
                                                                                  height: 66.7.w,
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
                                                                                          color: Theme.of(context).primaryColor,
                                                                                          child: Image.network(
                                                                                            dbPromo[index]['image'],
                                                                                            height: 40.0.w,
                                                                                            fit: BoxFit.cover,
                                                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                                              if (loadingProgress == null) return child;
                                                                                              return SizedBox(
                                                                                                height: 40.0.w,
                                                                                                child: Center(
                                                                                                  child: SpinKitPulse(
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.all(4.4.w),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              dbPromo[index]['title'],
                                                                                              style: TextStyle(
                                                                                                color: Theme.of(context).colorScheme.background,
                                                                                                fontSize: 12.0.sp,
                                                                                                fontWeight: FontWeight.w700,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 1.1.w,),
                                                                                            Text(
                                                                                              dbPromo[index]['description'],
                                                                                              style: TextStyle(
                                                                                                color: Theme.of(context).colorScheme.background,
                                                                                                fontSize: 8.0.sp,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(7.2.w, 0, 4.4.w, 4.4.w),
                                                                                child: Text(
                                                                                  dbPromo[index]['price'],
                                                                                  style: TextStyle(
                                                                                    color: Theme.of(context).colorScheme.background,
                                                                                    fontSize: 10.0.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(bottom: 54.9.w,),
                                                                                child: Image.asset(
                                                                                  'images/bg_label.png',
                                                                                  height: 7.9.w,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(3.4.w, 0, 0, 58.1.w),
                                                                                child: Text(
                                                                                  dbPromo[index]['label'],
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 9.0.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          onTap: () {
                                                                            if (int.parse(dbPromo[index]['product']) > 0) {
                                                                              prodId = int.parse(dbPromo[index]['product']);
                                                                              waNumber = dbSetup[0]['wa_number'];
                                                                              showModalBottomSheet(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(40),
                                                                                    topRight: Radius.circular(40),
                                                                                  ),
                                                                                ),
                                                                                backgroundColor: Colors.white,
                                                                                constraints: BoxConstraints(
                                                                                  minHeight: 165.0.w,
                                                                                  maxHeight: 165.0.w,
                                                                                ),
                                                                                isScrollControlled: true,
                                                                                context: context,
                                                                                builder: (context) => ViewProduct(),
                                                                              );
                                                                            }
                                                                            if (int.parse(dbPromo[index]['package']) > 0) {
                                                                              prefs.setIdPackage(dbPromo[index]['package'].toString());
                                                                              Navigator.pushNamed(context, '/package');
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 1.7.w,)
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            dbPromo.length < 1 ? Container() : SizedBox(height: 3.8.h,),
                                                            dbRecomended.data.length < 1 ? Container() : Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Rekomendasi paket',
                                                                    style: TextStyle(
                                                                      fontSize: 20.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 0.6.h,),
                                                                  Text(
                                                                    lsRecomended[0]['name'],
                                                                    style: TextStyle(
                                                                      fontSize: 10.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 1.9.h,),
                                                                ],
                                                              ),
                                                            ),
                                                            dbRecomended.data.length < 1 ? Container() : SizedBox(
                                                              height: 58.9.w,
                                                              child: ListView.builder(
                                                                itemCount: dbRecomendedList.length,
                                                                scrollDirection: Axis.horizontal,
                                                                physics: BouncingScrollPhysics(),
                                                                padding: EdgeInsets.only(left: 3.9.w, right: 3.8.w),
                                                                itemBuilder: (context, index) {
                                                                  return Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                                        child: InkWell(
                                                                          child: Stack(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 2.8.w,),
                                                                                child: Container(
                                                                                  width: 38.9.w,
                                                                                  decoration: BoxDecoration(
                                                                                      color: Theme.of(context).primaryColor,
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
                                                                                          color: Theme.of(context).primaryColor,
                                                                                          child: Image.network(
                                                                                            dbRecomendedList[index]['image'],
                                                                                            height: 40.0.w,
                                                                                            fit: BoxFit.cover,
                                                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                                              if (loadingProgress == null) return child;
                                                                                              return SizedBox(
                                                                                                height: 40.0.w,
                                                                                                child: Center(
                                                                                                  child: SpinKitPulse(
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.fromLTRB(4.4.w, 3.6.w, 0, 3.6.w),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              dbRecomendedList[index]['name'],
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 12.0.sp,
                                                                                                fontWeight: FontWeight.w700,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 0.6.w,),
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                locale: 'id',
                                                                                                symbol: 'Rp ',
                                                                                                decimalDigits: 0,
                                                                                              ).format(int.parse(dbRecomendedList[index]['price'])),
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 10.0.sp,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              dbRecomendedList[index]['promo'] == ''
                                                                                  ? Container()
                                                                                  : Padding(
                                                                                padding: EdgeInsets.only(top: 3.3.w,),
                                                                                child: Image.asset(
                                                                                  'images/bg_label.png',
                                                                                  height: 7.9.w,
                                                                                ),
                                                                              ),
                                                                              dbRecomendedList[index]['promo'] == ''
                                                                                  ? Container()
                                                                                  : Padding(
                                                                                padding: EdgeInsets.fromLTRB(3.4.w, 4.7.w, 0, 0),
                                                                                child: Text(
                                                                                  dbRecomendedList[index]['promo'],
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 9.0.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: 32.8.w, top: 3.3.w),
                                                                                  child: Image.asset(
                                                                                    dbRecomendedList[index]['fav'] == null ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                                                                                    width: 5.6.w,
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    prefs.setRoute('/aqiqah');
                                                                                    prefs.setGoRoute('/aqiqah');
                                                                                    if (!prefs.getIsSignIn) {
                                                                                      Navigator.pushNamed(context, '/register');
                                                                                    } else {
                                                                                      if (dbRecomendedList[index]['fav'] == null) {
                                                                                        addFav(dbRecomendedList[index]['id']);
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: const Text(
                                                                                              'Produk telah berhasil disimpan sebagai Favorit.',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Ubuntu',
                                                                                              ),
                                                                                            ),
                                                                                            backgroundColor: Theme.of(context).primaryColor,
                                                                                          ),
                                                                                        );
                                                                                      } else {
                                                                                        delFav(int.parse(dbRecomendedList[index]['fav']));
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: const Text(
                                                                                              'Produk telah berhasil dihapus dari Favorit.',
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Ubuntu',
                                                                                              ),
                                                                                            ),
                                                                                            backgroundColor: Theme.of(context).primaryColor,
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                  });
                                                                                },
                                                                              )
                                                                            ],
                                                                          ),
                                                                          onTap: () {
                                                                            prodId = int.parse(dbRecomendedList[index]['id']);
                                                                            waNumber = dbSetup[0]['wa_number'];
                                                                            showModalBottomSheet(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(40),
                                                                                  topRight: Radius.circular(40),
                                                                                ),
                                                                              ),
                                                                              backgroundColor: Colors.white,
                                                                              constraints: BoxConstraints(
                                                                                minHeight: 165.0.w,
                                                                                maxHeight: 165.0.w,
                                                                              ),
                                                                              isScrollControlled: true,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return ViewProduct();
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 2.8.w,)
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(height: 3.8.h,),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Top Order!',
                                                                    style: TextStyle(
                                                                      fontSize: 20.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 0.6.h,),
                                                                  Text(
                                                                    'Produk paling diminati',
                                                                    style: TextStyle(
                                                                      fontSize: 10.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 1.9.h,),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 68.9.w,
                                                              child: ListView.builder(
                                                                itemCount: dbTopProducts.length,
                                                                scrollDirection: Axis.horizontal,
                                                                physics: BouncingScrollPhysics(),
                                                                padding: EdgeInsets.only(left: 3.9.w, right: 4.9.w),
                                                                itemBuilder: (context, index) {
                                                                  return Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                                        child: InkWell(
                                                                          child: Stack(
                                                                            alignment: AlignmentDirectional.bottomStart,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 2.8.w,),
                                                                                child: Container(
                                                                                  width: 61.1.w,
                                                                                  height: 66.7.w,
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
                                                                                          height: 40.0.w,
                                                                                          color: Theme.of(context).primaryColor,
                                                                                          child: Image.network(
                                                                                            dbTopProducts[index]['image'],
                                                                                            width: 100.0.w,
                                                                                            fit: BoxFit.cover,
                                                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                                              if (loadingProgress == null) return child;
                                                                                              return SizedBox(
                                                                                                height: 40.0.w,
                                                                                                child: Center(
                                                                                                  child: SpinKitPulse(
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.all(4.4.w),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              dbTopProducts[index]['prods_package'] + ' - ' +
                                                                                                  dbTopProducts[index]['name'],
                                                                                              style: TextStyle(
                                                                                                color: Theme.of(context).colorScheme.background,
                                                                                                fontSize: 12.0.sp,
                                                                                                fontWeight: FontWeight.w700,
                                                                                              ),
                                                                                              maxLines: dbTopProducts[index]['description'] == '' ? 2 : 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                            ),
                                                                                            SizedBox(height: 1.1.w,),
                                                                                            Html(
                                                                                              data: dbTopProducts[index]['description'],
                                                                                              style: {
                                                                                                'body': Style(
                                                                                                  color: Theme.of(context).colorScheme.background,
                                                                                                  fontSize: FontSize(8.0.sp),
                                                                                                  maxLines: 1,
                                                                                                  textOverflow: TextOverflow.ellipsis,
                                                                                                  margin: EdgeInsets.all(0),
                                                                                                )
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(7.2.w, 0, 4.4.w, 4.4.w),
                                                                                child: Text(
                                                                                  NumberFormat.currency(
                                                                                    locale: 'id',
                                                                                    symbol: 'Rp ',
                                                                                    decimalDigits: 0,
                                                                                  ).format(int.parse(dbTopProducts[index]['price'])),
                                                                                  style: TextStyle(
                                                                                    color: Theme.of(context).colorScheme.background,
                                                                                    fontSize: 10.0.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              dbTopProducts[index]['promo'] == '' ? Container() : Padding(
                                                                                padding: EdgeInsets.only(bottom: 54.9.w,),
                                                                                child: Image.asset(
                                                                                  'images/bg_label.png',
                                                                                  height: 7.9.w,
                                                                                ),
                                                                              ),
                                                                              dbTopProducts[index]['promo'] == '' ? Container() : Padding(
                                                                                padding: EdgeInsets.fromLTRB(3.4.w, 0, 0, 58.1.w),
                                                                                child: Text(
                                                                                  dbTopProducts[index]['promo'],
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 9.0.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 53.9.w, bottom: 57.5.w),
                                                                                child: InkWell(
                                                                                  child: Image.asset(
                                                                                    dbTopProducts[index]['fav'] == null ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                                                                                    width: 5.6.w,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      prefs.setRoute('/aqiqah');
                                                                                      prefs.setGoRoute('/aqiqah');
                                                                                      if (!prefs.getIsSignIn) {
                                                                                        Navigator.pushNamed(context, '/register');
                                                                                      } else {
                                                                                        if (dbTopProducts[index]['fav'] == null) {
                                                                                          addFav(dbTopProducts[index]['id']);
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                              content: const Text(
                                                                                                'Produk telah berhasil disimpan sebagai Favorit.',
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'Ubuntu',
                                                                                                ),
                                                                                              ),
                                                                                              backgroundColor: Theme.of(context).primaryColor,
                                                                                            ),
                                                                                          );
                                                                                        } else {
                                                                                          delFav(int.parse(dbTopProducts[index]['fav']));
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                              content: const Text(
                                                                                                'Produk telah berhasil dihapus dari Favorit.',
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'Ubuntu',
                                                                                                ),
                                                                                              ),
                                                                                              backgroundColor: Theme.of(context).primaryColor,
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          onTap: () {
                                                                            prodId = int.parse(dbTopProducts[index]['id']);
                                                                            waNumber = dbSetup[0]['wa_number'];
                                                                            showModalBottomSheet(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(40),
                                                                                  topRight: Radius.circular(40),
                                                                                ),
                                                                              ),
                                                                              backgroundColor: Colors.white,
                                                                              constraints: BoxConstraints(
                                                                                minHeight: 165.0.w,
                                                                                maxHeight: 165.0.w,
                                                                              ),
                                                                              isScrollControlled: true,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return ViewProduct();
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 1.7.w,)
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(height: 5.0.h,),
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: dbInfo.length,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              padding: EdgeInsets.only(top: 0),
                                                              itemBuilder: (context, index) {
                                                                bool isLink = false;
                                                                if (int.parse(dbInfo[index]['branch']) > 0) {
                                                                  isLink = true;
                                                                }
                                                                return Column(
                                                                  children: [
                                                                    Container(
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
                                                                          dbInfo[index]['image'] == '' ? Container() : ClipRRect(
                                                                            borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(12),
                                                                              topRight: Radius.circular(12),
                                                                            ),
                                                                            child: Container(
                                                                              child: Image.network(
                                                                                dbInfo[index]['image'],
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
                                                                            padding: EdgeInsets.fromLTRB(4.4.w, 5.0.w, 4.4.w, 4.4.w,),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  dbInfo[index]['title'],
                                                                                  style: TextStyle(
                                                                                    color: Theme.of(context).colorScheme.background,
                                                                                    fontSize: 13.0.sp,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 2.2.w,),
                                                                                Text(
                                                                                  dbInfo[index]['description'],
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 10.0.sp,
                                                                                  ),
                                                                                ),
                                                                                isLink == false ? Container() : SizedBox(height: 2.8.w,),
                                                                                isLink == false ? Container() : Row(
                                                                                  children: [
                                                                                    InkWell(
                                                                                      child: Container(
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.symmetric(
                                                                                            horizontal: 4.4.w, vertical: 1.4.w,),
                                                                                          child: Text(
                                                                                            'Lihat',
                                                                                            style: TextStyle(
                                                                                              fontSize: 8.0.sp,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Theme.of(context).primaryColor,
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(20),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        if (int.parse(dbInfo[index]['branch']) > 0) {
                                                                                          prefs.setBranchId(dbInfo[index]['branch']);
                                                                                          Navigator.pushNamed(context, '/branch');
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 3.1.h,),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(height: 0.7.h,),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Cabang terdekat',
                                                                    style: TextStyle(
                                                                      fontSize: 20.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 0.6.h,),
                                                                  Text(
                                                                    'Temukan cabang Sahabat Aqiqah terdekat',
                                                                    style: TextStyle(
                                                                      fontSize: 10.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 2.8.h,),
                                                                ],
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: dbBranch.length > 3 ? 3 : dbBranch.length,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              padding: EdgeInsets.only(top: 0, left: 6.7.w, right: 6.7.w,),
                                                              itemBuilder: (context, index) {
                                                                String grp1 = dbBranch[index]['phone_1'].toString().substring(0,4);
                                                                String grp2 = dbBranch[index]['phone_1'].toString().substring(4,8);
                                                                String grp3 = dbBranch[index]['phone_1'].toString()
                                                                    .substring(8,dbBranch[index]['phone_1'].toString().length);
                                                                return InkWell(
                                                                  onTap: () {
                                                                    prefs.setBranchId(dbBranch[index]['id'].toString());
                                                                    prefs.setBranchLat(double.parse(dbBranch[index]['latitude']));
                                                                    prefs.setBranchLong(double.parse(dbBranch[index]['longitude']));
                                                                    Navigator.pushNamed(context, '/branch');
                                                                  },
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(bottom: 5.0.w,),
                                                                    child: Stack(
                                                                      alignment: AlignmentDirectional.topEnd,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(12),
                                                                              ),
                                                                              child: Container(
                                                                                width: 24.4.w,
                                                                                height: 24.4.w,
                                                                                child: Image.network(
                                                                                  dbBranch[index]['image'],
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 4.4.w,),
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      dbBranch[index]['name'],
                                                                                      style: TextStyle(
                                                                                        fontSize: 13.0.sp,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Theme.of(context).colorScheme.background,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                    SizedBox(height: 2.2.w,),
                                                                                    dbBranch[index]['address_1'] == '' ? Container() : Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(top: 0.3.w,),
                                                                                          child: Image.asset(
                                                                                            'images/ic_location.png',
                                                                                            width: 2.2.w,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 1.4.w,),
                                                                                        Flexible(
                                                                                          child: Text(
                                                                                            dbBranch[index]['address_1'],
                                                                                            style: TextStyle(
                                                                                              fontSize: 10.0.sp,
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            maxLines: 2,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    dbBranch[index]['address_1'] == '' ? Container() : SizedBox(height: 1.1.w,),
                                                                                    Row(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(top: 0.3.w,),
                                                                                          child: Image.asset(
                                                                                            'images/ic_phone.png',
                                                                                            width: 2.2.w,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 1.4.w,),
                                                                                        Text(
                                                                                          grp1 + ' ' + grp2 + ' ' + grp3,
                                                                                          style: TextStyle(
                                                                                            fontSize: 10.0.sp,
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                        ),
                                                                                      ],
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
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(height: 6.7.w,),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 6.7.w),
                                                              child: InkWell(
                                                                onTap: () => Navigator.pushNamed(context, '/branchlist'),
                                                                child: Container(
                                                                  height: 11.7.w,
                                                                  width: 100.0.w,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                                                    border: Border.all(
                                                                      color: Theme.of(context).colorScheme.background,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Lihat semua cabang',
                                                                      style: TextStyle(
                                                                        fontSize: 10.0.sp,
                                                                        color: Theme.of(context).colorScheme.background,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 11.2.h,),
                                                          ],
                                                        ),
                                                      ),
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
                                                    Column(
                                                      children: [
                                                        SizedBox(height: 5.6.h,),
                                                        Padding(
                                                          padding: EdgeInsets.only(right: 21.4.w,),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pushNamed(context, '/favorites');
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
                                                                      'images/ic_fav.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(height: 5.6.h,),
                                                        Padding(
                                                          padding: EdgeInsets.only(right: 36.1.w,),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pushNamed(context, '/history');
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
                                                                      'images/ic_history.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pushReplacementNamed(context, '/home');
                                                              },
                                                              child: Container(
                                                                width: 19.0.w,
                                                                height: 15.0.h,
                                                                decoration: BoxDecoration(
                                                                  color: Theme.of(context).primaryColor,
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
                                                                        Icons.close,
                                                                        color: Colors.white,
                                                                        size: 7.0.w,
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

class ViewProduct extends StatefulWidget {
  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  List dbSingle;
  var prodsDb = ProdsDb();

  Future getProdSingle(int id) async {
    var url;
    if (prefs.getIsSignIn)
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_prod_single.php?id=$id&phone=${prefs.getPhone}');
    else
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_prod_single.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addFav(String id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/add_fav.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'fav_prod' : id,
    });
  }

  Future delFav(int id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/del_fav.php';
    await http.post(Uri.parse(url), body: {
      'id' : id.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getProdSingle(prodId),
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
            dbSingle = snapshot.data;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 66.7.w,
                      child: Image.network(
                        dbSingle[0]['image'],
                        width: 100.0.w,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 66.7.w,
                            child: Center(
                              child: SpinKitPulse(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 19.0.w,
                          height: 14.6.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: Stack(
                            alignment:
                            AlignmentDirectional.bottomCenter,
                            children: [
                              SizedBox(
                                width: 19.0.w,
                                height: 19.0.w,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 7.0.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox(),),
                      InkWell(
                        child: Image.asset(
                          dbSingle[0]['fav'] == null ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                          width: 6.7.w,
                        ),
                        onTap: () {
                          setState(() {
                            prefs.setRoute('/aqiqah');
                            prefs.setGoRoute('/aqiqah');
                            if (!prefs.getIsSignIn) {
                              Navigator.pushNamed(context, '/register');
                            } else {
                              if (dbSingle[0]['fav'] == null) {
                                addFav(dbSingle[0]['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Produk telah berhasil disimpan sebagai Favorit.',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                      ),
                                    ),
                                    backgroundColor: Theme.of(context).primaryColor,
                                  ),
                                );
                              } else {
                                delFav(int.parse(dbSingle[0]['fav']));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Produk telah berhasil dihapus dari Favorit.',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                      ),
                                    ),
                                    backgroundColor: Theme.of(context).primaryColor,
                                  ),
                                );
                              }
                            }
                          });
                        },
                      ),
                      SizedBox(width: 7.8.w,),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 98.0.w,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.9.w,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 11.0.w,),
                            Text(
                              dbSingle[0]['prods_package'],
                              style: TextStyle(
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              dbSingle[0]['name'],
                              style: TextStyle(
                                fontSize: 23.0.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            SizedBox(height: 6.7.w,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(int.parse(dbSingle[0]['price'])),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                                Expanded(child: SizedBox(),),
                                dbSingle[0]['promo'] == ''
                                    ? Container() : Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.4.w, vertical: 1.4.w,),
                                    child: Text(
                                      dbSingle[0]['promo'],
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.2.w,),
                            Html(
                              data: dbSingle[0]['description'],
                              style: {
                                'body': Style(
                                  color: Colors.black,
                                  fontSize: FontSize(11.0.sp),
                                  margin: EdgeInsets.all(0),
                                )
                              },
                            ),
                            SizedBox(height: 35.5.w,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 16.4.w,
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
                      SizedBox(height: 47.5.w,),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            height: 34.4.w,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.white, Colors.white.withOpacity(0.0),
                                  ],
                                )
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              prefs.setIdProduct(prodId.toString());
                              Navigator.pushNamed(context, '/checkout');
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: [
                                Container(
                                  width: 53.6.w,
                                  height: 20.8.w,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 42.8.w,
                                  child: Center(
                                    child: Text(
                                      'Pesan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 42.8.w),
                            child: InkWell(
                              onTap: () {
                                // ignore: deprecated_member_use
                                launch('https://api.whatsapp.com/send?phone=$waNumber'
                                    '&text=Assalamualaikum%2C+saya+dapat+info+dari+aplikasi+'
                                    '*Sahabat+Bumil*%2C+dan+ingin+bertanya+tentang+Aqiqah+anak+saya');
                              },
                              child: Container(
                                width: 40.5.w,
                                height: 20.8.w,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Chat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
