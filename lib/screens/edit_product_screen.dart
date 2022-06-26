import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: '', title: '', price: 0, description: '', imageUrl: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInitialized = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      var routeArguments = ModalRoute.of(context)?.settings.arguments;
      final productId = routeArguments == null ? null : routeArguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_priceFocusNode),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value ?? '',
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.description,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                        validator: (value) {
                          String? validationMessage;
                          if (value == null || value.isEmpty) {
                            validationMessage = 'Please enter a price';
                          } else if (double.tryParse(value) == null) {
                            validationMessage = 'Please enter a valid number';
                          } else if (double.parse(value) <= 0) {
                            validationMessage = 'Please enter a positive number';
                          }
                          return validationMessage;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.description,
                            price: value == null ? 0 : double.parse(value),
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          String? validationMessage;
                          if (value == null || value.isEmpty) {
                            validationMessage = 'Please enter a description';
                          } else if (value.length < 10) {
                            validationMessage = 'Should be at least 10 characters long';
                          }
                          return validationMessage;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value ?? '',
                            imageUrl: _editedProduct.description,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Image.network(_imageUrlController.text),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                String? validationMessage;
                                if (value == null || value.isEmpty) {
                                  validationMessage = 'Please enter an image URL';
                                } else if (!value.startsWith('http') || !value.startsWith('https')) {
                                  validationMessage = 'Please enter a valid URL';
                                } else if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                                  validationMessage = 'Please enter a valid image URL';
                                }
                                return validationMessage;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value ?? '',
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      var value = _imageUrlController.value.text;
      if (value.isEmpty || ((value.startsWith('http') || value.startsWith('https')) && (value.endsWith('.png') || value.endsWith('.jpg') || value.endsWith('.jpeg')))) {
        setState(() {});
      }
    }
  }

  Future<void> _saveForm() async {
    var formState = _form.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      setState(() => _isLoading = true);
      final products = Provider.of<ProductsProvider>(context, listen: false);
      try {
        if (_editedProduct.id.isEmpty) {
          await products.addProduct(_editedProduct);
        } else {
          await products.updateProduct(_editedProduct);
        }
      } catch(error) {
        await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occurred'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Ok'),
                ),
              ],
            ));
      } finally {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
      }
    }
  }
}
