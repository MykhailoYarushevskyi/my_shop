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
  var _isLoading = false;
  var _isFormChanged = false;
  var _isEditMode = false;

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
        _isEditMode =
            true; //Using for a reaction about an attempt to exit from the form without a submitting of changes
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

  Future<void> _saveForm() async {
    // Products products = context.watch<Products>();
    final bool isValid = _formGlobalKey.currentState.validate();
    if (!isValid) return;
    _formGlobalKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    _editedProduct = Product(
      id: _editedProduct.id,
      title: _titleEdited,
      price: _priceEdited,
      description: _descriptionEdited,
      imageUrl: _imageUrlEdited,
      isFavorite: _editedProduct.isFavorite,
    );
    if (_editedProduct.id != null) {
      // Update Product
      try {
        //we can to use here either context.read<Products>() or
        // Provider.of<Products>(context, listen: false)
        await context.read<Products>().updateProduct(
              _editedProduct.id,
              _editedProduct,
            );
      } catch (error) {
        print(
            '## EditProductScreen (update product) catch block Error:\n## $error');
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
            title: Text(
              'An Error occured!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 20,
              ),
            ),
            content: Text('Something go wrong.'),
          ),
        );
      }
    } else {
      // Add Product
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        print('## EditProductScreen (addProduct) catch(error) block');
        print('## EditProductScreen error: ${error.toString()}');
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
            title: Text(
              'An Error occured!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 20,
              ),
            ),
            content: Text('Something go wrong.'),
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  /// Callback that enables the form to veto attempts by the user
  /// to dismiss the [ModalRoute] that contains the form.
  Future<bool> _onFormWillPop() async {
    print(
        '## EditProductScreen _onFormWillPop() _isFormChanged: $_isFormChanged');
    if (!_isFormChanged) {
      return Future<bool>.value(true);
    }
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Do you want to exit?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              content: _isEditMode
                  ? Text(
                      'If you will exit before submitting this form, you lose all changes that were made in the form!')
                  : Text(
                      'If you will exit before submitting this form, you lose all content of the form!'),
              actions: [
                FlatButton(
                  color: Colors.red,
                  onPressed: () => Navigator.of(context).pop<bool>(false),
                  child: Text('Cancel'),
                ),
                RaisedButton(
                  onPressed: () => Navigator.of(context).pop<bool>(true),
                  child: Text('Yes'),
                ),
              ],
            ));
    // return Future<bool>.value(true);
  }

  /// Called when one of the form fields changes.
  void _onFormChange() {
    if (_isFormChanged)
      return; //prevents Flutter from re-rendering all tree when Form was changed
    setState(() {
      _isFormChanged = true;
    });
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
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          //ignore: deprecated_member_use
          child: Form(
            // autovalidateMode: AutovalidateMode.always,
            key: _formGlobalKey,
            onChanged: _onFormChange,
            onWillPop: _onFormWillPop,
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
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
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
                          if (string.isEmpty)
                            return 'Please enter an image URL.';
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
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ]),
    );
  }
}
