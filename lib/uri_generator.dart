
import 'global_constants.dart';

class UriGenerator {

  static const productsCollectionPath = '/products';
  static const ordersCollectionPath = '/orders';

  static Uri buildProductsCollectionUri({String? token}) {
    return Uri.https(GlobalConstants.authority, '$productsCollectionPath${GlobalConstants.dotJson}', UriGenerator.buildAuthQueryParameters(token));
  }

  static Uri buildProductIdUri({required String id, String? token}) {
    return Uri.https(GlobalConstants.authority, '$productsCollectionPath/$id/${GlobalConstants.dotJson}', UriGenerator.buildAuthQueryParameters(token));
  }

  static Uri buildOrdersCollectionUri(String? token) => Uri.https(GlobalConstants.authority, '$ordersCollectionPath${GlobalConstants.dotJson}', buildAuthQueryParameters(token));

  static Map<String, String> buildAuthQueryParameters(String? token) => token == null ? {} : {'auth': token};
}
