import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/AddressScreen';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final List<_Address> _addresses = [
    _Address(
      name: 'John Doe',
      phone: '+1 (555) 123-4567',
      street: '123 Apple Street, Apt 4B',
      city: 'San Francisco',
      state: 'CA',
      country: 'United States',
      zip: '94102',
      isDefault: true,
    ),
  ];

  int _defaultIdx = 0;

  void _showAddressForm({_Address? existing, int? index}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final streetCtrl = TextEditingController(text: existing?.street ?? '');
    final cityCtrl = TextEditingController(text: existing?.city ?? '');
    final stateCtrl = TextEditingController(text: existing?.state ?? '');
    final countryCtrl = TextEditingController(text: existing?.country ?? '');
    final zipCtrl = TextEditingController(text: existing?.zip ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        existing == null ? 'Add Address' : 'Edit Address',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _AddressField(controller: nameCtrl, label: 'Full Name', icon: Icons.person_outline),
                  _AddressField(controller: phoneCtrl, label: 'Phone Number', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                  _AddressField(controller: streetCtrl, label: 'Street Address', icon: Icons.home_outlined),
                  _AddressField(controller: cityCtrl, label: 'City', icon: Icons.location_city_outlined),
                  Row(
                    children: [
                      Expanded(
                        child: _AddressField(controller: stateCtrl, label: 'State', icon: Icons.map_outlined),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _AddressField(controller: zipCtrl, label: 'ZIP Code', icon: Icons.pin_outlined, keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  _AddressField(controller: countryCtrl, label: 'Country', icon: Icons.flag_outlined),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        final newAddr = _Address(
                          name: nameCtrl.text,
                          phone: phoneCtrl.text,
                          street: streetCtrl.text,
                          city: cityCtrl.text,
                          state: stateCtrl.text,
                          country: countryCtrl.text,
                          zip: zipCtrl.text,
                          isDefault: false,
                        );
                        setState(() {
                          if (index != null) {
                            _addresses[index] = newAddr;
                          } else {
                            _addresses.add(newAddr);
                          }
                        });
                        Navigator.pop(ctx);
                      },
                      icon: const Icon(Icons.check),
                      label: Text(existing == null ? 'Add Address' : 'Save Changes'),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'My Addresses'),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddressForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('No addresses saved',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddressForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final addr = _addresses[index];
                final isDefault = index == _defaultIdx;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isDefault
                          ? theme.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(IconlyLight.location,
                                color: isDefault
                                    ? theme.primaryColor
                                    : Colors.grey,
                                size: 20),
                            const SizedBox(width: 6),
                            Text(
                              addr.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(width: 8),
                            if (isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      theme.primaryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Default',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            PopupMenuButton<String>(
                              onSelected: (val) {
                                if (val == 'edit') {
                                  _showAddressForm(
                                      existing: addr, index: index);
                                } else if (val == 'default') {
                                  setState(() => _defaultIdx = index);
                                } else if (val == 'delete') {
                                  setState(() {
                                    _addresses.removeAt(index);
                                    if (_defaultIdx >= _addresses.length) {
                                      _defaultIdx = 0;
                                    }
                                  });
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                    value: 'edit', child: Text('Edit')),
                                if (!isDefault)
                                  const PopupMenuItem(
                                      value: 'default',
                                      child: Text('Set as default')),
                                const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete',
                                        style:
                                            TextStyle(color: Colors.red))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(addr.street,
                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        Text(
                            '${addr.city}, ${addr.state} ${addr.zip}',
                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        Text(addr.country,
                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(addr.phone,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Address {
  final String name, phone, street, city, state, country, zip;
  final bool isDefault;

  const _Address({
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zip,
    required this.isDefault,
  });
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        ),
        validator: (v) =>
            v == null || v.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
