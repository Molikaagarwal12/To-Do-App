import 'package:flutter/material.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widgets/todo_items.dart';

class Home extends StatefulWidget {
   Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList=ToDo.todoList();
   final _todoController=TextEditingController();
   List<ToDo> _foundToDo=[];
  @override
  void initState(){
    _foundToDo=todosList;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: _BuildAppBar(),
      body: Stack(
        children: [Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              searchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin:EdgeInsets.only(top: 50,bottom: 20),
                      child: Text("All ToDos",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                    ),
                    for (ToDo todoo in _foundToDo.reversed)
                    ToDoItem(todo:todoo,
                    OnToDoChanged: _handleToDoChange,
                    OnDeleteItem: _deleteToDoItem,
                    ),
                  ],
                ),
              )
            ],
          )
        ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 20,right: 20,left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0,0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    hintText: "Add A New ToDo Item",
                    border: InputBorder.none,),
                ),
              ),
            ),
                Container(
                  margin: EdgeInsets.only(bottom: 20,right: 20),
                  child: ElevatedButton(onPressed: () { _addToDoItem(_todoController.text); },
                  child: Text('+',style: TextStyle(fontSize: 40),),
                    style: ElevatedButton.styleFrom(primary: tdBlue,minimumSize: Size(60, 60),
                    elevation: 10),
                  ),
                )
                ]),
          )
      ]
      ),
    );
  }
 void _handleToDoChange(ToDo todo){
    setState(() {
      todo.isDone=!todo.isDone;
    });
 }
  void _deleteToDoItem(String id){
    setState(() {
     todosList.removeWhere((item) => item.id==id);

    });
  }
  void _addToDoItem(String toDo){
    setState(() {
      todosList.add(ToDo(id: DateTime.now().microsecondsSinceEpoch.toString(), todoText: toDo));
    });
    _todoController.clear();
  }
  void _runFilter(String enteredKeyword){
    List<ToDo> results=[];
    if(enteredKeyword.isEmpty){
      results=todosList;
    }else{
     results= todosList.where((item) =>item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      _foundToDo=results;
    });
  }
  Widget searchBox(){
   return  Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        onChanged: (value)=>_runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20,minHeight: 15),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: tdGrey)
        ),
      ),
    );
  }

  AppBar _BuildAppBar(){
    return AppBar(
      backgroundColor: tdBgColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu,color: tdBlack,size: 30,),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network("https://i.pinimg.com/originals/c6/4c/e0/c64ce05bf01ccb3ea8af44de5980cbe4.jpg"),),
          )
        ],
      ),
    );
  }
}
