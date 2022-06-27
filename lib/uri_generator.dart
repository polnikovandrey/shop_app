import 'global_constants.dart';

class UriGenerator {
  static const productsCollectionPath = '/products';
  static const ordersCollectionPath = '/orders';
  static const userFavoritesPath = '/userFavorites';

  static Uri buildProductsCollectionUri({String? token}) => buildProductsCollectionFilteredByUserIdUri(token: token);

  static Uri buildProductsCollectionFilteredByUserIdUri({String? token, String? userId}) {
    var queryParameters = UriGenerator.buildAuthQueryParameters(token);
    queryParameters.addAll(userId == null
        ? {}
        : {
            'orderBy': '"creatorId"',
            'equalTo': '"$userId"',
          });
    return Uri.https(GlobalConstants.authority, '$productsCollectionPath${GlobalConstants.dotJson}', queryParameters);
  }

  static Uri buildProductIdUri({required String id, String? token}) =>
      Uri.https(GlobalConstants.authority, '$productsCollectionPath/$id/${GlobalConstants.dotJson}', UriGenerator.buildAuthQueryParameters(token));

  static Uri buildOrdersCollectionUri(String? token) => Uri.https(GlobalConstants.authority, '$ordersCollectionPath${GlobalConstants.dotJson}', buildAuthQueryParameters(token));

  static Uri buildUserFavoritesUserIdProductIdUri({required String? userId, required String productId, String? token}) =>
      Uri.https(GlobalConstants.authority, '$userFavoritesPath/$userId/$productId/${GlobalConstants.dotJson}', UriGenerator.buildAuthQueryParameters(token));

  static Uri buildUserFavoritesUserIdUri({required String? userId, String? token}) =>
      Uri.https(GlobalConstants.authority, '$userFavoritesPath/$userId/${GlobalConstants.dotJson}', UriGenerator.buildAuthQueryParameters(token));

  static Map<String, String> buildAuthQueryParameters(String? token) => token == null ? {} : {'auth': token};
}
