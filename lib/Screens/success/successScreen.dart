import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nafa_money/Screens/Dashboard/home_dashbord.dart';
import 'package:nafa_money/Screens/auth/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nafa_money/colors.dart';
import 'package:nafa_money/localization/language_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SuccessScren extends StatefulWidget {
  const SuccessScren({ Key? key }) : super(key: key);

  @override
  _SuccessScrenState createState() => _SuccessScrenState();
}

class _SuccessScrenState extends State<SuccessScren> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(

          children: [
            Positioned(
              top: 70.h,
              right: -50.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: kPrimaryColor
                ),
              ),
            ),
             Positioned(
              top: 10.h,
              left: -50.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kPrimaryColor
                ),
              ),
            ),
            Positioned(
              top: 800.h,
              left: -50.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kPrimaryColor
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: 500.w,
                  height: 850.h,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
            
                           Container(
                            width: 200.0,
                          height: 200.0,
                           decoration: new BoxDecoration(
                            color: Colors.white,
                          shape: BoxShape.circle,
                           border: Border.all(
                            color: kPrimaryColor, //                   <--- border color
                            width: 2.w,
                            
                          ),
                     ),
                     child: Icon(
                       Icons.check,
                       color: kPrimaryColor,
                       size: 120.h,
                       )
                     ),
                     

                     SizedBox(height: 20.h,),
                     Container(
                       child: Text(
                        getTranslated(context, "success_text").toString(),
                         style: TextStyle(color: kPrimaryColor,fontSize: 30.sp,fontWeight: FontWeight.bold),
                         ),
                     ),
                     SizedBox(height: 20.h,),
                     Container(
                       child: Text(
                        getTranslated(context, "success_message").toString(),
                         style: TextStyle(color: kPrimaryColor,fontSize: 20.sp,),
                         ),
                     ),
                     SizedBox(height: 40.h,),
                     InkWell(
                          onTap: (){

                            
                                    Navigator.pushReplacement(
                                   context,
                                    MaterialPageRoute(builder: (context) => HomeDashBord()),
                            );
                                            },
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            width: 120.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: kPrimaryColor,

                            ),
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            alignment: Alignment.center,
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold),
                              ),
                            
                          ),
                        ) , 
                     Container()
                     
                       ]
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

 

}