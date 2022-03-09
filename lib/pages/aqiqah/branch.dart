import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Branch extends StatefulWidget {
  @override
  _BranchState createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  List dbSingle;
  String grp1, grp2, grp3, grp4, grp5, grp6;
  GoogleMapController mapController;
  CameraPosition branchPin;

  Future getSingleBranch() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_single_branch.php?id=' +
        prefs.getBranchId);
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getSingleBranch(),
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
            dbSingle = snapshot.data;

            grp1 = dbSingle[0]['phone_1'].toString().substring(0,4);
            grp2 = dbSingle[0]['phone_1'].toString().substring(4,8);
            grp3 = dbSingle[0]['phone_1'].toString().substring(8,dbSingle[0]['phone_1'].toString().length);

            if (dbSingle[0]['phone_2'] != '') {
              grp4 = dbSingle[0]['phone_2'].toString().substring(0, 4);
              grp5 = dbSingle[0]['phone_2'].toString().substring(4, 8);
              grp6 = dbSingle[0]['phone_2'].toString().substring(8, dbSingle[0]['phone_2'].toString().length);
            }

            branchPin = CameraPosition(
              target: LatLng(double.parse(dbSingle[0]['latitude']),
                  double.parse(dbSingle[0]['longitude'])),
              zoom: 18.0,
            );
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(58),
                      ),
                      child: Container(
                        height: 61.9.h,
                        color: Theme.of(context).unselectedWidgetColor,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: branchPin,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dbSingle[0]['name'],
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                          SizedBox(height: 2.5.h,),
                          dbSingle[0]['description'] == '' ? Container() : Text(
                            dbSingle[0]['description'],
                            style: TextStyle(
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                          dbSingle[0]['description'] == '' ? Container() : SizedBox(height: 1.9.h,),
                          dbSingle[0]['address_1'] == '' ? Container() : Text(
                            dbSingle[0]['address_1'],
                            style: TextStyle(
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                          dbSingle[0]['address_1'] == '' ? Container() : SizedBox(height: 1.9.h,),
                          dbSingle[0]['address_2'] == '' ? Container() : Text(
                            dbSingle[0]['address_2'],
                            style: TextStyle(
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                          dbSingle[0]['address_2'] == '' ? Container() : SizedBox(height: 1.9.h,),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.3.w,),
                                child: Image.asset(
                                  'images/ic_phone.png',
                                  width: 4.1.w,
                                ),
                              ),
                              SizedBox(width: 2.1.w,),
                              Text(
                                grp1 + ' ' + grp2 + ' ' + grp3,
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.9.h,),
                          dbSingle[0]['phone_2'] == '' ? Container() : Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.3.w,),
                                child: Image.asset(
                                  'images/ic_phone.png',
                                  width: 4.1.w,
                                ),
                              ),
                              SizedBox(width: 2.1.w,),
                              Text(
                                grp4 + ' ' + grp5 + ' ' + grp6,
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          dbSingle[0]['phone_2'] == '' ? Container() : SizedBox(height: 1.9.h,),
                          dbSingle[0]['email_1'] == '' ? Container() : Text(
                            dbSingle[0]['email_1'],
                            style: TextStyle(
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                          dbSingle[0]['email_1'] == '' ? Container() : SizedBox(height: 1.9.h,),
                          dbSingle[0]['email_2'] == '' ? Container() : Text(
                            dbSingle[0]['email_2'],
                            style: TextStyle(
                              fontSize: 11.0.sp,
                              color: Colors.black,
                            ),
                          ),
                          dbSingle[0]['email_2'] == '' ? Container() : SizedBox(height: 1.9.h,),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.1.h,),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                  Expanded(child: SizedBox()),
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
                          if (dbSingle[0]['direction'] != '')
                          launch(dbSingle[0]['direction']);
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
                              width: 41.7.w,
                              child: Center(
                                child: Text(
                                  'Arah',
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
                            String phone = dbSingle[0]['phone_1'].toString();
                            String waNumber = '+62' + phone.substring(1, phone.length);
                            launch('https://api.whatsapp.com/send?phone=' + waNumber +
                                '&text=Assalamualaikum%2C+saya+dapat+info+dari+aplikasi+'
                                    '*Sahabat+Bumil*%2C+dan+ingin+bertanya+tentang+Aqiqah+anak+saya');
                          },
                          child: Container(
                            width: 41.7.w,
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
          );
        },
      ),
    );
  }
}