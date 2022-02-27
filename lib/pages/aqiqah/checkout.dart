import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/db/prods_db.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List dbSetup, dbProduct, dbTotalOrder;
  int jmlPesan = 1;
  int totOrder = 0;
  var prodsDb = ProdsDb();

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getTotalOrder() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_total_order.php?id=' +
        prefs.getIdProduct);
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updTotalOrder() async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/post_total_order.php?id=' +
        prefs.getIdProduct + '&order=' + totOrder.toString();
    await http.post(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
          return FutureBuilder(
            future: prodsDb.single(int.parse(prefs.getIdProduct)),
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
                dbProduct = snapshot.data;
              }
              return FutureBuilder(
                future: getTotalOrder(),
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
                    dbTotalOrder = snapshot.data;
                  }
                  return Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 19.0.h,),
                                Text(
                                  'Jumlah Paket',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0.sp,
                                  ),
                                ),
                                SizedBox(height: 3.4.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              dbProduct[0]['prods_package'] + ' - ' +
                                                  dbProduct[0]['prods_name'],
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 13.0.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                            SizedBox(height: 1.1.w,),
                                            Html(
                                              data: dbProduct[0]['prods_desc'],
                                              style: {
                                                'body': Style(
                                                  color: Colors.black,
                                                  fontSize: FontSize(8.0.sp),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.right,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  margin: EdgeInsets.all(0),
                                                )
                                              },
                                            ),
                                            SizedBox(height: 6.7.w,),
                                            Row(
                                              children: [
                                                dbProduct[0]['prods_promo'] == ''
                                                    ? Container() : Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 4.4.w, vertical: 1.4.w,),
                                                    child: Text(
                                                      dbProduct[0]['prods_promo'],
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
                                                Expanded(child: SizedBox(),),
                                                Text(
                                                  NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0,
                                                  ).format(dbProduct[0]['prods_price']),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 10.0.sp,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 1.1.w,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.4.w,),
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      child: Container(
                                        width: 31.1.w,
                                        height: 32.0.w,
                                        child: Image.network(
                                          dbProduct[0]['prods_image'],
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return SizedBox(
                                              height: 32.0.w,
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
                                  ],
                                ),
                                SizedBox(height: 3.0.h,),
                                Row(
                                  children: [
                                    Text(
                                      'Jumlah Paket',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                    Expanded(child: SizedBox(),),
                                    InkWell(
                                      onTap: () {
                                        if (jmlPesan > 1) {
                                          setState(() {
                                            jmlPesan = jmlPesan - 1;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        jmlPesan == 1
                                            ? 'images/ic_min_inactive.png'
                                            : 'images/ic_min_active.png',
                                        width: 9.4.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.9.w,
                                      child: Text(
                                        jmlPesan.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Theme.of(context).backgroundColor,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          jmlPesan = jmlPesan + 1;
                                        });
                                      },
                                      child: Image.asset(
                                        'images/ic_plus_active.png',
                                        width: 9.4.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Expanded(child: SizedBox()),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 6.4.h,
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
                                  Container(
                                    height: 5.0.h,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  String hrg =
                                  NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(dbProduct[0]['prods_price']);

                                  launch('https://api.whatsapp.com/send?phone=' + dbSetup[0]['wa_number'] +
                                      '&text=Assalamualaikum%2C%0D%0A%0D%0ASaya+melihat+di+aplikasi+Sahabat+Bumil%2C+'
                                          'dan+tertarik+dengan%0D%0A%0D%0A*' + dbProduct[0]['prods_package'] + ' - ' +
                                      dbProduct[0]['prods_name'] + '*%0D%0A*Harga:*+' + hrg + '%0D%0A*Jumlah+Paket:*+' +
                                      jmlPesan.toString() + '%0D%0A%0D%0ATerima+kasih!' + '%0D%0A%0D%0A' + dbProduct[0]['prods_link']);

                                  totOrder = int.parse(dbTotalOrder[0]['total_order']) + jmlPesan;
                                  updTotalOrder();

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, '/aqiqah');
                                },
                                child: Container(
                                  width: 74.0.w,
                                  height: 20.8.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Pesan Sekarang via WA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0.sp,
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
              );
            },
          );
        },
      ),
    );
  }
}