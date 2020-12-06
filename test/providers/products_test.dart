import 'package:test/test.dart';

import 'package:my_shop/providers/products.dart';
import 'package:my_shop/providers/product.dart';

void main() {
  group('App Provider/Products Tests.', () {
    int initialQuantityProduct = 4;
    int maxNumberAdded = 3;
    int maxNumberUpdated = 3;

    test('A item(s) should be added', () {
      var products = Products();
      expect(products.items.length == initialQuantityProduct, true);
      for (int number = 0; number < maxNumberAdded; number++) {
        var product = Product(
          id: null,
          title: 'item_$number',
          description: 'description of the item_$number',
          price: 10.05,
          imageUrl: 'https//:image_holder/item_$number.jpg',
          isFavorite: true,
        );
        expect(
          products.items.any((item) {
            return item.title == product.title &&
                item.description == product.description &&
                item.price == product.price &&
                item.imageUrl == product.imageUrl &&
                item.isFavorite == product.isFavorite;
          }),
          false,
        );
        products.addProduct(product);
        expect(
          products.items.any((item) =>
              item.title == product.title &&
              item.description == product.description &&
              item.price == product.price &&
              item.imageUrl == product.imageUrl &&
              item.isFavorite == product.isFavorite),
          true,
        );
      }
      expect(products.items.length == initialQuantityProduct + maxNumberAdded,
          true);
    });
    test('the item(s) should be updated', () {
      var products = Products();
      var newProduct;
      var addedProduct;
      expect(products.items.length == initialQuantityProduct, true);
      for (int number = 0; number < maxNumberUpdated; number++) {
        var product = Product(
          id: null,
          title: 'item_$number',
          description: 'description of the item_$number',
          price: 10.05,
          imageUrl: 'https//:image_holder/item_$number.jpg',
          isFavorite: true,
        );
        expect(
          products.items.any((item) {
            return item.title == product.title &&
                item.description == product.description &&
                item.price == product.price &&
                item.imageUrl == product.imageUrl &&
                item.isFavorite == product.isFavorite;
          }),
          false,
        );
        products.addProduct(product);
        //added product with made id
        addedProduct = products.items.firstWhere((item) {
          return item.title == product.title &&
              item.description == product.description &&
              item.price == product.price &&
              item.imageUrl == product.imageUrl &&
              item.isFavorite == product.isFavorite;
        });
        //check the appear message Error 'updateProduct' because id is null
        var nullIdProduct = Product(
          id: product.id, //null
          title: product.title + '_updated',
          description: product.description + '_updated',
          price: product.price + 100.00,
          imageUrl:
              product.imageUrl.replaceFirst(new RegExp(r':'), ':_updated'),
          isFavorite: !product.isFavorite,
        );
        products.updateProduct(product.id, nullIdProduct);
        //test with made id
        newProduct = Product(
          id: addedProduct.id, // real made id
          title: addedProduct.title + '_updated',
          description: addedProduct.description + '_updated',
          price: addedProduct.price + 100.00,
          imageUrl:
              addedProduct.imageUrl.replaceFirst(new RegExp(r':'), ':_updated'),
          isFavorite: !addedProduct.isFavorite,
        );
        products.updateProduct(addedProduct.id, newProduct);
        expect(
            products.items.any((item) =>
                item.id == newProduct.id &&
                item.title == newProduct.title &&
                item.description == newProduct.description &&
                item.price == newProduct.price &&
                item.imageUrl == newProduct.imageUrl &&
                item.isFavorite == newProduct.isFavorite),
            true);
        //check whether it is possible to damage the Product in Products
        //from the outside after the update
        bool updatedProductIsFavorite = newProduct.isFavorite;
        //try to damage the Product in Products
        print(
            '##[test] before damage newProduct.isFavorite = ${newProduct.isFavorite}');
        newProduct.isFavorite = !newProduct.isFavorite;
        print(
            '##[test] damaged newProduct.isFavorite = ${newProduct.isFavorite}');
        var possibleDamagedProduct =
            products.items.firstWhere((prod) => prod.id == newProduct.id);
        print(
            '##[test] possibleDamagedProduct.isFavorite = ${possibleDamagedProduct.isFavorite}');

        //if true, the updated Product in Products was not damaged
        expect(
          possibleDamagedProduct.isFavorite == updatedProductIsFavorite,
          true,
        );
      }
      expect(products.items.length == initialQuantityProduct + maxNumberAdded,
          true);
    });
  });
}
