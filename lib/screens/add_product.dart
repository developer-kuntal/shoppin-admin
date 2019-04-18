import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_admin/db/brand.dart';
import 'package:shop_app_admin/db/category.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  String _currentCategory;
  String _currentBrand;

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];

  @override
  void initState() {
    _getCategories();
    _getBrands();
    // _currentCategory = categoriesDropDown[0].value;
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for(int i = 0; i < categories.length; i++) {
      // items.add(new DropdownMenuItem(child: Text(category['category']),
      // value: category['category'],));
      setState(() {
          items.insert(0, DropdownMenuItem(child: Text(categories[i].data['category']),
            value: categories[i].data['category'],
          ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for(int i = 0; i < brands.length; i++) {
      // items.add(new DropdownMenuItem(child: Text(category['category']),
      // value: category['category'],));
      setState(() {
          items.insert(0, DropdownMenuItem(child: Text(brands[i].data['brand']),
            value: brands[i].data['brand'],
          ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(Icons.close, color: black, ),
        title: Text("add product", style: TextStyle(color: black),),
        
      ),
      body: new Container(
          child: Form(
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
                          padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
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
                          padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
                          child: new Icon(Icons.add, color: grey, ),
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
                          padding: const EdgeInsets.fromLTRB(14.0, 70.0, 14.0, 70.0),
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
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.apps),
                                hintText: 'Product name',
                              ),
                              validator: (value) {
                                if(value.isEmpty) {
                                  return "You must enter the product name";
                                } else if(value.length > 10) {
                                  return "Product name can't have more than 10 letters";
                                }
                              },
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                            ),
                          )

                      ],
                    ),
                  ),
              ),
              
              // select category
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Category: ', style: TextStyle(color: red, fontSize: 10.0)),
                  ),
                  DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                    value: _currentCategory,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Brand: ', style: TextStyle(color: red, fontSize: 10.0)),
                  ),
                  DropdownButton(
                    items: brandsDropDown,
                    onChanged: changeSelectedBrand,
                    value: _currentBrand,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ],
              ),

              // select brand
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    hintText: "Quantity"
                  ),
                  style: TextStyle(fontSize: 10.0),
                  validator: (value) {
                    if(value.isEmpty) {
                      return "You must enter the product quantity";
                    }
                  },
                ),
              ),

              Text('Available Sizes: ', style: TextStyle(fontSize: 10.0),),

              Row(
                children: <Widget>[
                  Checkbox(value: selectedSizes.contains('XS'), 
                            onChanged: (value) => changeSelectedSize('XS'),),
                  Text('XS', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('S'), 
                            onChanged: (value) => changeSelectedSize('S'),),
                  Text('S', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('M'), 
                            onChanged: (value) => changeSelectedSize('M'),),
                  Text('M', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('L'), 
                            onChanged: (value) => changeSelectedSize('L'),),
                  Text('L', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('XL'), 
                            onChanged: (value) => changeSelectedSize('XL'),),
                  Text('XL', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('XXL'), 
                            onChanged: (value) => changeSelectedSize('XXL'),),
                  Text('XXL', style: TextStyle(fontSize: 8.0),),
                ],
              ),

              Row(
                children: <Widget>[
                  Checkbox(value: selectedSizes.contains('28'), 
                            onChanged: (value) => changeSelectedSize('28'),),
                  Text('28', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('30'), 
                            onChanged: (value) => changeSelectedSize('30'),),
                  Text('30', style: TextStyle(fontSize: 8.0),),
                  
                  Checkbox(value: selectedSizes.contains('32'), 
                            onChanged: (value) => changeSelectedSize('32'),),
                  Text('32', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('34'), 
                            onChanged: (value) => changeSelectedSize('34'),),
                  Text('34', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('36'), 
                            onChanged: (value) => changeSelectedSize('36'),),
                  Text('36', style: TextStyle(fontSize: 8.0),),

                  Checkbox(value: selectedSizes.contains('38'), 
                            onChanged: (value) => changeSelectedSize('38'),),
                  Text('38', style: TextStyle(fontSize: 8.0),),

                ],
              ),

              // Row(
              //   children: <Widget>[
              //     Checkbox(value: false, onChanged: null,),
              //     Text('40', style: TextStyle(fontSize: 8.0),),

              //     Checkbox(value: false, onChanged: null,),
              //     Text('42', style: TextStyle(fontSize: 8.0),),

              //     Checkbox(value: false, onChanged: null,),
              //     Text('44', style: TextStyle(fontSize: 8.0),),

              //     Checkbox(value: false, onChanged: null,),
              //     Text('46', style: TextStyle(fontSize: 8.0),),

              //     Checkbox(value: false, onChanged: null,),
              //     Text('48', style: TextStyle(fontSize: 8.0),),

              //     Checkbox(value: false, onChanged: null,),
              //     Text('50', style: TextStyle(fontSize: 8.0),),
              //   ],
              // ),

              FlatButton(
                color: red,
                textColor: white,
                child: Text("add product"),
                onPressed: () {

                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
      print(data.length);
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBtands();
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0].data['brand'];
      print(data.length);
    });
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  void changeSelectedSize(String size) {
    if(selectedSizes.contains(size)) {
      setState(() { 
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.add(size);
      });
    }
  }
}