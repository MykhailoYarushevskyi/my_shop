import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );
  //for store edited or created properties of the Product()
  var _titleEdited = '';
  var _priceEdited = 0.0;
  var _descriptionEdited = '';
  var _imageUrlEdited = '';
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = context.read<Products>().findById(productId);
        //    or:
        //_editedProduct =
        //    Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toStringAsFixed(2),
          'imageUrl': '',
        };
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    //For avoid memory leaks
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    //if have no focus, updating the image preview with last _imageUrlController.text    if (!_imageUrlFocusNode.hasFocus) {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    // Products products = context.watch<Products>();
    final bool isValid = _formGlobalKey.currentState.validate();
    if (!isValid) return;
    _formGlobalKey.currentState.save();
    _editedProduct = Product(
      id: _editedProduct.id,
      title: _titleEdited,
      price: _priceEdited,
      description: _descriptionEdited,
      imageUrl: _imageUrlEdited,
      isFavorite: _editedProduct.isFavorite,
    );
    if (_editedProduct.id != null) {
      //we can to use here either context.read<Products>() or
      // Provider.of<Products>(context, listen: false)
      context.read<Products>().updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //ignore: deprecated_member_use
        child: Form(
          // autovalidateMode: AutovalidateMode.always,
          key: _formGlobalKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) {
                  _titleEdited = value;
                  //        or
                  // _editedProduct = Product(
                  //     title: value,
                  //     price: _editedProduct.price,
                  //     description: _editedProduct.description,
                  //     imageUrl: _editedProduct.imageUrl,
                  //     id: null);
                },
                validator: (string) {
                  if (string.isEmpty) return 'Please provide a value';
                  return null; //the string is valid
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                onSaved: (value) {
                  _priceEdited = double.parse(value);
                  //       or
                  //   _editedProduct = Product(
                  //       title: _editedProduct.title,
                  //       price: double.parse(value),
                  //       description: _editedProduct.description,
                  //       imageUrl: _editedProduct.imageUrl,
                  //       id: null);
                },
                validator: (string) {
                  if (double.tryParse(string) == null)
                    return 'Please enter a valid number';
                  if (double.tryParse(string) <= 0.0)
                    return 'Please enter a number greater than zero';
                  return null; // the double is valid
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _descriptionEdited = value;
                  //       or
                  // _editedProduct = Product(
                  //     title: _editedProduct.title,
                  //     price: _editedProduct.price,
                  //     description: value,
                  //     imageUrl: _editedProduct.imageUrl,
                  //     id: null);
                },
                validator: (string) {
                  if (string.isEmpty) return 'Please enter a description';
                  if (string.length < 10)
                    return 'Should be at least 10 chracters long';
                  return null; //the string is valid
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      child: _imageUrlController.text.isEmpty
                          ? Center(
                              child: Text(
                                'Input URL',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            )
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // the simultaneously using parameters "initialValue:"" and "controller:"
                      // cause an error: "Failed assertion: line 191 pos 15:
                      // 'initialValue == null || controller == null': is not true."
                      // Therefore we initialise _imageUrlController.text = _editedProduct.imageUrl;
                      //  into the didChangeDependencies().
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocusNode,
                      //we use 'controller' here because we
                      //want to have it before the form is submitted
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        _imageUrlEdited = value;
                        //              or
                        // _editedProduct = Product(
                        //     title: _editedProduct.title,
                        //     price: _editedProduct.price,
                        //     description: _editedProduct.description,
                        //     imageUrl: value,
                        //     id: null);
                      },
                      validator: (string) {
                        if (string.isEmpty) return 'Please enter an image URL.';
                        // print('## string before .trim:$string');
                        // string = string.trim();
                        // print('## string after .trim:$string');
                        if (!string.startsWith('http') &&
                            !string.startsWith('https'))
                          return 'Enter a valid URL.';
                        if (!string.endsWith('.png') &&
                            !string.endsWith('.jpg') &&
                            !string.endsWith('.jpeg'))
                          return 'Please enter a valid image URL.';
                        return null; //the URL is valid
                      },
                    ),
                  ),
                  //        or without the focusNode: _imageUrlFocusNode
                  // (see lecture #222 'Adding an Image Preview'):
                  // Expanded(
                  //   child: TextFormField(
                  //     decoration: InputDecoration(labelText: 'Image URL'),
                  //     keyboardType: TextInputType.url,
                  //     textInputAction: TextInputAction.done,
                  //     controller: _imageUrlController,
                  //     onEditingComplete: () {
                  //       setState(() {});
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
