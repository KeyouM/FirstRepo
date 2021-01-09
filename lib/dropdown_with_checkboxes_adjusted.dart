import 'package:flutter/material.dart';

/*Instanziierung:
  rufe Konstruktor von DropdownCheckbox mit einem String (Identifikator des Dropdown-Buttons) und
  einer Liste von Bezeichnungen (mit jeweils einem Eintrag je Dropdownelement auf)
 */
class DropdownCheckbox extends StatefulWidget {
  //Name des Elements genutzt, um zugehörigen key für relative Positionierung der DD-Elemente zu finden
  final String text;
  final List<String> itemNames;

  const DropdownCheckbox({Key key, @required this.text, @required this.itemNames}) : super(key: key);

  @override
  _DropdownCheckboxState createState() => _DropdownCheckboxState();
}

class _DropdownCheckboxState extends State<DropdownCheckbox> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  //Dropdown-Container abspeichern
  OverlayEntry floatingDropdown;

  int counter = 0;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.text);
    super.initState();
  }

  void numberOfSelectedBoxes(int val){
    setState(() {
      counter = counter + val;
    });
  }

  void findDropdownData(){
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    //Position des zum actionKey gehörenden Elementes (um Padding verschoben)
    xPosition = offset.dx;
    yPosition = offset.dy;

  }

  OverlayEntry _createFloatingDropdown(){
    return OverlayEntry (builder: (context){
      double itemHeights = 35;
      //Anzahl übergebener Listennamen (List of Strings) * Itemhöhe (ebenfalls an Dropdown übergeben)
      double overlayHeight = widget.itemNames.length * itemHeights;
      //fixed height of container by using column or positioned()
      return Positioned(
        left: xPosition,
        width: width,
        //Container unterhalb des stateful contrainers (relativ hierzu)
        top: yPosition + height,
        //Overlayhöhe, itemcount * itemHeight
        height: overlayHeight,
        //eigentlicher Dropdown-Container wird in eigener Klasse erstellt
        child: DropDown(
          //reservierter Platz des Overlay-Containers
          itemHeight: 35,
          itemcount: widget.itemNames.length,
          //clicked box counter function (callback function)
          boxCounter: numberOfSelectedBoxes,
          itemNames: widget.itemNames,
        ),
      );
    });
  }

  //setState() beim Öffnen/Schließen ruft build() => Konditionen erneut geprüft
  String titleSetter(int counter){
    if ( counter == 0 ){
      return "$counter " 'Artikel ausgewählt';
    }
    if ( counter == 1 ){
      return "$counter " 'Artikel ausgewählt';
    }
    if (counter >= 2 ){
      return "$counter " 'Artikel ausgewählt';
    }
    return 'negative number of boxes';
  }

  int colorSetter(){
    if(isDropdownOpened){
      return 0xFFFFFFFF;
    }
    else{
      return 0xFF4C5BFF;
    }
  }


  //eigentlicher Widget-Tree, onTap wird ein Overlay-Entry-Widget gebaut (obere Fkt. aufgerufen und rel. zum Menüitem positioniert)
  @override
  Widget build(BuildContext context) {
    //wird auf die ummantelten Widgets angewandt
    return GestureDetector(
      key: actionKey,
      onTap: (){
        //Anweisung ist ein Methodenaufruf; wird später zu onHover
        setState((){
          //falls Menüpunkt gedrückt wurde, während es offen war: nun schließen
          if(isDropdownOpened){
            floatingDropdown.remove();

          }else{
            //setze #ausgewählter Checkboxen zurück
            counter =0;

            //finde Position des öffnenden Menüelements
            findDropdownData();
            //erschaffe das Dropdown-Menpü
            floatingDropdown = _createFloatingDropdown();
            //füge das Dropdown-Menü ein
            Overlay.of(context).insert(floatingDropdown);
          }
          //nach Klick auf Punktmenü immer ausgeführt
          isDropdownOpened = !isDropdownOpened;
        });
      },
      //Root-Item des Dropdowns (mit GestureDetector umhüllt)
      child: Container(

        height: 35,
        width: 187,
        color: isDropdownOpened ? Color(0xff4C5BFF) : Color(0xff4C5BFF),
        padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
        child: Row(

          children: <Widget>[
            Text( (isDropdownOpened || counter != 0 ) ? titleSetter(counter) : "Artikel auswählen" ,
              style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 14,
                color: (!isDropdownOpened && counter == 0) ? Colors.white : Colors.white,
              ),
            ),
            Spacer(),
            Icon( isDropdownOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: isDropdownOpened ? Colors.white : Colors.white
            ),
          ],
        ),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  final double itemHeight;
  final int itemcount;
  //callback function (forwarded)
  final Function(int) boxCounter;
  final List<String> itemNames;

  //Konstruktor der DropDown-Container Klasse
  const DropDown({Key key, this.itemHeight, @required this.itemcount, this.boxCounter, this.itemNames,}) : super(key: key);

  //eigentlicher Widget-Tree wird erstellt
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Entfernt Unterstriche
        Material(
          child: Container(
            //Zugriff auf Attribut der DropDown-Klasse mit widget.Attr
            //Gesamthöhe des Dropdowns in OverlayEntry
            height:  widget.itemcount * widget.itemHeight,

            //testcolor des Rahmens
            color: Colors.green,

            //eigentliche Items des Dropdown-Containers
            child: Column(
              //Für jeden String der Übergabeliste wird ein Dropdownelement erstellt
              children: widget.itemNames.map(
                //Funktion wird von Map für jeden Listeintrag aufgeführt (Pointer item zeigt auf jeweiligen Eintrag)
                      (item){
                    return DropDownItem(
                      text: item,
                      listItemHeight: widget.itemHeight,
                      checkBoxNumber: i++,
                      boxCounter: widget.boxCounter,
                    );
                  }
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatefulWidget {
  final String text;
  final listItemHeight;
  //can be used when calling business logic
  final int checkBoxNumber;
  final Function(int) boxCounter;

  const DropDownItem({Key key, @required this.text, @required this.checkBoxNumber, @required this.listItemHeight, this.boxCounter,}) : super(key: key);

  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  bool isSelected = false;
  bool checkBoxValue = false;


  @override
  Widget build(BuildContext context) {
    //in dropdown mit checkboxes nicht benutzt
    return GestureDetector(
      onTap: (){
        //Anweisung ist ein Methodenaufruf; wird später zu onHover
        setState((){
          isSelected = !isSelected;
        });
      },

      child: Container(
        //Wenn-Abfrage, für den Fall, das Dropdown-Item ausgewählt wurde
        //color: isSelected ? Color(0xff4C5BFF) : Color(0xff0A0E36),
        color: Color(0xFFFFFFFF),
        height: widget.listItemHeight,
        padding: EdgeInsets.fromLTRB(9, 0, 0, 0),

        //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 12,
              width: 12,
              child: Checkbox(
                checkColor: Color(0xFFFFFFFF),
                activeColor: Color(0xFF353FB0),
                value: checkBoxValue,
                onChanged: (bool value){
                  setState(() {
                    //Business Logik kann aufgerufen werden
                    checkBoxValue=value;
                    value ? widget.boxCounter(1) : widget.boxCounter(-1);
                  });
                },
              ),
            ),
            Spacer(flex: 1),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}