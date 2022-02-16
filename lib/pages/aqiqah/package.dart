import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Package extends StatefulWidget {
  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  AsyncSnapshot<dynamic> dbPackage, dbSetup;

  Future getSinglePackage() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_single_package.php?id=' +
        prefs.getIdPackage);
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getSinglePackage(),
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
            dbPackage = snapshot;
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
                dbSetup = snapshot;
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 19.0.h,),
                              Text(
                                dbPackage.data[0]['package'],
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0.sp,
                                ),
                              ),
                              SizedBox(height: 0.6.h,),
                              Text(
                                dbPackage.data[0]['subtitle'],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.0.sp,
                                ),
                              ),
                              SizedBox(height: 4.4.h,),
                            ],
                          ),
                        ),
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4.4.h,
                            crossAxisSpacing: 3.8.w,
                            mainAxisExtent: dbPackage.data[0]['description'] == ''
                                ? 58.0.w : 62.0.w,
                          ),
                          itemCount: dbPackage.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(left: 3.9.w, right: 4.9.w),
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 2.8.w,),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40.0.w,
                                          height: 41.1.w,
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(12),),
                                            child: Container(
                                              height: 41.1.w,
                                              color: Theme.of(context).primaryColor,
                                              child: Image.network(
                                                dbPackage.data[index]['image'],
                                                width: 100.0.w,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return SizedBox(
                                                    height: 41.1.w,
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
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 2.2.w,),
                                            Text(
                                              dbPackage.data[index]['name'],
                                              style: TextStyle(
                                                color: Theme.of(context).backgroundColor,
                                                fontSize: 11.0.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: dbPackage.data[index]['description'] == ''
                                                  ? 2 : 1,
                                              overflow: dbPackage.data[index]['description'] == ''
                                                  ? TextOverflow.visible : TextOverflow.ellipsis,
                                            ),
                                            dbPackage.data[index]['description'] == ''
                                                ? Container() : SizedBox(height: 1.6.w,),
                                            dbPackage.data[index]['description'] == ''
                                                ? Container() : Html(
                                              data: dbPackage.data[index]['description'],
                                              style: {
                                                'body': Style(
                                                  color: Colors.black,
                                                  fontSize: FontSize(8.0.sp),
                                                  maxLines: 2,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  margin: EdgeInsets.all(0),
                                                )
                                              },
                                            ),
                                            SizedBox(height: 2.2.w,),
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0,
                                              ).format(int.parse(dbPackage.data[index]['price'])),
                                              style: TextStyle(
                                                color: Theme.of(context).backgroundColor,
                                                fontSize: 10.0.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  dbPackage.data[index]['promo'] == '' ? Container() : Padding(
                                    padding: EdgeInsets.only(top: 3.9.w,),
                                    child: Image.asset(
                                      'images/bg_label_light.png',
                                      height: 7.9.w,
                                    ),
                                  ),
                                  dbPackage.data[index]['promo'] == '' ? Container() : Padding(
                                    padding: EdgeInsets.fromLTRB(3.6.w, 5.3.w, 0, 0),
                                    child: Text(
                                      dbPackage.data[index]['promo'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.0.sp,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 33.2.w,
                                    top: 4.4.w,
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
                                                  dbPackage.data[index]['image'],
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
                                                        dbPackage.data[index]['package'],
                                                        style: TextStyle(
                                                          fontSize: 10.0.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: Theme.of(context).primaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        dbPackage.data[index]['name'],
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
                                                            ).format(int.parse(dbPackage.data[index]['price'])),
                                                            style: TextStyle(
                                                              fontSize: 16.0.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: Theme.of(context).backgroundColor,
                                                            ),
                                                          ),
                                                          Expanded(child: SizedBox(),),
                                                          dbPackage.data[index]['promo'] == ''
                                                              ? Container() : Container(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal: 4.4.w, vertical: 1.4.w,),
                                                              child: Text(
                                                                dbPackage.data[index]['promo'],
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
                                                        data: dbPackage.data[index]['description'],
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
                                                physics: BouncingScrollPhysics(),
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
                                                        prefs.setIdProduct(dbPackage.data[index]['id']);
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
                                                          launch('https://api.whatsapp.com/send?phone=' + dbSetup.data[0]['wa_number'] +
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
                            );
                          },
                        ),
                        SizedBox(height: 7.5.h,),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
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
                          InkWell(
                            onTap: () => Navigator.pop(context),
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
    );
  }
}