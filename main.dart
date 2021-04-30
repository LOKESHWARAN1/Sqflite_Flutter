import 'package:flutter/material.dart';
import 'Database/database_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  final Emp database_manager = new Emp();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  EmpDetails empDetails;
  List<EmpDetails> emplist;
  int updateIndex;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Demo'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                    validator: (val) =>
                        val.isNotEmpty ? null : 'Name should not be empty',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _emailController,
                    validator: (val) =>
                        val.isNotEmpty ? null : 'email should not be empty',
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      child: Container(
                          width: width * 0.9,
                          child: Text(
                            'Submit',
                            textAlign: TextAlign.center,
                          )),
                      onPressed: () {
                        _submitEmpDtails(context);
                      }),
                  FutureBuilder(
                      future: database_manager.getEmpDetailsList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          emplist = snapshot.data;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: emplist == null ? 0 : emplist.length,
                              itemBuilder: (BuildContext context, int index) {
                                EmpDetails st = emplist[index];
                                return Container(
                                  height: 80,
                                  child: Card(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          width: width * 0.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Name:${st.name}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                'Email:${st.email}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blueAccent,
                                            ),
                                            onPressed: () {
                                              _nameController.text = st.name;
                                              _emailController.text = st.email;
                                              empDetails = st;
                                              updateIndex = index;
                                            }),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              database_manager
                                                  .deleteEmpDetails(st.id);
                                              setState(() {
                                                emplist.removeAt(index);
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        return CircularProgressIndicator();
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitEmpDtails(BuildContext context) {
    if (_formkey.currentState.validate()) {
      if (empDetails == null) {
        // ignore: missing_required_param
        EmpDetails st = EmpDetails(
            name: _nameController.text, email: _emailController.text);
        database_manager.insertEmpDetails(st).then((id) => {
              _nameController.clear(),
              _emailController.clear(),
              // ignore: unnecessary_brace_in_string_interps
              print('EmpDetails Added to Db ${id}')
            });
      } else {
        empDetails.name = _nameController.text;
        empDetails.email = _emailController.text;
        database_manager.updateEmpDetails(empDetails).then((id) => {
              setState(() {
                emplist[updateIndex].name = _nameController.text;
                emplist[updateIndex].email = _emailController.text;
              }),
              _nameController.clear(),
              _emailController.clear(),
              empDetails = null
            });
      }
    }
  }
}
