import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/router.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                children: [
                  Image(
                    image: R.image.ic_index_logo(),
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _buildButton(
                    context,
                    () => IdolRoute.startValidateEmail(context),
                    'LOG IN',
                  ),
                  _buildButton(
                    context,
                    () => IdolRoute.startJoinUs(context),
                    'CREATE ACCOUNT',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, VoidCallback onPressed, String title) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.white,
        ),
      ],
    );
  }
}
