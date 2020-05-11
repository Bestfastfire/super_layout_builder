import 'package:flutter/material.dart';
import 'package:super_layout_builder/super_layout_builder.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  int built = 0;

  Widget customDrawer(){
    return Flexible(
      flex: 1,
      child: Container(
        color: Colors.blue[800],
        child: ListView(
          children: [
            Material(
              color: Colors.blueAccent,
              child: ListTile(
                leading: Icon(Icons.home),
                selected: true,
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: (){},
              )
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    built++;
    return SuperLayoutBuilder(
      triggerWidth: [
        850
      ],
      triggerHeight: [
        500
      ],
      builder: (c, m) => Scaffold(
        drawer: m.size.width <= 850 ?
        customDrawer() : null,
        appBar:AppBar(
          elevation: 0,
          title: Text('Home'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  m.size.width <= 850 ? Container() :
                  customDrawer(),
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: Text('Times built: $built', style: TextStyle(
                        fontSize: 32
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}