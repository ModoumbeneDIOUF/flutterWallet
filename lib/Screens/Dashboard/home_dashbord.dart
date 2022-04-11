import 'package:flutter/material.dart';
import 'package:nafa_money/ScanCode/qr_create_page.dart';
import 'package:nafa_money/ScanCode/qr_scan_page.dart';
import 'package:nafa_money/ScanCode/localNotification.dart';
import 'package:nafa_money/ScanCode/takeImage.dart';
import 'package:nafa_money/Screens/Bank/home_bank.dart';
import 'package:nafa_money/Screens/Dashboard/all_transactions.dart';
import 'package:nafa_money/Screens/Dashboard/transaction_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:nafa_money/Screens/achatCredit/buy_Credit.dart';
import 'package:nafa_money/Screens/api/language.dart';
import 'package:nafa_money/Screens/payment/bill_payment.dart';
import 'package:nafa_money/Screens/send/addNumber.dart';
import 'package:nafa_money/localization/language_constants.dart';
import 'package:nafa_money/main.dart';
import 'package:nafa_money/widgets/navigation_drawer_widget.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';

import '../../colors.dart';

class HomeDashBord extends StatefulWidget {
  const HomeDashBord({Key? key}) : super(key: key);

  @override
  _HomeDashBordState createState() => _HomeDashBordState();
}

class _HomeDashBordState extends State<HomeDashBord> {

  SharedPreferences? prefs;
  String? userPassword;

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String dropdownValue = 'FR';

  ProgressDialog? progressDialog;

  bool hideSum = true;


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

  
  void _changeLanguage(Language language) {
    Locale _temps;

    switch (language.languageCode) {
      case 'en':
        _temps = Locale(language.languageCode, 'US');
        break;
      case 'fr':
        _temps = Locale(language.languageCode, 'FR');
        break;
      default:
        _temps = Locale(language.languageCode, 'FR');
    }

    MyApp.setLocale(context, _temps);
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);

    progressDialog!.style(
      message: 'Connexion en cours ...',
    );

