import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ecommerce_app/consts/app_constants.dart';
import 'package:simple_ecommerce_app/consts/validator.dart';
import 'package:simple_ecommerce_app/models/product_model.dart';
import 'package:simple_ecommerce_app/services/auth_guard.dart';
import 'package:simple_ecommerce_app/services/my_app_functions.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';
import 'package:uuid/uuid.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class AdminProductsScreen extends StatefulWidget {
  static const routeName = '/AdminProductsScreen';
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<QueryDocumentSnapshot> _filter(List<QueryDocumentSnapshot> docs) {
    final q = _searchCtrl.text.trim().toLowerCase();
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = (data['productTitle'] ?? '').toString().toLowerCase();
      final cat = (data['productCategory'] ?? '').toString();
      final matchCat =
          _selectedCategory == 'All' || cat == _selectedCategory;
      final matchSearch = q.isEmpty || title.contains(q);
      return matchCat && matchSearch;
    }).toList();
  }

  void _showProductForm({DocumentSnapshot? existing}) {
    final titleCtrl = TextEditingController(
        text: existing != null ? (existing['productTitle'] ?? '') : '');
    final priceCtrl = TextEditingController(
        text: existing != null ? (existing['productPrice'] ?? '') : '');
    final descCtrl = TextEditingController(
        text: existing != null ? (existing['productDescription'] ?? '') : '');
    final imageCtrl = TextEditingController(
        text: existing != null ? (existing['productImage'] ?? '') : '');
    final qtyCtrl = TextEditingController(
        text: existing != null ? (existing['productQuantity'] ?? '') : '');
    String selectedCat = existing != null
        ? (existing['productCategory'] ?? AppConstants.categoriesList[0].name)
        : AppConstants.categoriesList[0].name;
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    XFile? pickedImage;

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(children: [
                      Text(
                        existing == null ? 'Add Product' : 'Edit Product',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    // Image preview / picker
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await _pickImage(ctx);
                          if (picked != null) {
                            setModalState(() {
                              pickedImage = picked;
                              imageCtrl.text = ''; // clear URL if picking file
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: pickedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: FutureBuilder<Uint8List>(
                                    future: pickedImage!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      );
                                    },
                                  ),
                                )
                              : imageCtrl.text.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: FancyShimmerImage(
                                        imageUrl: imageCtrl.text,
                                        height: 140,
                                        width: double.infinity,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.add_a_photo_outlined,
                                            size: 36, color: Colors.grey),
                                        SizedBox(height: 6),
                                        Text('Tap to pick image',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // OR: Image URL field
                    TextFormField(
                      controller: imageCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Image URL (optional if image picked)',
                        prefixIcon: Icon(Icons.link, size: 18),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                      ),
                      onChanged: (_) =>
                          setModalState(() => pickedImage = null),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    _Field(
                        ctrl: titleCtrl,
                        label: 'Product Title',
                        validator: (v) => MyValidators.requiredValidator(v,
                            field: 'Title')),
                    // Price
                    _Field(
                        ctrl: priceCtrl,
                        label: 'Price (\$)',
                        keyboardType: TextInputType.number,
                        validator: MyValidators.priceValidator),
                    // Category dropdown
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<String>(
                        value: selectedCat,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          prefixIcon: Icon(Icons.category_outlined, size: 18),
                        ),
                        items: AppConstants.categoriesList
                            .map((c) => DropdownMenuItem(
                                value: c.name, child: Text(c.name)))
                            .toList(),
                        onChanged: (v) =>
                            setModalState(() => selectedCat = v!),
                        validator: (v) =>
                            v == null ? 'Category required' : null,
                      ),
                    ),
                    // Description
                    _Field(
                        ctrl: descCtrl,
                        label: 'Description',
                        maxLines: 4,
                        validator: (v) => MyValidators.requiredValidator(v,
                            field: 'Description')),
                    // Quantity
                    _Field(
                        ctrl: qtyCtrl,
                        label: 'Stock Quantity',
                        keyboardType: TextInputType.number,
                        validator: MyValidators.quantityValidator),

                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                if (pickedImage == null &&
                                    imageCtrl.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please provide an image')),
                                  );
                                  return;
                                }
                                setModalState(() => isLoading = true);
                                try {
                                  String imageUrl = imageCtrl.text.trim();
                                  if (pickedImage != null) {
                                    imageUrl = await _uploadImage(pickedImage!);
                                  }
                                  final data = {
                                    'productTitle': titleCtrl.text.trim(),
                                    'productPrice': priceCtrl.text.trim(),
                                    'productCategory': selectedCat,
                                    'productDescription':
                                        descCtrl.text.trim(),
                                    'productImage': imageUrl,
                                    'productQuantity': qtyCtrl.text.trim(),
                                  };
                                  if (existing == null) {
                                    final id = const Uuid().v4();
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(id)
                                        .set({
                                      ...data,
                                      'productId': id,
                                      'createdAt':
                                          FieldValue.serverTimestamp(),
                                    });
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(existing.id)
                                        .update(data);
                                  }
                                  if (ctx.mounted) Navigator.pop(ctx);
                                } catch (e) {
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                } finally {
                                  setModalState(() => isLoading = false);
                                }
                              },
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : const Icon(Icons.check),
                        label: Text(existing == null
                            ? 'Add Product'
                            : 'Save Changes'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<XFile?> _pickImage(BuildContext ctx) async {
    XFile? file;
    await MyAppFunctions.imagePickerDialog(
      context: ctx,
      cameraFCT: () async {
        file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 75);
      },
      galleryFCT: () async {
        file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 75);
      },
      removeFCT: () {},
    );
    return file;
  }

  Future<String> _uploadImage(XFile image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('productsImages/${const Uuid().v4()}.jpg');
    await ref.putData(
      await image.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await ref.getDownloadURL();
  }

  Future<void> _deleteProduct(String docId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return AdminGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(label: 'Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Add Product',
              onPressed: () => _showProductForm(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {});
                          })
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            // Category chips
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                children: [
                  'All',
                  ...AppConstants.categoriesList.map((c) => c.name)
                ].map((cat) {
                  final sel = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat,
                          style: TextStyle(
                              fontSize: 12,
                              color: sel ? Colors.white : null)),
                      selected: sel,
                      selectedColor: Theme.of(context).primaryColor,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Product list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final all = snap.data?.docs ?? [];
                  final docs = _filter(all);

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('No products found',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final doc = docs[i];
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FancyShimmerImage(
                              imageUrl: data['productImage'] ?? '',
                              height: 56,
                              width: 56,
                            ),
                          ),
                          title: Text(
                            data['productTitle'] ?? '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\$${data['productPrice']}  •  ${data['productCategory']}',
                                  style: const TextStyle(fontSize: 12)),
                              Text('Stock: ${data['productQuantity']}',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(IconlyLight.edit,
                                    color: Colors.blue, size: 20),
                                tooltip: 'Edit',
                                onPressed: () => _showProductForm(existing: doc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red, size: 20),
                                tooltip: 'Delete',
                                onPressed: () {
                                  MyAppFunctions.showErrorOrWarningDialog(
                                    context: context,
                                    subtitle:
                                        'Delete "${data['productTitle']}"?',
                                    fct: () => _deleteProduct(doc.id),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple reusable text field for the form
class _Field extends StatelessWidget {
  const _Field({
    required this.ctrl,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });
  final TextEditingController ctrl;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }
}
