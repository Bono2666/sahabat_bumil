import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';

class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  List<QueryDocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('article')
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
            document = snapshot.data.docs;
            document.shuffle();
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 6.6.w),
                      child: Column(
                        children: [
                          SizedBox(height: 19.0.h,),
                          Text(
                            'Artikel',
                            style: TextStyle(
                              fontSize: 24.0.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          SizedBox(height: 3.1.h,),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: document.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.0.w),
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
                                            offset: Offset(0, 3),
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
                                              document[index]
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
                                            document[index]
                                                .get('title'),
                                            style: TextStyle(
                                              color: Theme.of(
                                                  context)
                                                  .colorScheme.background,
                                              fontSize: 13.0.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    prefs.setArticleId(
                                        document[index].id);
                                    Navigator.pushNamed(
                                        context, '/viewarticle');
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 2.5.h,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 5.6.h,),
                      Padding(
                        padding: EdgeInsets.only(right: 2.2.w,),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/search');
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
                                    'images/ic_search.png',
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
