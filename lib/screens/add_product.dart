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
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Product name"
                ),
                style: TextStyle(fontSize: 10.0),
                validator: (value) {
                  if(value.isEmpty) {
                    return "You must enter the product name";
                  } else if(value.length > 10) {
                    return "Product name can't have more than 10 letters";
                  }
                },
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
                // Checkbox(value: selectedSizes.contains('XS'), onChanged: changeSelectedSize,),
                Checkbox(value: false, onChanged: null,),
                Text('XS', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('S', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('M', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('L', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('XL', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('XXL', style: TextStyle(fontSize: 8.0),),
              ],
            ),

            Row(
              children: <Widget>[
                Checkbox(value: false, onChanged: null,),
                Text('28', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('30', style: TextStyle(fontSize: 8.0),),
                
                Checkbox(value: false, onChanged: null,),
                Text('32', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('34', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
                Text('36', style: TextStyle(fontSize: 8.0),),

                Checkbox(value: false, onChanged: null,),
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

            
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TypeAheadField(
            //     textFieldConfiguration: TextFieldConfiguration(
            //       autofocus: false,
            //       decoration: InputDecoration(
            //         hintText: 'add category',
            //       )
            //     ),

            //     suggestionsCallback: (pattern) async {
            //       return await _categoryService.getSuggestions(pattern);
            //     },

            //     itemBuilder: (context, suggestion) {
            //       return ListTile(
            //         leading: Icon(Icons.category),
            //         title: Text(suggestion['category']),
            //       );
            //     },

            //     onSuggestionSelected: (suggestion) {
            //       setState(() {
            //         _currentCategory = suggestion['category']; 
            //       });
            //     }

            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TypeAheadField(
            //     textFieldConfiguration: TextFieldConfiguration(
            //       autofocus: false,
            //       decoration: InputDecoration(
            //         hintText: 'add brand',
            //         // border: OutlineInputBorder()
            //       )
            //     ),

            //     suggestionsCallback: (pattern) async {
            //       return await _brandService.getSuggestions(pattern);
            //     },

            //     itemBuilder: (context, suggestion) {
            //       return ListTile(
            //         leading: Icon(Icons.category),
            //         title: Text(suggestion['brand']),
            //       );
            //     },

            //     onSuggestionSelected: (suggestion) {
            //       setState(() {
            //         _currentBrand = suggestion['brands']; 
            //       });
            //     }

            //   ),
            // ),

          ],
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

  // void changeSelectedSize(bool size) {
  //   if(selectedSizes.contains(size)) {
  //     selectedSizes.remove(size);
  //   } else {
  //     selectedSizes.add(size);
  //   }
  // }
}