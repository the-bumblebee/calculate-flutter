import 'package:flutter/material.dart';
import 'package:calculate/calculator.dart';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Calculate'),
          backgroundColor: Colors.blueGrey.shade900,
        ),
        body: CalcPage(),
      ),
    ),
  );
}

class CalcPage extends StatefulWidget {
  @override
  _CalcPageState createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {

  num result = 0;
  Interpreter interpreter;
  bool isEvaluated = false;
  TextEditingController controller = TextEditingController();
  
  Row buildButtonRow({List<String> labels = const ['eg1', 'eg2', 'eg3']}) {
    List<Widget> list = List();
    for (int i = 0; i < labels.length; i++) {
      list.add(SizedBox(width: 2.0));
      if (labels[i] == 'space') {
        list.add(Expanded(
          child: SizedBox.expand(),
        ));
      }
      else if (labels[i] == 'C') {
        list.add(Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                controller.text = controller.text.substring(0, controller.text.length - 1);
              });
            },
            onLongPress: () {
              setState(() {
                controller.text = '';
              });
            },
            color: Colors.blueGrey.shade600,
            textColor: Colors.white,
            child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 20.0,
                )
            ),
          ),
        ));
      }
      else if (labels[i] == '=') {
        list.add(Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                interpreter = Interpreter(controller.text);
                result = interpreter.expr();
                controller.text = result.toString();
                isEvaluated = true;
              });
            },
            color: Colors.blueGrey.shade600,
            textColor: Colors.white,
            child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 20.0,
                )
            ),
          ),
        ));
      }
      else if (labels[i] == 'Ans') {
        list.add(Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                if (isEvaluated) {
                  controller.text = result.toString();
                  isEvaluated = false;
                }
                else
                  controller.text = controller.text + result.toString();
              });
            },
            color: Colors.blueGrey.shade600,
            textColor: Colors.white,
            child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 20.0,
                )
            ),
          ),
        ));
      }
      else {
        list.add(Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                if (isEvaluated) {
                  controller.text = labels[i];
                  isEvaluated = false;
                }
                else
                  controller.text = controller.text + labels[i];
              });
            },
            color: Colors.blueGrey.shade600,
            textColor: Colors.white,
            child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 20.0,
                )
            ),
          ),
        ));
      }
      list.add(SizedBox(width: 2.0));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: list,
    );
  }
  
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SizedBox.expand(
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  showCursor: true,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 100.0,
                    color: Colors.cyan,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: buildButtonRow(labels: ['7', '8', '9', '+', 'C'])
            ),
            SizedBox(height: 4.0,),
            Expanded(
              child: buildButtonRow(labels: ['4', '5', '6', '-', 'space'])
            ),
            SizedBox(height: 4.0,),
            Expanded(
              child: buildButtonRow(labels: ['1', '2', '3', '*', 'Ans']),
            ),
            SizedBox(height: 4.0),
            Expanded(
              child: buildButtonRow(labels: ['(', '0', ')', '/', '=']),
            ),
            SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}