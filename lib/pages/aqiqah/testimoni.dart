// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:format_indonesia/format_indonesia.dart';

class Testimoni extends StatefulWidget {
  @override
  _TestimoniState createState() => _TestimoniState();
}

class _TestimoniState extends State<Testimoni> {
  List dbTestimoni;

  Future getTestimoni() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_testimoni.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getTestimoni(),
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
            dbTestimoni = snapshot.data;
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 19.0.h,),
                          Text(
                            'Testimoni',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0.sp,
                            ),
                          ),
                          SizedBox(height: 3.4.h,),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: dbTestimoni.length,
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
                                                          color: Theme.of(context).backgroundColor,
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
                                                Waktu(_date).yMMMd() + ' ' + DateFormat.Hm().format(_date),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 7.5.h,),
                  ],
                ),
              ),
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
                        color: Theme.of(context).backgroundColor,
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
          );
        },
      ),
    );
  }
}
