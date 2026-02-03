import 'package:simple_ecommerce_app/models/categories_model.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';

class AppConstants {
  static const String imageUrl =
      'https://static.sweetcare.com/img/prd/488/v-638233397601801515/mac-015735zy_09.webp';

   static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Phones",
      image: AssetsManager.mobiles,
      name: "Phones",
    ),
    CategoriesModel(
      id: "Laptops",
      image: AssetsManager.pc,
      name: "Laptops",
    ),
    CategoriesModel(
      id: "Electronics",
      image: AssetsManager.electronics,
      name: "Electronics",
    ),
    CategoriesModel(
      id: "Watches",
      image: AssetsManager.watch,
      name: "Watches",
    ),
    CategoriesModel(
      id: "Clothes",
      image: AssetsManager.fashion,
      name: "Clothes",
    ),
    CategoriesModel(
      id: "Shoes",
      image: AssetsManager.shoes,
      name: "Shoes",
    ),
    CategoriesModel(
      id: "Books",
      image: AssetsManager.book,
      name: "Books",
    ),
    CategoriesModel(
      id: "Cosmetics",
      image: AssetsManager.cosmetics,
      name: "Cosmetics",
    ),
  ];
}