import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ugbs_dawuro_ios/constant.dart';
import 'package:ugbs_dawuro_ios/widgets/signin.dart';
import 'package:ugbs_dawuro_ios/widgets/signup.dart';

class SignUpAndSignIn extends StatefulWidget {
  const SignUpAndSignIn({Key? key}) : super(key: key);
  static const String id = 'sign up and sign in page';

  @override
  _SignUpAndSignInState createState() => _SignUpAndSignInState();
}

class _SignUpAndSignInState extends State<SignUpAndSignIn>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.black])
                      .createShader(bounds);
                },
                child: Image.asset(
                  'images/ug.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 130,
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 115,
                child: Text(
                  'Sign up to access the Application',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                bottom: 0,
                child: GFTabBar(
                    indicatorColor: Colors.white,
                    tabBarColor: Colors.transparent,
                    length: 2,
                    tabs: [
                      Tab(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                    controller: tabController),
              ),
            ],
          ),
          GFTabBarView(
            controller: tabController,
            children: <Widget>[
              SignUpWidget(),
              SignInWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