    return Scaffold(
        resizeToAvoidBottomInset: false, 
        key: _scaffoldState,
        drawer: NavigationDrawerWidget(),
        body: Stack(children: [
          Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 1.h, top: 28.3.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 30.h,
                        color: Colors.white,
                      ),
                      onPressed: () {
                       
                        _scaffoldState.currentState!.openDrawer();
                        print("drawer");
                        
                      }),
                  Container(
                    margin: EdgeInsets.only(right: 8.h),
                    child: DropdownButton(
                        onChanged: (Language? language) {
                          setState(() {
                            _changeLanguage(language!);
                          });
                        },
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.language,
                          color: Colors.white,
                           size: 30.h,
                        ),
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                                (lang) => DropdownMenuItem(
                                      value: lang,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(lang.name),
                                          Text(lang.flag),
                                        ],
                                      ),
                                    ))
                            .toList()),
                  )
                ],
              )
              
              ),
          Container(
            margin: EdgeInsets.only(left: 30.h, top: 160.h),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                  
                  Navigator.push(
                                   context,
                                  MaterialPageRoute(builder: (context) => LocalNotification()));
                  },
                  child: Text(
                    "Ousseynou Traoré",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 300.w,
            height: 130.h,
            margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 230.h),
            // padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    // spreadRadius: 5
                  )
                ]),
            child: Container(
              margin: EdgeInsets.only(top: 7.h,left: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 10.w,
                        ),
                        child: Text(
                            getTranslated(context, "my_balance")!.toString(),
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                                fontSize: 17.sp)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20.w,
                        ),
                        child: InkWell(
                            onTap: () {
                              if (hideSum == true) {
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
                                    padding: EdgeInsets.only(top: 10.h,left: 10.w),
                                    text: getTranslated(
                                            context, "password_hint_text")
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
                                            if(pin == userPassword){
                                              Navigator.pop(context, true);
                                            progressDialog!.show();
                                            Future.delayed(Duration(seconds: 2))
                                                .then((value) {
                                              progressDialog!
                                                  .hide()
                                                  .then((value) => setState(() {
                                                        hideSum = !hideSum;
                                                      }));
                                            });
                                            }

                                            else {
                                              Navigator.pop(context, true);
                                              progressDialog!.show();
                                             Future.delayed(Duration(seconds: 3)).then((value) {
                                                   progressDialog!.hide().then((value) {

                                                         Toast.show("Mot de passe incorrect", context,
                                                           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                                              } );
                                                 });
                                            }
                                          }, // end onSubmit
                                        ),
                                      ],
                                    ),
                                  ))
                                  ..show();
                              } else {
                                setState(() {
                                  hideSum = !hideSum;
                                });
                              }
                            },
                            child: Icon(!hideSum
                                ? Icons.remove_red_eye_sharp
                                : Icons.remove_red_eye_outlined)),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.h, top: 10.5.h),
                    child: !hideSum
                        ? Row(
                            children: [
                              Text(
                                "2 500 100 FCFA",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 50.w,
                              ),
                              InkWell(
                                onTap: () {
                                  print("recharger ");
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(color: kPrimaryColor),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 5,
                                          //spreadRadius: 5
                                        )
                                      ]),
                                  child: Center(
                                    child: Text(
                                      getTranslated(context, "reload")!
                                          .toString(),
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : HiddSum(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h, left: 10.h),
                    child: Text(
                      getTranslated(context, "update_ate")!.toString() +
                          " " +
                          " 22/03/2021",
                    ),
                  )
                ],
              ),
            ),
          ),
          //container transactions 
          Container(  
             margin: EdgeInsets.only(top: 400.h, left: 35.h, right: 35.h),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                  "Transactions",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800),
                ),
                InkWell(
                  onTap: () {

                    print("voir tout");
                    Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => AllTransactions(
                                    
                                  )));

                  },
                  child: Container(
                    width: 80.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            // spreadRadius: 5
                          )
                        ]),
                    child: Center(
                      child: Text(
                        getTranslated(context, "see_all_text")!.toString(),
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize:14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
                   ],
                 ),
                 SizedBox(height: 20.h,),
                  SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                             InkWell(
                                 onTap: (){
              
                                      Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                   builder: (context) => TransactionDetails(
                                    
                                   )));
                                },
                               child: Container(
                                    margin: EdgeInsets.only(right: 10.w),
                                    height: 150.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Color(0xfff1f3f6)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 70.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/profil.jpg'),
                                              fit: BoxFit.contain
                                            ),
                                            border: Border.all(
                                              color: kPrimaryColor,
                                              width: 2
                                            )
                                          ),
                                        ),
                                        Text("Moussa Diop", style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700
                                        ),)
                                      ],
                                    ),
                                  ),
                             ),
                            
                               Container(
                                margin: EdgeInsets.only(right: 10.w),
                                height: 150.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xfff1f3f6)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 70.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/profil.jpg'),
                                          fit: BoxFit.contain
                                        ),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                          width: 2
                                        )
                                      ),
                                    ),
                                    Text("Adama Séne", style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700
                                    ),)
                                  ],
                                ),
                              ),
                               Container(
                                margin: EdgeInsets.only(right: 10.w),
                                height: 150.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xfff1f3f6)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 70.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/profil.jpg'),
                                          fit: BoxFit.contain
                                        ),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                          width: 2
                                        )
                                      ),
                                    ),
                                    Text("Ousmane Faye", style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700
                                    ),),
                                  ],
                                ),
                              ),
                               Container(
                                margin: EdgeInsets.only(right: 10.w),
                                height: 150.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xfff1f3f6)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 70.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/profil.jpg'),
                                          fit: BoxFit.contain
                                        ),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                          width: 2
                                        )
                                      ),
                                    ),
                                    Text("Penda Diouf", style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700
                                    ),)
                                  ],
                                ),
                              ),
                           Container(
                                margin: EdgeInsets.only(right: 10.w),
                                height: 150.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xfff1f3f6)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 70.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/profil.jpg'),
                                          fit: BoxFit.contain
                                        ),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                          width: 2
                                        )
                                      ),
                                    ),
                                    Text("Khadim Diop", style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700
                                    ),)
                                  ],
                                ),
                              )
                           ],
                        ) ,
                     ),
                 
               ],
             ),
          ),

          Container(
               margin: EdgeInsets.only(top: 640.h, left: 35.h, right: 35.h),
               child: Column(
                
                 children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Services',
                       style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800),),
                      // Container(
                      //   height: 60,
                      //   width: 60,
                      //   //child: Icon(Icons.dialpad),
                      // )
                  ],
                 ),
                 
                 Expanded(
                   child:GridView.count(
                     crossAxisCount: 3,
                      childAspectRatio: 1,
                      
                      children: [
                        
                        Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                     onTap: () {
                                            yyBottomSheetDialogTransfert(context);
                                          },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color:kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.compare_arrows,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "transfert_lower_text").toString(), style: TextStyle(
                                    color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        yyBottomSheetDialogBill(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.my_library_books,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "bill_lower_text").toString(), style: TextStyle(
                                    color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                           yyBottomSheetDialogCredit(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.phone_android,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "credit_lower_text").toString(), style: TextStyle(
                                     color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                               Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                          // yyBottomSheetDialogCredit(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.pin_rounded,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "merchant_code_text").toString(), style: TextStyle(
                                     color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                             Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                         //  yyBottomSheetDialogCredit(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.local_airport_outlined,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "buy_ticket_text").toString(), style: TextStyle(
                                     color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                         //  yyBottomSheetDialogCredit(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.directions_car_rounded,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "fuel_purchase_text").toString(), style: TextStyle(
                                     color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                             
                              Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                           Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>HomeBank() ));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: kPrimaryColor
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.all(25),
                                            child: Icon(
                                                  Icons.credit_card,
                                                  color: Colors.white,
                                                  size: 40.h,
                                                )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                  Text(getTranslated(context, "bank_text").toString(), style: TextStyle(
                                     color:Colors.blue,
                                    fontFamily: 'avenir',
                                    fontSize: 14,
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                      ],
                     )
                 )
                 ],
               ),
          ),
          
          
        ]
        )
        );
  }

  YYDialog yyBottomSheetDialogTransfert(BuildContext context) {
    return YYDialog().build(context)
      ..gravity = Gravity.bottom
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      //..duration = Duration(seconds: 2)
      ..widget(Container(
          width: 340.w,
          height: 494.h,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: new Text(
                    getTranslated(context, "transfert_lower_text").toString(),
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: PhysicalShape(
                      color: kPrimaryColor,
                      // shadowColor: Colors.grey,
                      //elevation: 10,
                      clipper: ShapeBorderClipper(shape: CircleBorder()),
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EnvoyerAUnNumero(
                                  transfertType: getTranslated(
                                          context, "transfer_to_nafa_text")
                                      .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      getTranslated(context, "nafa_transfer_text").toString(),
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "transfer_to_nafa_text")
                          .toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                        height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/nafa_send.png"))),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                  child: Divider(
                    color: Colors.black.withOpacity(0.1),
                    height: 4.h,
                    thickness: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EnvoyerAUnNumero(
                                  transfertType: getTranslated(
                                          context, "transfer_to_om_text")
                                      .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "Orange Money",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "transfer_to_om_text").toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                         height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/om.png"))),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                  child: Divider(
                    color: Colors.black.withOpacity(0.1),
                    height: 4.h,
                    thickness: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EnvoyerAUnNumero(
                                  transfertType: getTranslated(
                                          context, "transfer_to_fm_text")
                                      .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "Free Money",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "transfer_to_fm_text").toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                         height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/fm.png"))),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                  child: Divider(
                    color: Colors.black.withOpacity(0.1),
                    height: 4.h,
                    thickness: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EnvoyerAUnNumero(
                                  transfertType: getTranslated(
                                          context, "transfer_to_em_text")
                                      .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "E-Money",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "transfer_to_em_text").toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                         height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/em.png"))),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                  child: Divider(
                    color: Colors.black.withOpacity(0.1),
                    height: 4.h,
                    thickness: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EnvoyerAUnNumero(
                                  transfertType: getTranslated(
                                          context, "transfer_to_wave_text")
                                      .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "Wave",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "transfer_to_wave_text")
                          .toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                        height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/wave.png"))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )))
      ..show();
  }

//bill dialog

  YYDialog yyBottomSheetDialogBill(BuildContext context) {
    return YYDialog().build(context)
      ..gravity = Gravity.bottom
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      //..duration = Duration(seconds: 2)
      ..widget(Container(
          width: 340.w,
          height: 500.h,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

        
                ListTile(
                  title: new Text(
                    getTranslated(context, "bill_lower_text").toString(),
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: PhysicalShape(
                      color: kPrimaryColor,
                      // shadowColor: Colors.grey,
                      //elevation: 10,
                      clipper: ShapeBorderClipper(shape: CircleBorder()),
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                  SizedBox(height: 3.h,),
                SizedBox(
                  height: 400.h,
                  child: ListView(
                    shrinkWrap: true,
                  
  
               scrollDirection: Axis.vertical,
                    children: [
                      InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType:
                                        getTranslated(context, "bill_sonatel")
                                            .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "Sonatel",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "bill_sonatel").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/orange.jpg"))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 4.h,
                      thickness: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType:
                                        getTranslated(context, "bill_woyofal")
                                            .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "Woyofal",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "bill_woyofal").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/woyofal.jpg"))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 4.h,
                      thickness: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType: getTranslated(context, "bill_tnt")
                                        .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "TNT",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "bill_tnt").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/tnt.png"))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 4.h,
                      thickness: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType: getTranslated(context, "bill_canal")
                                        .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "Canal Plus",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "bill_canal").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/canal.png"))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 4.h,
                      thickness: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType: getTranslated(context, "rapido_tnt")
                                        .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "Rapido",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "rapido_tnt").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/rapido.jpg"))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 4.h,
                      thickness: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType:
                                        getTranslated(context, "sen_assurence")
                                            .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "Sen Assurance Vie",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "sen_assurence").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/senass.jpg"))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 4.h,
                      thickness: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BillPayment(
                                    billType:
                                        getTranslated(context, "nsia_assurence")
                                            .toString(),
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        "NSIA Assurance Vie",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        getTranslated(context, "nsia_assurence").toString(),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 25.w,
                      ),
                      leading: Material(
                        elevation: 7,
                        shape: CircleBorder(),
                        // shadowColor: widget.payment.color.withOpacity(0.4),
                        child: Container(
                         height: 75.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/nsia.jpg"))),
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                )
              ],
            ),
          )))
      ..show();
  }

//bill dialog

  YYDialog yyBottomSheetDialogCredit(BuildContext context) {
    return YYDialog().build(context)
      ..gravity = Gravity.bottom
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      //..duration = Duration(seconds: 2)
      ..widget(Container(
           width: 340.w,
          height: 356.h,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: new Text(
                    getTranslated(context, "credit_lower_text").toString(),
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: PhysicalShape(
                      color: kPrimaryColor,
                      // shadowColor: Colors.grey,
                      //elevation: 10,
                      clipper: ShapeBorderClipper(shape: CircleBorder()),
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => BuyCredit(
                                  creditType:
                                      getTranslated(context, "credit_seddo")
                                          .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "Seddo",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "credit_seddo").toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                       height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/orange.jpg"))),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                  child: Divider(
                    color: Colors.black.withOpacity(0.1),
                    height: 4.h,
                    thickness: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => BuyCredit(
                                  creditType:
                                      getTranslated(context, "credit_izi")
                                          .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "IZI",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "credit_izi").toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                       height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/free.jpg"))),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(left: 3.h, right: 3.h),
                  child: Divider(
                    color: Colors.black.withOpacity(0.1),
                    height: 4.h,
                    thickness: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => BuyCredit(
                                  creditType:
                                      getTranslated(context, "credit_yakalma")
                                          .toString(),
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      "Yakalma",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      getTranslated(context, "credit_yakalma").toString(),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: kPrimaryColor,
                      size: 25.w,
                    ),
                    leading: Material(
                      elevation: 7,
                      shape: CircleBorder(),
                      // shadowColor: widget.payment.color.withOpacity(0.4),
                      child: Container(
                       height: 75.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/expresso.jpg"))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )))
      ..show();
  }
}

YYDialog yYAlertDialogForSeeSum(BuildContext context) {
  return YYDialog().build(context)
    ..width = 240
    ..borderRadius = 4.0
    ..duration = Duration(milliseconds: 700)
    ..animatedFunc = (child, animation) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            0.0,
            Tween<double>(begin: -50.0, end: 50.0)
                .animate(
                  CurvedAnimation(curve: Interval(0.1, 0.5), parent: animation),
                )
                .value,
          )
          ..scale(
            Tween<double>(begin: 0.5, end: 1.0)
                .animate(
                  CurvedAnimation(curve: Interval(0.5, 0.9), parent: animation),
                )
                .value,
          ),
        child: child,
      );
    }
    ..text(
      padding: EdgeInsets.all(18.0),
      text: getTranslated(context, "password_hint_text").toString(),
      color: Colors.black,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    )
    ..widget(Container(
      width: 100.w,
      height: 15.h,
      child: Column(
        children: [
          PinEntryTextField(
            showFieldAsBox: false,
            isTextObscure: true,

            onSubmit: (String pin) {
              Navigator.pop(context, true);
            }, // end onSubmit
          ),
        ],
      ),
    ))
    ..show();
}

class HiddSum extends StatelessWidget {
  const HiddSum({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 25.h,
          width: 10.w,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor,
                  // offset: Offset(0, 0),
                  // spreadRadius: 1.5,
                  blurRadius: 2,
                )
              ]),
        )
      ],
    ));
  }
}
