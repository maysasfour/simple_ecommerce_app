import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_ecommerce_app/services/auth_guard.dart';
import 'package:simple_ecommerce_app/services/my_app_functions.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class AdminUsersScreen extends StatefulWidget {
  static const routeName = '/AdminUsersScreen';
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<int> _orderCount(String userId) async {
    final snap = await FirebaseFirestore.instance
        .collection('ordersAdvanced')
        .where('userId', isEqualTo: userId)
        .get();
    return snap.docs.length;
  }

  Future<void> _toggleAdmin(String userId, bool currentIsAdmin) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'isAdmin': !currentIsAdmin});
  }

  @override
  Widget build(BuildContext context) {
    return AdminGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(label: 'User Management'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by name or email...',
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
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final allDocs = snap.data?.docs ?? [];
                  final q = _searchCtrl.text.trim().toLowerCase();
                  final docs = q.isEmpty
                      ? allDocs
                      : allDocs.where((d) {
                          final data = d.data() as Map<String, dynamic>;
                          final name = (data['userName'] ?? '').toString().toLowerCase();
                          final email = (data['userEmail'] ?? '').toString().toLowerCase();
                          return name.contains(q) || email.contains(q);
                        }).toList();

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('No users found',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final doc = docs[i];
                      final data = doc.data() as Map<String, dynamic>;
                      final isAdmin = data['isAdmin'] as bool? ?? false;
                      final userId = data['userId'] as String? ?? doc.id;
                      final imageUrl = data['userImage'] as String? ?? '';
                      final createdAt =
                          (data['createdAt'] as Timestamp?)?.toDate();
                      final dateStr = createdAt != null
                          ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
                          : '—';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : null,
                                child: imageUrl.isEmpty
                                    ? const Icon(Icons.person,
                                        color: Colors.grey, size: 28)
                                    : null,
                              ),
                              const SizedBox(width: 12),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          data['userName'] ?? '—',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      if (isAdmin)
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.amber.withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text('Admin',
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                        ),
                                    ]),
                                    Text(
                                      data['userEmail'] ?? '—',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    Text('Joined: $dateStr',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11)),
                                    FutureBuilder<int>(
                                      future: _orderCount(userId),
                                      builder: (ctx, orderSnap) {
                                        final count =
                                            orderSnap.data ?? 0;
                                        return Text(
                                          '$count orders',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Actions
                              PopupMenuButton<String>(
                                onSelected: (val) async {
                                  if (val == 'toggle_admin') {
                                    await MyAppFunctions
                                        .showErrorOrWarningDialog(
                                      context: context,
                                      isError: false,
                                      subtitle: isAdmin
                                          ? 'Revoke admin from ${data['userName']}?'
                                          : 'Make ${data['userName']} an admin?',
                                      fct: () =>
                                          _toggleAdmin(doc.id, isAdmin),
                                    );
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 'toggle_admin',
                                    child: Row(children: [
                                      Icon(
                                        isAdmin
                                            ? Icons.remove_moderator_outlined
                                            : Icons.admin_panel_settings_outlined,
                                        size: 18,
                                        color: isAdmin
                                            ? Colors.red
                                            : Colors.amber,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(isAdmin
                                          ? 'Revoke Admin'
                                          : 'Make Admin'),
                                    ]),
                                  ),
                                ],
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
