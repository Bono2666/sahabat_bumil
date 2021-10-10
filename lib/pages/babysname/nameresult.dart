import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NameResult extends StatefulWidget {
  @override
  _NameResultState createState() => _NameResultState();
}

class _NameResultState extends State<NameResult> {
  List<QueryDocumentSnapshot> prefixResult, middleResult, sufixResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: prefs.getPrefix == 'Acak' || prefs.getPrefix.substring(0, 4) == 'Diaw'
            ? FirebaseFirestore.instance
            .collection('babysname')
            .where('sex', isEqualTo: prefs.getSexTypeName)
            .where('prefix', isEqualTo: true)
            .get()
            : FirebaseFirestore.instance
            .collection('babysname')
            .where('sex', isEqualTo: prefs.getSexTypeName)
            .where('prefix', isEqualTo: true)
            .where('category', isEqualTo: prefs.getPrefix)
            .get(),
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
            prefixResult = snapshot.data.docs;
            prefixResult.shuffle();

            String prefixName = prefixResult[0].get('name').toString();

            if (prefs.getPrefix.substring(0, 4) == 'Diaw') {
              while (prefixResult[0].get('category') == 'Acak'
                  || prefixResult[0].get('category') == 'Tidak pakai'
                  || prefixName.substring(0, 1)
                      != prefs.getPrefix.substring(prefs.getPrefix.length - 1)) {
                prefixResult.shuffle();
                prefixName = prefixResult[0].get('name').toString();
              }
            } else
              while (prefixResult[0].get('category') == 'Acak'
                  || prefixResult[0].get('category') == 'Tidak pakai')
                prefixResult.shuffle();
          }
          return FutureBuilder(
            future: prefs.getMiddle == 'Acak' || prefs.getPrefix.substring(0, 4) == 'Diaw'
                ? FirebaseFirestore.instance
                .collection('babysname')
                .where('sex', isEqualTo: prefs.getSexTypeName)
                .where('middle', isEqualTo: true)
                .get()
                : FirebaseFirestore.instance
                .collection('babysname')
                .where('sex', isEqualTo: prefs.getSexTypeName)
                .where('middle', isEqualTo: true)
                .where('category', isEqualTo: prefs.getMiddle)
                .get(),
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
                middleResult = snapshot.data.docs;
                middleResult.shuffle();

                String middleName = middleResult[0].get('name').toString();

                if (prefs.getMiddle.substring(0, 4) == 'Diaw') {
                  while (middleResult[0].get('category') == 'Acak'
                      || middleResult[0].get('category') == 'Tidak pakai'
                      || middleResult[0].get('category') == prefixResult[0].get('category')
                      || middleName.substring(0, 1)
                          != prefs.getMiddle.substring(prefs.getMiddle.length - 1)) {
                    middleResult.shuffle();
                    middleName = middleResult[0].get('name').toString();
                  }
                } else if (prefs.getMiddle == 'Acak')
                  while (middleResult[0].get('category') == 'Acak'
                      || middleResult[0].get('category') == 'Tidak pakai'
                      || middleResult[0].get('category') == prefixResult[0].get('category'))
                    middleResult.shuffle();
                else
                  while (middleResult[0].get('category') == 'Acak'
                      || middleResult[0].get('category') == 'Tidak pakai')
                    middleResult.shuffle();
              }
              return FutureBuilder(
                future: prefs.getSufix == 'Acak' || prefs.getPrefix.substring(0, 4) == 'Diaw'
                    ? FirebaseFirestore.instance
                    .collection('babysname')
                    .where('sex', isEqualTo: prefs.getSexTypeName)
                    .where('sufix', isEqualTo: true)
                    .get()
                    : FirebaseFirestore.instance
                    .collection('babysname')
                    .where('sex', isEqualTo: prefs.getSexTypeName)
                    .where('sufix', isEqualTo: true)
                    .where('category', isEqualTo: prefs.getSufix)
                    .get(),
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
                    sufixResult = snapshot.data.docs;
                    sufixResult.shuffle();

                    String sufixName = sufixResult[0].get('name').toString();

                    if (prefs.getSufix.substring(0, 4) == 'Diaw') {
                      while (sufixResult[0].get('category') == 'Acak'
                          || sufixResult[0].get('category') == 'Tidak pakai'
                          || sufixResult[0].get('category') == prefixResult[0].get('category')
                          || sufixResult[0].get('category') == middleResult[0].get('category')
                          || sufixName.substring(0, 1)
                              != prefs.getSufix.substring(prefs.getSufix.length - 1)) {
                        sufixResult.shuffle();
                        sufixName = sufixResult[0].get('name').toString();
                      }
                    } else if (prefs.getSufix == 'Acak')
                        while (sufixResult[0].get('category') == 'Acak'
                            || sufixResult[0].get('category') == 'Tidak pakai'
                            || sufixResult[0].get('category') == prefixResult[0].get('category')
                            || sufixResult[0].get('category') == middleResult[0].get('category'))
                          sufixResult.shuffle();
                    else
                      while (sufixResult[0].get('category') == 'Acak'
                          || sufixResult[0].get('category') == 'Tidak pakai')
                        sufixResult.shuffle();
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6.7.w, top: 19.0.h, right: 6.7.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekomendasi Nama',
                              style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0.sp,
                              ),
                            ),
                            SizedBox(height: 1.9.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/ic_baby.png',
                                  height: 3.2.w,
                                ),
                                SizedBox(
                                  width: 1.4.w,
                                ),
                                Text(
                                  'Rekomendasi nama bayi Anda',
                                  style: TextStyle(
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.4.h,),
                            Flexible(
                              child: Text(
                                (prefs.getPrefix == 'Tidak pakai'
                                    ? '' : prefixResult[0].get('name') + ' ') +
                                    (prefs.getMiddle == 'Tidak pakai'
                                    ? '' : middleResult[0].get('name') + ' ') +
                                    (prefs.getSufix == 'Tidak pakai'
                                    ? '' : sufixResult[0].get('name')),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.4.h,),
                            prefs.getPrefix == 'Tidak pakai'
                                ? Container()
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.84.w),
                                        child: Text(
                                          prefixResult[0].get('name'),
                                          style: TextStyle(
                                            color: Theme.of(context).backgroundColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0.sp,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Html(
                                          data: 'artinya ' + prefixResult[0].get('desc'),
                                          style: {
                                            'body': Style(
                                              fontSize: FontSize.rem(1.25),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                            prefs.getMiddle == 'Tidak pakai'
                                ? Container()
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.84.w),
                                        child: Text(
                                          middleResult[0].get('name'),
                                          style: TextStyle(
                                            color: Theme.of(context).backgroundColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0.sp,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Html(
                                          data: 'artinya ' + middleResult[0].get('desc'),
                                          style: {
                                            'body': Style(
                                              fontSize: FontSize.rem(1.25),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                            prefs.getSufix == 'Tidak pakai'
                                ? Container()
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.84.w),
                                        child: Text(
                                          sufixResult[0].get('name'),
                                          style: TextStyle(
                                            color: Theme.of(context).backgroundColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0.sp,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Html(
                                          data: 'artinya ' + sufixResult[0].get('desc'),
                                          style: {
                                            'body': Style(
                                              fontSize: FontSize.rem(1.25),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
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
                                          Icons.arrow_back_ios_rounded,
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
                          Expanded(child: SizedBox()),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: [
                                    Container(
                                      width: 52.0.w,
                                      height: 12.0.h,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 40.0.w,
                                      child: Center(
                                        child: Text(
                                          'Cari Nama',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 40.0.w),
                                child: InkWell(
                                  child: Stack(
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: [
                                      Container(
                                        width: 43.0.w,
                                        height: 12.0.h,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).backgroundColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            bottomRight: Radius.circular(40),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Pilih Sendiri',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0.sp,
                                            ),
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
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
