import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {

  // ignore: deprecated_member_use
  int currentPage = 0, prevPage = 0;
  PageController pageController = new PageController();
  List<QueryDocumentSnapshot> document;

  @override
  void initState() {
    super.initState();

      Timer.periodic(Duration(seconds: 10), (Timer timer) {
        prevPage = currentPage;

        if (currentPage < (document.length - 1)) {
          currentPage++;
        } else {
          currentPage = 0;
        }

        pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInSine,
        );
      });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 86.0.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(58),
                      bottomRight: Radius.circular(58),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('onboarding').get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                      return
                        SizedBox(
                            width: 100.0.w,
                            height: 86.0.h,
                            child: Center(
                                child: SpinKitPulse(
                                  color: Colors.white,
                                )
                            )
                        );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      document = snapshot.data.docs;
                    }
                    return Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        SizedBox(
                          width: 100.0.w,
                          height: 86.0.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(58),
                              bottomRight: Radius.circular(58),
                            ),
                            child: PageView.builder(
                              itemCount: document.length,
                              controller: pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (contex, index) {
                                print(document.length.toString() + ' Slides');
                                return SlideItem(
                                  imageUrl: document[index].get('imageUrl'),
                                );
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 21.0.w,
                                height: 21.0.w,
                                child: Image.asset(
                                  'images/sahabat_bumil_logo.png',
                                  color: Colors.white,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 14.0.h,
                              ),
                              AnimatedCrossFade(
                                crossFadeState: CrossFadeState.showSecond,
                                duration: Duration(milliseconds: 300),
                                firstCurve: Curves.easeOutSine,
                                firstChild: Text(
                                  document[prevPage].get('title'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0.sp,
                                  ),
                                ),
                                secondCurve: Curves.easeOutSine,
                                secondChild: Text(
                                  document[currentPage].get('title'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              AnimatedCrossFade(
                                crossFadeState: CrossFadeState.showSecond,
                                duration: Duration(milliseconds: 300),
                                firstCurve: Curves.easeOutSine,
                                firstChild: Text(
                                  document[prevPage].get('description'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                                secondCurve: Curves.easeOutSine,
                                secondChild: Text(
                                  document[currentPage].get('description'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35.0.h,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 8.0.h,
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: document.length,
                            effect: WormEffect(
                              dotWidth: 1.5.w,
                              dotHeight: 1.5.w,
                              spacing: 3.0.w,
                              activeDotColor: Theme.of(context).primaryColor,
                              dotColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Container(
                height: 14.0.h,
                child: Center(
                  child: Text(
                    'Mulai',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0.sp,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

// ignore: must_be_immutable
class SlideItem extends StatelessWidget {
  String imageUrl;

  SlideItem({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned(
                bottom: 20.0.h,
                child: SpinKitPulse(
                  color: Colors.white,
                ),
              ),
            ]
          );
      },
    );
  }
}
