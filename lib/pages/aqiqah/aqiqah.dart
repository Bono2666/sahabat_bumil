import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Aqiqah extends StatefulWidget {
  @override
  _AqiqahState createState() => _AqiqahState();
}

class _AqiqahState extends State<Aqiqah> {
  int currentPage = 0, prevPage = 0;
  PageController pageController = new PageController();
  AsyncSnapshot<dynamic> dbBanner, dbPackages, dbPromo, dbRecomended,
      dbRecomendedList, dbTopProducts;
  List lsRecomended, dbSetup;

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

  Future getPromo() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_promo.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getRecomended() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_recomended.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getRecomendedList() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_recomended_product.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getTopProducts() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_top_products.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      prevPage = currentPage;

      if (currentPage < (dbBanner.data.length - 1)) {
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
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacementNamed(context, prefs.getRoute),
        child: FutureBuilder(
          future: getBanner(),
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
              dbBanner = snapshot;
            }
            return FutureBuilder(
              future: getPackages(),
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
                            color: Colors.white,
                          ),
                        ],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      dbPromo = snapshot;
                    }
                    return FutureBuilder(
                      future: getRecomended(),
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
                          dbRecomended = snapshot;
                        }
                        return FutureBuilder(
                          future: getRecomendedList(),
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
                              dbRecomendedList = snapshot;
                            }
                            return FutureBuilder(
                              future: getTopProducts(),
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
                                  dbTopProducts = snapshot;
                                  lsRecomended = dbRecomended.data;
                                }
                                return FutureBuilder(
                                  future: getSetup(),
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
                                      dbSetup = snapshot.data;
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
                                                    child: PageView.builder(
                                                      itemCount: dbBanner.data.length,
                                                      controller: pageController,
                                                      onPageChanged: (index) {
                                                        setState(() {
                                                          currentPage = index;
                                                        });
                                                      },
                                                      itemBuilder: (context, index) {
                                                        List lsBanner = dbBanner.data;
                                                        return Image.network(
                                                          lsBanner[currentPage]['image'],
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
                                                        );
                                                      },
                                                    ),
                                                    height: 74.0.h,
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    height: 26.0.h,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 45.6.h,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: 1.9.h),
                                                          child: SmoothPageIndicator(
                                                            controller: pageController,
                                                            count: dbBanner.data.length,
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
                                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 1.7.h,),
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
                                                            SizedBox(height: 6.0.h,),
                                                            Row(
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
                                                                    color: Theme.of(context).backgroundColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 1.9.h,),
                                                          ],
                                                        ),
                                                      ),
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
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(12),
                                                                          ),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Theme.of(context).shadowColor,
                                                                              blurRadius: 6.0,
                                                                              offset: Offset(3,0),
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
                                                                                color: Theme.of(context).backgroundColor,
                                                                                fontSize: 8.0.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    onTap: () {

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
                                                      dbPromo.data.length < 1 ? Container() : Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.6.w),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Promo hari ini',
                                                              style: TextStyle(
                                                                fontSize: 20.0.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: Theme.of(context).backgroundColor,
                                                              ),
                                                            ),
                                                            SizedBox(height: 0.6.h,),
                                                            Text(
                                                              'Manfaatkan promo sebelum kehabisan',
                                                              style: TextStyle(
                                                                fontSize: 10.0.sp,
                                                                fontWeight: FontWeight.w700,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      dbPromo.data.length < 1 ? Container() : SizedBox(height: 1.9.h,),
                                                      dbPromo.data.length < 1 ? Container() : SizedBox(
                                                        height: 68.9.w,
                                                        child: ListView.builder(
                                                          itemCount: dbPromo.data.length,
                                                          scrollDirection: Axis.horizontal,
                                                          physics: BouncingScrollPhysics(),
                                                          padding: EdgeInsets.only(left: 3.9.w, right: 4.9.w),
                                                          itemBuilder: (context, index) {
                                                            List lsPromo = dbPromo.data;
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
                                                                                    offset: Offset(3,0),
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
                                                                                      lsPromo[index]['image'],
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
                                                                                        lsPromo[index]['title'],
                                                                                        style: TextStyle(
                                                                                          color: Theme.of(context).backgroundColor,
                                                                                          fontSize: 12.0.sp,
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 1.1.w,),
                                                                                      Text(
                                                                                        lsPromo[index]['description'],
                                                                                        style: TextStyle(
                                                                                          color: Theme.of(context).backgroundColor,
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
                                                                            lsPromo[index]['price'],
                                                                            style: TextStyle(
                                                                              color: Theme.of(context).backgroundColor,
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
                                                                            lsPromo[index]['label'],
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 9.0.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          left: 53.9.w,
                                                                          bottom: 57.5.w,
                                                                          child: Image.asset(
                                                                            'images/ic_unfav.png',
                                                                            width: 5.6.w,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    onTap: () {

                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(width: 1.7.w,)
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      dbPromo.data.length < 1 ? Container() : SizedBox(height: 3.8.h,),
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
                                                                color: Theme.of(context).backgroundColor,
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
                                                          itemCount: dbRecomendedList.data.length,
                                                          scrollDirection: Axis.horizontal,
                                                          physics: BouncingScrollPhysics(),
                                                          padding: EdgeInsets.only(left: 3.9.w, right: 3.8.w),
                                                          itemBuilder: (context, index) {
                                                            List lsRecommendedList = dbRecomendedList.data;
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
                                                                                    offset: Offset(3,0),
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
                                                                                      lsRecommendedList[index]['image'],
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
                                                                                        lsRecommendedList[index]['name'],
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
                                                                                        ).format(int.parse(lsRecommendedList[index]['price'])),
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
                                                                        lsRecommendedList[index]['promo'] == ''
                                                                            ? Container()
                                                                            : Padding(
                                                                                padding: EdgeInsets.only(top: 3.3.w,),
                                                                                child: Image.asset(
                                                                                  'images/bg_label.png',
                                                                                  height: 7.9.w,
                                                                                ),
                                                                              ),
                                                                        lsRecommendedList[index]['promo'] == ''
                                                                            ? Container()
                                                                            : Padding(
                                                                                padding: EdgeInsets.fromLTRB(3.4.w, 4.7.w, 0, 0),
                                                                                child: Text(
                                                                                  lsRecommendedList[index]['promo'],
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 9.0.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                        Positioned(
                                                                          left: 32.8.w,
                                                                          top: 3.3.w,
                                                                          child: Image.asset(
                                                                            'images/ic_unfav.png',
                                                                            width: 5.6.w,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    onTap: () {
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
                                                                                        lsRecommendedList[index]['image'],
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
                                                                                      Positioned(
                                                                                        top: 7.8.w,
                                                                                        child: Image.asset(
                                                                                          'images/ic_unfav.png',
                                                                                          width: 6.7.w,
                                                                                        ),
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
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 6.9.w,),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(height: 11.0.w,),
                                                                                            Text(
                                                                                              lsRecommendedList[index]['package'],
                                                                                              style: TextStyle(
                                                                                                fontSize: 10.0.sp,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: Theme.of(context).primaryColor,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              lsRecommendedList[index]['name'],
                                                                                              style: TextStyle(
                                                                                                fontSize: 23.0.sp,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Theme.of(context).backgroundColor,
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
                                                                                                  ).format(int.parse(lsRecommendedList[index]['price'])),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 16.0.sp,
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Theme.of(context).backgroundColor,
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(child: SizedBox(),),
                                                                                                lsRecommendedList[index]['promo'] == ''
                                                                                                    ? Container() : Container(
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                          horizontal: 4.4.w, vertical: 1.4.w,),
                                                                                                        child: Text(
                                                                                                          lsRecommendedList[index]['promo'],
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
                                                                                              data: lsRecommendedList[index]['description'],
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
                                                                                              prefs.setIdProduct(lsRecommendedList[index]['id']);
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
                                                                                                launch('https://api.whatsapp.com/send?phone=' + dbSetup[0]['wa_number'] +
                                                                                                    '&text=Assalamualaikum%2C+saya+dapat+info+dari+aplikasi+'
                                                                                                        '*Sahabat+Bumil*%2C+dan+ingin+bertanya+tentang+Aqiqah+anak+saya');
                                                                                              },
                                                                                              child: Container(
                                                                                                width: 40.5.w,
                                                                                                height: 20.8.w,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Theme.of(context).backgroundColor,
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
                                                                color: Theme.of(context).backgroundColor,
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
                                                          itemCount: 4,
                                                          scrollDirection: Axis.horizontal,
                                                          physics: BouncingScrollPhysics(),
                                                          padding: EdgeInsets.only(left: 3.9.w, right: 4.9.w),
                                                          itemBuilder: (context, index) {
                                                            List lsTopProducts = dbTopProducts.data;
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
                                                                                    offset: Offset(3,0),
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
                                                                                      lsTopProducts[index]['image'],
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
                                                                                        lsTopProducts[index]['package'] + ' - '
                                                                                            + lsTopProducts[index]['name'],
                                                                                        style: TextStyle(
                                                                                          color: Theme.of(context).backgroundColor,
                                                                                          fontSize: 12.0.sp,
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 1.1.w,),
                                                                                      Html(
                                                                                        data: lsTopProducts[index]['description'],
                                                                                        style: {
                                                                                          'body': Style(
                                                                                            color: Theme.of(context).backgroundColor,
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
                                                                            ).format(int.parse(lsTopProducts[index]['price'])),
                                                                            style: TextStyle(
                                                                              color: Theme.of(context).backgroundColor,
                                                                              fontSize: 10.0.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        lsTopProducts[index]['promo'] == '' ? Container() : Padding(
                                                                          padding: EdgeInsets.only(bottom: 54.9.w,),
                                                                          child: Image.asset(
                                                                            'images/bg_label.png',
                                                                            height: 7.9.w,
                                                                          ),
                                                                        ),
                                                                        lsTopProducts[index]['promo'] == '' ? Container() : Padding(
                                                                          padding: EdgeInsets.fromLTRB(3.4.w, 0, 0, 58.1.w),
                                                                          child: Text(
                                                                            lsTopProducts[index]['promo'],
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 9.0.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          left: 53.9.w,
                                                                          bottom: 57.5.w,
                                                                          child: Image.asset(
                                                                            'images/ic_unfav.png',
                                                                            width: 5.6.w,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    onTap: () {
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
                                                                                        lsTopProducts[index]['image'],
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
                                                                                      Positioned(
                                                                                        top: 7.8.w,
                                                                                        child: Image.asset(
                                                                                          'images/ic_unfav.png',
                                                                                          width: 6.7.w,
                                                                                        ),
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
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 6.9.w,),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(height: 11.0.w,),
                                                                                            Text(
                                                                                              lsTopProducts[index]['package'],
                                                                                              style: TextStyle(
                                                                                                fontSize: 10.0.sp,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: Theme.of(context).primaryColor,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              lsTopProducts[index]['name'],
                                                                                              style: TextStyle(
                                                                                                fontSize: 23.0.sp,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Theme.of(context).backgroundColor,
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
                                                                                                  ).format(int.parse(lsTopProducts[index]['price'])),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 16.0.sp,
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Theme.of(context).backgroundColor,
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(child: SizedBox(),),
                                                                                                lsTopProducts[index]['promo'] == ''
                                                                                                    ? Container() : Container(
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                          horizontal: 4.4.w, vertical: 1.4.w,),
                                                                                                        child: Text(
                                                                                                          lsTopProducts[index]['promo'],
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
                                                                                              data: lsTopProducts[index]['description'],
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
                                                                                              prefs.setIdProduct(lsTopProducts[index]['id']);
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
                                                                                                launch('https://api.whatsapp.com/send?phone=' + dbSetup[0]['wa_number'] +
                                                                                                    '&text=Assalamualaikum%2C+saya+dapat+info+dari+aplikasi+'
                                                                                                        '*Sahabat+Bumil*%2C+dan+ingin+bertanya+tentang+Aqiqah+anak+saya');
                                                                                              },
                                                                                              child: Container(
                                                                                                width: 40.5.w,
                                                                                                height: 20.8.w,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Theme.of(context).backgroundColor,
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
                                        Column(
                                          children: [
                                            SizedBox(height: 5.6.h,),
                                            Padding(
                                              padding: EdgeInsets.only(right: 21.4.w,),
                                              child: InkWell(
                                                onTap: () {
                                                  // Navigator.pushReplacementNamed(context, '/babysname');
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
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushReplacementNamed(context, prefs.getRoute);
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
        ),
      ),
    );
  }
}