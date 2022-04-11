import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:nafa_money/Screens/Bank/transfert_bank.dart';
import 'package:nafa_money/Screens/Bank/withdrawal_bank.dart';
import 'package:nafa_money/localization/language_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nafa_money/colors.dart';

class HomeBank extends StatefulWidget {
  
  const HomeBank({ Key? key }) : super(key: key);

  @override
  _HomeBankState createState(

  ) => _HomeBankState();
}

class _HomeBankState extends State<HomeBank> {

   String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    @override
  void initState() {
    border = OutlineInputBorder(borderRadius: BorderRadius.circular(10));
    super.initState();
    
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          getTranslated(context, "bank_text").toString(),
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
        body: Container(
          decoration: BoxDecoration(
            image: useBackgroundImage
                ? const DecorationImage(
                    image: ExactAssetImage('assets/images/bg.png'),
                    fit: BoxFit.fill,
                  )
                : null,
            color: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                 SizedBox(
                  height: 30.h,
                ),
                CreditCardWidget(
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: kPrimaryColor,
                  backgroundImage:
                      useBackgroundImage ? 'assets/images/card_bg.png' : null,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/images/mastercard.png',
                        height: 55.h,
                        width: 48.w,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.black,
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            enabledBorder:  OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10))

                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                             focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                             focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                             focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                         SizedBox(
                          height: 70.h,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     const Text(
                        //       'Glassmorphism',
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 18,
                        //       ),
                        //     ),
                        //     Switch(
                        //       value: useGlassMorphism,
                        //       inactiveTrackColor: Colors.grey,
                        //       activeColor: Colors.black,
                        //       activeTrackColor: Colors.green,
                        //       onChanged: (bool value) => setState(() {
                        //         useGlassMorphism = value;
                        //       }),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     const Text(
                        //       'Card Image',
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 18,
                        //       ),
                        //     ),
                        //     Switch(
                        //       value: useBackgroundImage,
                        //       inactiveTrackColor: Colors.grey,
                        //       activeColor: Colors.black,
                        //       activeTrackColor: Colors.green,
                        //       onChanged: (bool value) => setState(() {
                        //         useBackgroundImage = value;
                        //       }),
                        //     ),
                        //   ],
                        // ),
                     
                       Container(
                        margin: EdgeInsets.only(left: 2.h,right: 2.h),
                        width: 320.w,
                        height: 58.h,
                        child: TextButton(
                         style:TextButton.styleFrom(
                          backgroundColor:  kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                              shadowColor: Colors.black,
                              elevation: 5
                              ),
                    child: Text(
                       getTranslated(context,"validate_button_text").toString(),
                      style: TextStyle(color: Colors.white,fontSize: 15.sp),
                      ),
                    onPressed:(){

                          if (formKey.currentState!.validate()) {
                              print(cardNumber);
                              yyBottomSheetDialogRecharge(context);
                            } else {
                              print('invalid!');
                            }
                     
    
                    } ,
                    
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
      );
    
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  YYDialog yyBottomSheetDialogRecharge(BuildContext context) {
    return YYDialog().build(context)
      ..gravity = Gravity.bottom
      ..gravityAnimationEnable = true
      ..backgroundColor = Colors.transparent
      //..duration = Duration(seconds: 2)
      ..widget(Container(
           width: 340.w,
          height: 370.h,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r),topRight: Radius.circular(40.r)),
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
                  title: Text(
                    "Opération",
                    style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: 23.sp),
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
               
                // Center(
                //   child:Text(
                //     "Opération",
                //     style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: 28.sp),
                //     ),
                // ),
                 //SizedBox(height: 5.h,), 

                 Center(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                         Text(
                          "",
                            style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: 15.sp),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(
                                   context,
                                  MaterialPageRoute(builder: (context) => Withdrawal(operationType: getTranslated(context, "withdrawal_text").toString(),)));
                  },
                  child: Container(
                      width: 320.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                //spreadRadius: 5
                              )
                            ]),
                            child:   ListTile(
                    title: Text(
                      getTranslated(context, "withdrawal_text").toString(),
                      style:TextStyle(fontSize: 20.sp,color: Colors.black,fontWeight: FontWeight.bold)
                      ),
                    subtitle: Text(""),
                    leading: Material(
                                elevation: 7,
                                shape: CircleBorder(),
                                // shadowColor: widget.payment.color.withOpacity(0.4),
                                child: Container(
                                  height: 70.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Icon(Icons.credit_card,size: 30.w,)
                                  ),
                                 ),
                                ),
                    ),
                  ),
                ),
              SizedBox(height: 20.h,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                     Navigator.push(
                                   context,
                                  MaterialPageRoute(builder: (context) => TransfertBank(operationType: getTranslated(context, "transfer_text").toString(),)));
                  },
                  child: Container(
                      width: 320.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                //spreadRadius: 5
                              )
                            ]),
                            child:   ListTile(
                    title: Text(
                      getTranslated(context, "transfer_text").toString(),
                      style:TextStyle(fontSize: 20.sp,color: Colors.black,fontWeight: FontWeight.bold)
                      ),
                    subtitle: Text(""),
                    leading: Material(
                                elevation: 7,
                                shape: CircleBorder(),
                                // shadowColor: widget.payment.color.withOpacity(0.4),
                                child: Container(
                                  height: 70.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Icon(Icons.credit_card,size: 30.w,)
                                  ),
                                 ),
                                ),
                    ),
                  ),
                ),
                //SizedBox(height: 40.h,),
              //    Container(
              //   width: 300.w,
              //   height: 50,
              //   margin: EdgeInsets.only(left: 30,right: 30),
              //   child: TextButton(
              //     onPressed: (){  
                              
              //     },
              //     child: Text(
              //       "Confirmer",
              //       style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
              //       ),
              //     style: TextButton.styleFrom(
              //       backgroundColor: kPrimaryColor,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
                    
              //       )
              //     ),
              //   ),
              // )
                
                
              ],
            ),
          )))
      ..show();
  }
}