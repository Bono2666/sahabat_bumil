import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/db/history_db.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../db/prods_db.dart';
import '../../model/prods_model.dart';

int prodId = 1;
String waNumber;
var prodsDb = ProdsDb();

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List dbHistory, dbSetup;
  var historyDb = HistoryDb();
  DateTime orderDate;

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getHistory() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_history.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getHistory(),
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
            dbHistory = snapshot.data;
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
                                'Histori',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0.sp,
                                ),
                              ),
                              SizedBox(height: 3.4.h,),
                              dbHistory.length > 0
                                  ? SizedBox(
                                child: ListView.builder(
                                  itemCount: dbHistory.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 0),
                                  itemBuilder: (context, index) {
                                    orderDate = DateTime(
                                        int.parse(dbHistory[index]['date'].substring(0, 4)),
                                        int.parse(dbHistory[index]['date'].substring(5, 7)),
                                        int.parse(dbHistory[index]['date'].substring(8, 10))
                                    );
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 6.7.w,),
                                      child: Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                child: Container(
                                                  width: 31.1.w,
                                                  height: 32.0.w,
                                                  child: Image.network(
                                                    dbHistory[index]['img'],
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
                                                        DateFormat('d MMMM yyyy', 'id_ID').format(orderDate),
                                                        style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          color: Theme.of(context).primaryColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: 1.1.w,),
                                                      Text(
                                                        dbHistory[index]['package'] + ' - ' +
                                                            dbHistory[index]['title'],
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color: Theme.of(context).colorScheme.background,
                                                        ),
                                                      ),
                                                      SizedBox(height: 1.1.w,),
                                                      Html(
                                                        data: dbHistory[index]['description'],
                                                        style: {
                                                          'body': Style(
                                                            color: Colors.black,
                                                            fontSize: FontSize(8.0.sp),
                                                            maxLines: 1,
                                                            textOverflow: TextOverflow.ellipsis,
                                                            margin: EdgeInsets.all(0),
                                                          )
                                                        },
                                                      ),
                                                      SizedBox(height: 6.7.w,),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            NumberFormat.currency(
                                                              locale: 'id',
                                                              symbol: 'Rp ',
                                                              decimalDigits: 0,
                                                            ).format(int.parse(dbHistory[index]['price'])),
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              color: Theme.of(context).colorScheme.background,
                                                            ),
                                                          ),
                                                          Expanded(child: SizedBox(),),
                                                          InkWell(
                                                            child: Container(
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal: 4.4.w, vertical: 1.4.w,),
                                                                child: Text(
                                                                  'Pesan Lagi',
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
                                                            onTap: () async {
                                                              prodId = int.parse(dbHistory[index]['history_id']);
                                                              waNumber = dbSetup[0]['wa_number'];

                                                              // if ((await prodsDb.count(prodId)) > 0) {
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
                                                                  isDismissible: false,
                                                                  builder: (context) => ViewProduct(),
                                                                );
                                                              // } else {
                                                              //   showDialog(
                                                              //     context: context,
                                                              //     builder: (_) => Alert(),
                                                              //     barrierDismissible: false,
                                                              //   );
                                                              // }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 1.1.w,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                                  : Column(
                                    children: [
                                      SizedBox(height: 2.5.h,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                                        child: Image.asset(
                                          'images/no_history.png',
                                          height: 62.0.w,
                                        ),
                                      ),
                                      SizedBox(height: 3.4.h,),
                                      Text(
                                        'Belum ada paket aqiqah yang dipesan!',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.background,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0.sp,
                                        ),
                                      ),
                                      SizedBox(height: 0.6.h,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                                        child: Text(
                                          'Saatnya mempercayakan pelaksanaan ibadah '
                                              'aqiqah dede bayi Ayah/Bunda bersama kami.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0.sp,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                ],
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
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/aqiqah', (route) => false),
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
              );
            },
          );
        },
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prodsDb.single(prodId),
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
                      dbSingle[0]['prods_image'],
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
                        dbSingle[0]['prods_fav'] == 0 ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                        width: 6.7.w,
                      ),
                      onTap: () {
                        setState(() {
                          if (dbSingle[0]['prods_fav'] == 1) {
                            var fav = Prods(
                              prodsId: dbSingle[0]['prods_id'],
                              prodsFav: 0,
                            );
                            prodsDb.updateFav(fav);
                          } else {
                            var fav = Prods(
                              prodsId: dbSingle[0]['prods_id'],
                              prodsFav: 1,
                            );
                            prodsDb.updateFav(fav);
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
                            dbSingle[0]['prods_name'],
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
                                ).format(dbSingle[0]['prods_price']),
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                              Expanded(child: SizedBox(),),
                              dbSingle[0]['prods_promo'] == ''
                                  ? Container() : Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.4.w, vertical: 1.4.w,),
                                  child: Text(
                                    dbSingle[0]['prods_promo'],
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
                            data: dbSingle[0]['prods_desc'],
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
    );
  }
}

class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0.w,
              constraints: BoxConstraints(
                minHeight: 24.0.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).dialogBackgroundColor,
                    blurRadius: 24,
                    offset: Offset(0, 24),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(7.8.w, 5.0.w, 7.8.w, 5.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maaf ya Ayah/Bunda, paket aqiqah ini sudah tidak tersedia lagi.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 7.0.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Ink(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 8.8.h,
                              height: 8.8.h,
                              child: Image.asset(
                                'images/ic_ok.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
