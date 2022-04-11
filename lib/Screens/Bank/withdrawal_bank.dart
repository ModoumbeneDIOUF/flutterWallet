import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:nafa_money/Model/contact_favori.dart';
import 'package:nafa_money/Screens/api/db_helper.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:nafa_money/Screens/send/sendManySum.dart';
import 'package:nafa_money/Screens/success/successScreen.dart';
import 'package:nafa_money/colors.dart';
import 'package:nafa_money/localization/language_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Withdrawal extends StatefulWidget {
  final String operationType;

  const Withdrawal({Key? key, required this.operationType}) : super(key: key);

  @override
  _WithdrawalState createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  SharedPreferences? prefs;
  String? userPassword;
  ProgressDialog? progressDialog;

  TextEditingController phonenumber = TextEditingController();
  TextEditingController amount = TextEditingController();
  String initialCountry = 'SN';

  PhoneNumber number = PhoneNumber(isoCode: 'SN');

  String _phonenumber = "";
  String _amount = "";

  @override
  void initState() {
    super.initState();
    init();
    getUserInfo();
  }

  getUserInfo() async {
    prefs = await SharedPreferences.getInstance();

    List stringListval = prefs!.getStringList('user') ?? [];

    print(stringListval);

    setState(() {
      userPassword = stringListval[4];
    });
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);

    progressDialog!.style(
      message: 'Connexion en cours ...',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: kPrimaryColor,
        title: Text(
          widget.operationType,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Container(
                padding: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
                child: TextField(
                  controller: amount,
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(RegExp("[0-9]")),
                  ],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    // prefix: Icon(Icons.search),
                    labelText: getTranslated(context, "amout_text").toString(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _amount = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
          Positioned(
            right: 10.w,
            left: 10.w,
            top: 700.h,
            child: Center(
              child: Container(
                width: 300.w,
                height: 60.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          _amount != "" ? kPrimaryColor : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      shadowColor: Colors.black,
                      elevation: 5),
                  child: Text(
                    getTranslated(context, "send_button_text").toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: _amount != ""
                      ? () {
                          YYDialog().build(context)
                            ..width = 225.w
                            ..borderRadius = 4.0.r
                            ..duration = Duration(milliseconds: 700)
                            ..animatedFunc = (child, animation) {
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..translate(
                                    0.0,
                                    Tween<double>(begin: -50.0, end: 50.0)
                                        .animate(
                                          CurvedAnimation(
                                              curve: Interval(0.1, 0.5),
                                              parent: animation),
                                        )
                                        .value,
                                  )
                                  ..scale(
                                    Tween<double>(begin: 0.5, end: 1.0)
                                        .animate(
                                          CurvedAnimation(
                                              curve: Interval(0.5, 0.9),
                                              parent: animation),
                                        )
                                        .value,
                                  ),
                                child: child,
                              );
                            }
                            ..text(
                              padding: EdgeInsets.only(top: 10.h, left: 10.w),
                              text: getTranslated(context, "password_hint_text")
                                  .toString(),
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            )
                            ..widget(Container(
                              width: 200.w,
                              height: 100.h,
                              child: Column(
                                children: [
                                  PinEntryTextField(
                                    showFieldAsBox: false,
                                    isTextObscure: true,

                                    onSubmit: (String pin) {
                                      if (pin == userPassword) {
                                        Navigator.pop(context, true);
                                        progressDialog!.show();
                                        Future.delayed(Duration(seconds: 2))
                                            .then((value) {
                                          progressDialog!
                                              .hide()
                                              .then((value) => setState(() {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SuccessScren()));
                                                  }));
                                        });
                                      } else {
                                        Navigator.pop(context, true);
                                        progressDialog!.show();
                                        Future.delayed(Duration(seconds: 3))
                                            .then((value) {
                                          progressDialog!.hide().then((value) {
                                            Toast.show("Mot de passe incorrect",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          });
                                        });
                                      }
                                    }, // end onSubmit
                                  ),
                                ],
                              ),
                            ))
                            ..show();
                        }
                      : null,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
