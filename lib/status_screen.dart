import 'package:flutter/material.dart';
import 'dropdown_with_checkboxes_adjusted.dart';
import 'dropdown_single_choice_adjusted.dart';

class StatusScreen extends StatefulWidget {
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool overlayOpened = false;
  OverlayEntry floatingStatus;
  //Globalkey und Position des Buttons (Position der oberen linkwn Ecke des Buttons gespeichert)
  GlobalKey actionKey;
  double buttonHeight, buttonWidth, xPosition, yPosition;


  @override
  void initState() {
    actionKey = LabeledGlobalKey("overlayCallingButton");
    super.initState();
  }

  void findDropdownData(){
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    buttonHeight = renderBox.size.height;
    buttonWidth = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    //Position des zum actionKey gehörenden Elementes (um Padding verschoben)
    xPosition = offset.dx;
    yPosition = offset.dy;

  }



  OverlayEntry _createFloatingStatus(){
    double width = MediaQuery.of(context).size.width - 50;
    double height = MediaQuery.of(context).size.height - 100;

    return OverlayEntry(builder: (context){
      return Positioned(
        left: xPosition,
        top: yPosition + buttonHeight,
        width: width,
        height: height,
        child: Container(
          height: 200,
        //  color: Color(0xffEDEEF2),

          decoration: BoxDecoration(
              color: Color(0xffEDEEF2),
              border: Border.all(
                color: Color(0xffEDEEF2),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),

          child: Column(
            children: <Widget>[
              Spacer(flex:1),
              Material(
                  child: Text("Versenden",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, backgroundColor: Color(0xffEDEEF2), )
                  ),
              ),
              Spacer(),
              SizedBox(width: width/1.5, child: Material(child: DropdownCheckbox(text: "text", itemNames: ["Artikel 1", "Artikel 2"]))),

              SizedBox(height: 15),

              SizedBox(width: width/1.5 ,child: Material(child: CustomDropdown(text: "text", itemNames: ["DHL ", "DPD", "Deutsche Post"]))),

              Spacer(flex:3),


              SizedBox(
                width: width/2,
                height: 30,
                child: FlatButton(
                  height: 30,
                  onPressed: () {
                    setState(() {
                      floatingStatus.remove();
                      overlayOpened = !overlayOpened;
                    });
                  },
                  child: Text(
                    "Als versendet markieren",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  color: Color(0xFF353FB0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              SizedBox(height: 15),

              SizedBox(
                width: width/2,
                height: 30,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      floatingStatus.remove();
                      overlayOpened = !overlayOpened;
                    });
                  },
                  child: Text(
                    "Abbrechen",
                    style: TextStyle(
                      color: Color(0xFF353FB0),
                      fontSize: 12,
                    ),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Spacer(flex:1),
            ],
          ),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0,0,0,0),
      child: FlatButton(
        //key genutzt, um Buttonposition zu finden
        key: actionKey,

        height: 30,
        onPressed: () {
          setState(() {
            if(overlayOpened == false) {
              //finde obere linke Ecke des Buttons & speichere diese in globalen Variablen (in Overlay-Methode genutzt)
              findDropdownData();
              //getPosition of TopElement & assign variable
              floatingStatus = _createFloatingStatus();
              Overlay.of(context).insert(floatingStatus);
            }
            else { floatingStatus.remove(); }

            overlayOpened = !overlayOpened;
          });
        },
        child: Text(
          "Status ändern",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        color: Color(0xFF353FB0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
