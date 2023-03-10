import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/UI/GoPremiumWidget.dart';
import 'package:fliqcard/UI/MainScreen.dart';
import 'package:fliqcard/UI/Staff/StaffListScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddEditPosition extends StatefulWidget {
  AddEditPosition({Key key}) : super(key: key);

  @override
  _AddEditPosition createState() => _AddEditPosition();
}

class _AddEditPosition extends State<AddEditPosition> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController positionController = TextEditingController();

  Future getPosition() {
    Provider.of<CustomViewModel>(context, listen: false)
        .getPosition();
  }

  Future updatePosition() {
    Provider.of<CustomViewModel>(context, listen: false)
        .updatePosition(
      positionController.text,
      1,
      0
    )
        .then((value) {
      setState(() {
        EasyLoading.dismiss();
        if (value == "success") {
          pushReplacement(context, AddEditPosition());
          commonToast(context, "Position Saved");
        } else {
          commonToast(context, value);
        }
      });
    });
  }

  Future deletePosition(position) {
    Provider.of<CustomViewModel>(context, listen: false)
        .updatePosition(
        position.toString(),
        0,
        1
    )
        .then((value) {
      setState(() {
        EasyLoading.dismiss();
        if (value == "success") {
          pushReplacement(context, AddEditPosition());
          commonToast(context, "Position Deleted");
        } else {
          commonToast(context, value);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallWhite(context, "Manage Position"),
          elevation: 0,
          leading: InkWell(
            onTap: () {
              // pop(context);
              Navigator.pop(context,true);
            },
            child: Container(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // commonTitleSmall(context,"Add Position"),
                commonTitleSmallBold(context, "Add Position"),

                SizedBox(height:10),

                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextFormField(
                          controller: positionController,
                          decoration: InputDecoration(
                            hintText: 'Position',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(COLOR_SUBTITLE)),
                            filled: true,
                            fillColor:
                            Colors.grey.withOpacity(0.1),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          if (_formKey.currentState
                              .validate()) {
                            EasyLoading.show(
                                status: 'loading...');
                            updatePosition();
                          } else {
                            commonToast(
                                context, "Invalid action");
                          }
                        },
                        child: Container(
                          height: 40,
                          // width: 60,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Color(COLOR_PURPLE_PRIMARY),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Save ",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 30),

                commonTitleSmallBold(context, "Position List"),

                SizedBox(height: 30),

                Container(
                  height: MediaQuery.of(context).size.height - 300,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    children:
                    // List.generate(Provider.of<CustomViewModel>(context, listen: false).positionList.length,
                    //     (index)=> Container(
                    //       color: ge,
                    //     )
                    // )

                    Provider.of<CustomViewModel>(context, listen: false).positionList.asMap().entries.map((e) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.5 - 31,
                            child: Text(e.value['position'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                          ),
                          GestureDetector(
                            onTap: (){
                              EasyLoading.show(status: 'loading...');
                              deletePosition(e.value['id']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.delete_outline_rounded, size: 26,)
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                )



                // List.generate(Provider.of<CustomViewModel>(context, listen: false).positionList.length,
                //     (index) => null
                // )

              ],
            )
          ),
        ),
      ),
    );
  }
}
