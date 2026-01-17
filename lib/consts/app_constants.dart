import 'package:simple_ecommerce_app/models/categories_model.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';

class AppConstants {
  static const String imageUrl =
      'https://static.sweetcare.com/img/prd/488/v-638233397601801515/mac-015735zy_09.webp';

  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Phones",
      image: AssetsManager.mobiles,
    ),
    CategoriesModel(
      id: AssetsManager.pc,
      name: "Laptops",
      image: AssetsManager.pc,
    ),
    CategoriesModel(
      id: AssetsManager.electronics,
      name: "Electronics",
      image: AssetsManager.electronics,
    ),
    CategoriesModel(
      id: AssetsManager.watch,
      name: "Watches",
      image: AssetsManager.watch,
    ),
    CategoriesModel(
      id: AssetsManager.fashion,
      name: "Clothes",
      image: AssetsManager.fashion,
    ),
    CategoriesModel(
      id: AssetsManager.shoes,
      name: "Shoes",
      image: AssetsManager.shoes,
    ),
    CategoriesModel(
      id: AssetsManager.book,
      name: "Books",
      image: AssetsManager.book,
    ),
    CategoriesModel(
      id: AssetsManager.cosmetics,
      name: "Cosmetics",
      image: AssetsManager.cosmetics,
    ),
  ];
}
