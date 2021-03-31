import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/utils/global.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: R.image.bg_login_signup(), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'FORGOT PASSWODR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Don\'t worry, it happens to all of us.\n\nContact us with WhatsApp, and we will help you reset your password.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Image(
                          image: R.image.double_arrow_down(),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Global.launchWhatsApp();
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: R.image.whatsapp_small(),
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'WhatsApp',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: SizedBox(
                width: 44,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Image(
                    image: R.image.arrow_left(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
