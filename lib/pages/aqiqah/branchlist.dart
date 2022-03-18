// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class BranchList extends StatefulWidget {
  @override
  _BranchListState createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  List dbBranch;

  Future getBranches() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_branches.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
                            'Cabang',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0.sp,
                            ),
                          ),
                          SizedBox(height: 3.4.h,),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: dbBranch.length,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 0),
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
                                                      color: Theme.of(context).backgroundColor,
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
