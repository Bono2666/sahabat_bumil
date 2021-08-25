import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewArticle extends StatefulWidget {
  @override
  _ViewArticleState createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle> {
  List<QueryDocumentSnapshot> document, related;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('article')
            .where(FieldPath.documentId, isEqualTo: prefs.getArticleId)
            .get(),
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
              future: FirebaseFirestore.instance
                  .collection('article')
                  .where(FieldPath.documentId, isNotEqualTo: prefs.getArticleId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.hasError) {
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
                  related = snapshot.data.docs;
                  related.shuffle();
                }
                return Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      height: 100.0.h,
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: [
                          Image.network(
                            document[0].get('image'),
                            height: 74.0.h,
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
                          ),
                          Container(
                            height: 26.0.h,
                            color: Colors.white,
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
                                SizedBox(
                                  height: 1.7.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.6.w,
                                      height: 0.5.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6.0.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.6.w),
                                  child: Text(
                                    document[0].get('title'),
                                    style: TextStyle(
                                      fontSize: 20.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.9.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0.w),
                                  child: Html(
                                    data: document[0].get('content'),
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize.rem(1),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        padding: EdgeInsets.all(0),
                                        lineHeight: LineHeight.rem(1.1875),
                                      ),
                                      'h1': Style(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        fontSize: FontSize.rem(1.5),
                                        lineHeight: LineHeight.rem(1),
                                      ),
                                      'h2': Style(
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                      'h3': Style(
                                          textAlign: TextAlign.right,
                                          fontFamily: 'Uthmanic'
                                      ),
                                      'li': Style(
                                        padding: EdgeInsets.only(left: 0),
                                      ),
                                      'a': Style(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    },
                                    onLinkTap: (url, context, attributes,
                                        element) async {
                                      if (await canLaunch(url)) {
                                        await launch(
                                          url,
                                        );
                                      } else {
                                        throw 'Could not launch &url';
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 4.4.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.6.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/ic_article.png',
                                        height: 3.2.w,
                                      ),
                                      SizedBox(
                                        width: 1.4.w,
                                      ),
                                      Text(
                                        'Artikel lainnya',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2.8.h,
                                ),
                                SizedBox(
                                  height: 66.0.w,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        related.length > 3 ? 3 : related.length,
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        top: 0, left: 6.6.w, right: 1.1.w),
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.0.w),
                                            child: InkWell(
                                              child: Container(
                                                width: 86.6.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context)
                                                            .shadowColor,
                                                        blurRadius: 6.0,
                                                        offset: Offset(3, 0),
                                                      ),
                                                    ]),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                      ),
                                                      child: Container(
                                                        child: Image.network(
                                                          related[index]
                                                              .get('image'),
                                                          height: 43.0.w,
                                                          width: 86.6.w,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return SizedBox(
                                                              height: 43.0.w,
                                                              child: Center(
                                                                child:
                                                                    SpinKitPulse(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              3.8.w,
                                                              5.0.w,
                                                              3.8.w,
                                                              5.6.w),
                                                      child: Text(
                                                        related[index]
                                                            .get('title'),
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .backgroundColor,
                                                          fontSize: 13.0.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                prefs.setArticleId(
                                                    related[index].id);
                                                Navigator.pushNamed(
                                                    context, '/viewarticle');
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.9.w,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 12.5.h,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 19.4.w,
                                height: 29.0.w,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 13.0.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 6.6.w,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    Share.share(
                                      document[0].get('share'),
                                      sharePositionOrigin:
                                          box.localToGlobal(Offset.zero) &
                                              box.size,
                                    );
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
                                                color: Theme.of(context)
                                                    .shadowColor,
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
                                            'images/ic_share.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
