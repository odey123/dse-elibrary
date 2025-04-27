import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 9,
                  right: 9,
                  top: 6,
                  bottom: 6,
                ),
                decoration: BoxDecoration(
                  color: kGry300,
                  border: Border.all(
                    color: kGry450,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: SizedBox(
                  width: 9,
                  height: 15,
                  child: SvgPicture.asset(
                    AssetPaths.back,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset Password',
                  style: textTheme.titleSmall!.copyWith(
                    color: kPrimaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                YBox(kSmallPadding),
                Text(
                  'Don’t worry it happens. Please enter the email associated with your account',
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry800,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'and we’ll send an email with a recovery link to reset your password.',
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry800,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                YBox(kLargePadding),
                Container(
                  height: 40,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: kGry450,
                    ),
                    color: kTextfieldLoginBackground,
                  ),
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: textTheme.bodySmall!.copyWith(
                      color: kBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                      ),
                      hintText: 'Enter Your Email Address',
                      hintStyle: textTheme.bodySmall!.copyWith(
                        color: kgry700,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                    cursorColor: kBlack,
                  ),
                ),
                YBox(kMacroPadding),
                SizedBox(
                  height: 38,
                  width: 300,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: kSmallPadding,
                        right: kSmallPadding,
                        bottom: kRegularPadding,
                        top: kRegularPadding + 4,
                      ),
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      sendCode,
                      style: textTheme.titleSmall!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                YBox(kMacroPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember Password ? ',
                      style: textTheme.bodySmall!.copyWith(
                        color: kGry800,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          signInRoute,
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: kTransparent,
                        ),
                        child: Text(
                          'Sign In Here',
                          style: textTheme.bodySmall!.copyWith(
                            color: kDarkYellow,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
