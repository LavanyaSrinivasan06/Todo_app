import 'package:flutter/material.dart';
import 'package:todo_app/dbhelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtxt = "";
  String todoedited = "";
  var myitems = [];

  Future<List<String>> fetchDummyData() async {
  await Future.delayed(Duration(seconds: 2)); // Simulate a network delay.
  return ["Dummy Task 1", "Dummy Task 2"]; // Return some dummy data.
}


  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
  }

  Widget mycard(String task) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        child: ListTile(
          title: Text("$task"),
          onLongPress: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
  builder: (context, snap) {
    if (!snap.hasData) {
      return Center(
        child: Text("Loading..."),  // or "No Data", or any loading indicator you prefer.
      );
    } else {
      if (myitems.length == 0) {
        return Scaffold(
          appBar: AppBar(
            title: Text("To-DO List"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text("Add tasks"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (_val) {
                              todoedited = _val;
                            },
                            decoration: InputDecoration(
                              errorText: validated ? null : errtxt,
                            ),
                            controller: texteditingcontroller,
                            autofocus: true,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (texteditingcontroller.text.isEmpty) {
                                    setState(() {
                                      errtxt = "Can't be empty";
                                      validated = false;
                                    });
                                  } else if (texteditingcontroller.text.length > 512) {
                                    setState(() {
                                      errtxt = "Too many characters";
                                      validated = false;
                                    });
                                  } else {
                                    addtodo();
                                  }
                                },
                                child: Text("ADD"),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  });
                },
              );
            },
            child: Icon(Icons.add),
          ),
          body: Center(
            child: Text("No tasks available"),
          ),
        );
      } else {
        // Handle the case where myitems has data.
        // Example:
        return ListView.builder(
          itemCount: myitems.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(myitems[index]));
          },
        );
      }
    }
  },
  future: fetchDummyData(),  // You need to replace 'yourFutureFunction()' with the actual function that returns the Future.
);

  }
}



/*Scaffold(
      appBar: AppBar(
        title: Text("To-DO List"),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState){
          return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Add tasks"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // This is important!
            children: [
              TextField(
                onChanged: (_val){
                  todoedited = _val;
                },
                decoration: InputDecoration(
                  errorText: validated ? null : errtxt,
                ),
                controller: texteditingcontroller,
                autofocus: true,
              ),
              
              Padding(padding: EdgeInsets.only(top: 10),),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle your logic here
                      //Navigator.of(context).pop(); // Close the AlertDialog
                      if(texteditingcontroller.text.isEmpty){
                        setState(() {
                          errtxt = "Can't be empty";
                          validated = false;
                        });
                      }
                      else if(texteditingcontroller.text.length > 512){
                        setState(() {
                          errtxt = "Too many characters";
                          validated = false;
                        });
                      }
                      else{
                        addtodo();
                      }
                    },
                    child: Text("ADD"),
                  ),
                ],
              )
            ],
          ),
        );
        });
      },
    );
  },
  child: Icon(Icons.add),
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            mycard("Create a todo app"),
            mycard("Finish assingnments"),
          ],
        ),
      ),
    );*/