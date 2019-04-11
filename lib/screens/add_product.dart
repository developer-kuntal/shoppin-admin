import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_admin/db/brand.dart';
import 'package:shop_app_admin/db/category.dart';


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
 
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = new TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory = "test";
  String _currentBrand = "test";

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  @override
  void initState() {
    _getCategories();
    // _getBrands();
    categoriesDropDown = getCategoriesDropDown();
    // _currentCategory = categoriesDropDown[0].value;
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for(DocumentSnapshot category in categories) {
      items.add(new DropdownMenuItem(child: Text(category['category']),
      value: category['category'],));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(Icons.close, color: black,),
        title: Text("add product", style: TextStyle(color: black),),
      ),
      body: Form(
          key: _formKey,
          child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                    borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                    onPressed: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 40.0, 14.0, 40.0),
                      child: new Icon(Icons.add, color: grey,),
                    ),
                    ),
                  ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                    borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                    onPressed: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 40.0, 14.0, 40.0),
                      child: new Icon(Icons.add, color: grey,),
                    ),
                    ),
                  ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                    borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                    onPressed: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 40.0, 14.0, 40.0),
                      child: new Icon(Icons.add, color: grey,),
                    ),
                    ),
                  ),
              ),
            ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Enter a product name within 10 charecters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: red, fontSize: 12.0),),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Product name"
                ),
                validator: (value) {
                  if(value.isEmpty) {
                    return "You must enter the product name";
                  } else if(value.length > 10) {
                    return "Product name can't have more than 10 letters";
                  }
                },
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(categories[index]['category']),
                  );
                },
              ),
            )
            // Center(
            //   child: DropdownButton(
            //     value: _currentCategory,
            //     items: categoriesDropDown,
            //     onChanged: changeSelectedCategory,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
     categories = data; 
     print(data.length);
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }
}