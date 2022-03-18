// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sahabat_bumil_v2/db/checklist_db.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sahabat_bumil_v2/model/checklist_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

class Monitoring extends StatefulWidget {
  @override
  _MonitoringState createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  int currentPage, totalDays;
  String imageUrl = '', imgChecklist = '';
  PageController pageController;
  List<QueryDocumentSnapshot> document, checkListData, listArticle;
  var db = ChecklistDb();

  @override
  void initState() {
    super.initState();

    DateTime hpht = DateTime(
        int.parse(prefs.getHPHT.substring(4,8)),
        int.parse(prefs.getHPHT.substring(2,4)),
        int.parse(prefs.getHPHT.substring(0,2))
    );

    DateTime hpl = DateTime(
        int.parse(prefs.getHPL.substring(4,8)),
        int.parse(prefs.getHPL.substring(2,4)),
        int.parse(prefs.getHPL.substring(0,2))
    );

    currentPage = (DateTime.now().difference(hpht).inDays);
    pageController = PageController(initialPage: currentPage);
    totalDays = (hpl.difference(hpht).inDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacementNamed(context, prefs.getRoute),
        child: FutureBuilder(
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
                                child: PageView.builder(
                                  itemCount: document.length,
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      document[currentPage].get('image'),
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 15.8.h),
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
                            padding: EdgeInsets.only(right: 7.2.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 3.6.h),
                                      child: SmoothPageIndicator(
                                        controller: pageController,
                                        count: document.length,
                                        effect: ScrollingDotsEffect(
                                          activeDotColor: Theme.of(context).primaryColor,
                                          activeDotScale: 1.5,
                                          dotColor: Colors.white,
                                          dotHeight: 1.0.w,
                                          dotWidth: 1.0.w,
                                          maxVisibleDots: 9,
                                          spacing: 2.0.w,
                                        ),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.end,
                                ),
                                SizedBox(width: 14.0.w,),
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
                                              'images/ic_cal.png',
                                              height: 3.3.w,
                                            ),
                                            SizedBox(width: 1.4.w,),
                                            Text(
                                              'Trimester ' + document[currentPage].get('trimester'),
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.9.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Pekan: ' + document[currentPage].get('week').toString() + ' hari ' + document[currentPage].get('day').toString(),
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                            Text(
                                              (totalDays - currentPage) < 0
                                                  ? (currentPage - totalDays).toString() + ' hari melewati HPL'
                                                  : ' Insya Allah ' + (totalDays - currentPage).toString() + ' hari menuju HPL',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.3.h,),
                                        Stack(
                                          alignment: AlignmentDirectional.topStart,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 2.2.w),
                                              child: SizedBox(
                                                width: 100.0.w,
                                                child: FittedBox(
                                                  child: LinearPercentIndicator(
                                                    percent: currentPage > totalDays ? 1.0 : currentPage/totalDays,
                                                    width: totalDays.toDouble(),
                                                    lineHeight: 1.4.w,
                                                    progressColor: Theme.of(context).primaryColor,
                                                    backgroundColor: Theme.of(context).dividerColor,
                                                    barRadius: const Radius.circular(16),
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    animateFromLastPercent: true,
                                                    curve: Curves.fastOutSlowIn,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RotatedBox(
                                                  child: DottedLine(
                                                    dashColor: Theme.of(context).backgroundColor,
                                                    dashLength: 2.0,
                                                    lineLength: 5.6.w,
                                                    lineThickness: 2,
                                                  ),
                                                  quarterTurns: 3,
                                                ),
                                                RotatedBox(
                                                  child: DottedLine(
                                                    dashColor: Theme.of(context).backgroundColor,
                                                    dashLength: 2.0,
                                                    lineLength: 5.6.w,
                                                    lineThickness: 2,
                                                  ),
                                                  quarterTurns: 3,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 0.9.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Trimester\nPertama',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: document[currentPage].get('trimester') == 'Pertama'
                                                      ? Theme.of(context).primaryColor
                                                      : Theme.of(context).backgroundColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Trimester\nKedua',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: document[currentPage].get('trimester') == 'Kedua'
                                                      ? Theme.of(context).primaryColor
                                                      : Theme.of(context).backgroundColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Trimester\nKetiga',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: document[currentPage].get('trimester') == 'Ketiga'
                                                      ? Theme.of(context).primaryColor
                                                      : Theme.of(context).backgroundColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.0.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'images/ic_baby.png',
                                              height: 3.3.w,
                                            ),
                                            SizedBox(width: 1.4.w,),
                                            Text(
                                              'Calon Bayi',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.3.h,),
                                        Container(
                                          width: 100.0.w,
                                          constraints: BoxConstraints(
                                            minHeight: 10.0.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 5.6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.4.w),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 6.6.w,
                                                      height: 6.6.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(30),
                                                          ),
                                                          color: Theme.of(context).primaryColor
                                                      ),
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 3.3.w,
                                                          height: 3.3.w,
                                                          child: FittedBox(
                                                            child: Image.asset(
                                                                'images/ic_weight.png'
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 1.6.w,),
                                                    Text(
                                                      document[currentPage].get('weight'),
                                                      style: TextStyle(
                                                        fontSize: 10.0.sp,
                                                        fontWeight: FontWeight.w700,
                                                        color: Theme.of(context).backgroundColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.0.w,),
                                                    Container(
                                                      width: 6.6.w,
                                                      height: 6.6.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(30),
                                                          ),
                                                          color: Theme.of(context).primaryColor
                                                      ),
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 3.3.w,
                                                          height: 3.3.w,
                                                          child: FittedBox(
                                                            child: Image.asset(
                                                                'images/ic_size.png'
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 1.6.w,),
                                                    Text(
                                                      document[currentPage].get('size'),
                                                      style: TextStyle(
                                                        fontSize: 10.0.sp,
                                                        fontWeight: FontWeight.w700,
                                                        color: Theme.of(context).backgroundColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 3.3.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.4.w),
                                                child: Text(
                                                  document[currentPage].get('growth_title'),
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.2.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.35.w),
                                                child: Html(
                                                  data: document[currentPage].get('growth_desc'),
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize.percent(112),
                                                      fontWeight: FontWeight.w400,
                                                      color: Theme.of(context).backgroundColor,
                                                      padding: EdgeInsets.all(0),
                                                      lineHeight: LineHeight.percent(112),
                                                    ),
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 1.9.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'images/ic_size_color.png',
                                              width: 3.3.w,
                                            ),
                                            SizedBox(width: 1.4.w,),
                                            Text(
                                              'Ukuran Bayi',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.3.h,),
                                        Container(
                                          width: 100.0.w,
                                          constraints: BoxConstraints(
                                            minHeight: 10.0.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 5.6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.4.w),
                                                child: Text(
                                                  'Ukuran Bayi di Pekan ke ' + document[currentPage].get('week').toString(),
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.2.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.35.w),
                                                child: Html(
                                                  data: document[currentPage].get('size_desc'),
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize.percent(112),
                                                      fontWeight: FontWeight.w400,
                                                      color: Theme.of(context).backgroundColor,
                                                      padding: EdgeInsets.all(0),
                                                      lineHeight: LineHeight.percent(112),
                                                    ),
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 1.9.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'images/ic_tips.png',
                                              width: 2.2.w,
                                            ),
                                            SizedBox(width: 1.4.w,),
                                            Text(
                                              'Tips',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.3.h,),
                                        Container(
                                          width: 100.0.w,
                                          constraints: BoxConstraints(
                                            minHeight: 10.0.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 5.6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.4.w),
                                                child: Text(
                                                  'Tips Perawatan Diri',
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.2.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.35.w),
                                                child: Html(
                                                  data: document[currentPage].get('self_care'),
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize.percent(112),
                                                      fontWeight: FontWeight.w400,
                                                      color: Theme.of(context).backgroundColor,
                                                      padding: EdgeInsets.all(0),
                                                      lineHeight: LineHeight.percent(112),
                                                    ),
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 2.5.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.4.w),
                                                child: Text(
                                                  'Saran untuk Suami',
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.2.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.35.w),
                                                child: Html(
                                                  data: document[currentPage].get('partners'),
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize.percent(112),
                                                      fontWeight: FontWeight.w400,
                                                      color: Theme.of(context).backgroundColor,
                                                      padding: EdgeInsets.all(0),
                                                      lineHeight: LineHeight.percent(112),
                                                    ),
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 1.9.h,),
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
                                  SizedBox(height: 1.3.h,),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: listArticle.length > 3 ?3 :listArticle.length,
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
                                  SizedBox(height: 1.3.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.6.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/ic_check.png',
                                          width: 3.3.w,
                                        ),
                                        SizedBox(width: 1.4.w,),
                                        Text(
                                          'Ceklis Bunda di Pekan ' + document[currentPage].get('week').toString(),
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 2.2.h,),
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance.collection('checklist').get(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                        return SizedBox(
                                          height: 56.0.w,
                                          child: Center(
                                            child: SpinKitPulse(
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        checkListData = snapshot.data.docs;
                                        for (int i=0; i < checkListData.length; i++) {
                                          var checklist = new Checklist(
                                            clId: checkListData[i].id,
                                            clWeek: checkListData[i].get('week'),
                                            clTitle: checkListData[i].get('title'),
                                            clImage: checkListData[i].get('image'),
                                            clChecked: 0,
                                          );
                                          db.insert(checklist);
                                        }
                                      }
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return FutureBuilder(
                                            future: db.list(document[currentPage].get('week')),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                                return Shimmer.fromColors(
                                                  baseColor: Theme.of(context).secondaryHeaderColor,
                                                  highlightColor: Theme.of(context).highlightColor,
                                                  child: SingleChildScrollView(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 6.6.w,),
                                                        Container(
                                                          width: 38.0.w,
                                                          height: 56.0.w,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).secondaryHeaderColor,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5.6.w,),
                                                        Container(
                                                          width: 38.0.w,
                                                          height: 56.0.w,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).secondaryHeaderColor,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5.6.w,),
                                                        Container(
                                                          width: 38.0.w,
                                                          height: 56.0.w,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).secondaryHeaderColor,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                print('SQFLite: ' + snapshot.data.length.toString() + ' records');
                                              }
                                              return SizedBox(
                                                height: 58.0.w,
                                                child: ListView.builder(
                                                  itemCount: snapshot.data.length,
                                                  scrollDirection: Axis.horizontal,
                                                  physics: BouncingScrollPhysics(),
                                                  padding: EdgeInsets.only(left: 6.6.w, right: 1.1.w),
                                                  itemBuilder: (context, index) {
                                                    Checklist checkListItem = Checklist.get(snapshot.data[index]);
                                                    return Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                          child: InkWell(
                                                            child: Container(
                                                              width: 38.0.w,
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
                                                                  Stack(
                                                                    alignment: Alignment.topRight,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(12),
                                                                          topRight: Radius.circular(12),
                                                                        ),
                                                                        child: Container(
                                                                          child: Image.network(
                                                                            checkListItem.clImage,
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
                                                                          color: Theme.of(context).primaryColorLight,
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 2.8.w,
                                                                        right: 2.8.w,
                                                                        child: Container(
                                                                          width: 6.6.w,
                                                                          height: 6.6.w,
                                                                          decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: Colors.white,
                                                                          ),
                                                                          child: Center(
                                                                            child: Image.asset(
                                                                              checkListItem.clChecked == 1
                                                                                  ? 'images/ic_checkedlist.png'
                                                                                  : 'images/ic_unchecklist.png',
                                                                              width: 3.3.w,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(2.2.w,3.0.w,2.2.w,0),
                                                                    child: Text(
                                                                      checkListItem.clTitle,
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 12.0.sp,
                                                                        fontWeight: FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              if (checkListItem.clChecked == 1) {
                                                                var checklist = Checklist(
                                                                  clId: checkListItem.clId,
                                                                  clWeek: checkListItem.clWeek,
                                                                  clTitle: checkListItem.clTitle,
                                                                  clImage: checkListItem.clImage,
                                                                  clChecked: 0,
                                                                );
                                                                db.update(checklist);
                                                              } else {
                                                                var checklist = Checklist(
                                                                  clId: checkListItem.clId,
                                                                  clWeek: checkListItem.clWeek,
                                                                  clTitle: checkListItem.clTitle,
                                                                  clImage: checkListItem.clImage,
                                                                  clChecked: 1,
                                                                );
                                                                db.update(checklist);
                                                              }
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: 5.6.w,)
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
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
        ),
      ),
    );
  }
}