import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../providers/work_provider.dart';
import '../providers/driver_provider.dart';
import '../providers/auth_provider.dart';
import '../services/localization_service.dart';
import '../database/database.dart';
import 'farmer_profile_screen.dart';
import 'add_farmer_screen.dart';
import '../utils/color_utils.dart';

class FarmerListScreen extends StatefulWidget {
  const FarmerListScreen({super.key});

  @override
  State<FarmerListScreen> createState() => _FarmerListScreenState();
}

class _FarmerListScreenState extends State<FarmerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FarmerProvider>(context, listen: false).loadFarmers();
        Provider.of<WorkProvider>(context, listen: false).loadAllFarmerPendingAmounts();
        
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.user != null) {
          Provider.of<DriverProvider>(context, listen: false).syncWithGoogle(authProvider.user);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocusNode.requestFocus();
      } else {
        _searchFocusNode.unfocus();
        _searchController.clear();
        Provider.of<FarmerProvider>(context, listen: false).searchFarmers('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background
      appBar: AppBar(
        title: Text(locale.translate('farmer_list.title')),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close_rounded : Icons.search_rounded),
            onPressed: _toggleSearch,
            tooltip: _isSearchVisible ? locale.translate('common.cancel') : locale.translate('common.search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Animated Search Bar (Slides from Right to Left)
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSearchVisible ? MediaQuery.of(context).size.width : 0.0,
              height: _isSearchVisible ? 80.0 : 0.0,
              curve: Curves.easeOutCubic,
              child: _isSearchVisible ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: locale.translate('farmer_list.search_hint'),
                        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            Provider.of<FarmerProvider>(context, listen: false).searchFarmers('');
                            setState(() {});
                          },
                        ) : null,
                      ),
                      onChanged: (value) {
                        Provider.of<FarmerProvider>(context, listen: false).searchFarmers(value);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ) : null,
            ),
          ),
          Expanded(
            child: Consumer2<FarmerProvider, WorkProvider>(
              builder: (context, farmerProvider, workProvider, child) {
                if (farmerProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (farmerProvider.farmers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          locale.translate('farmer_list.no_farmers'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100, top: 12),
                  itemCount: farmerProvider.farmers.length,
                  cacheExtent: 1000, // Preload more items for smooth scrolling
                  // Prototype item helps Flutter estimate scroll extent efficiently
                  prototypeItem: _FarmerListItem(
                    farmer: Farmer(id: 0, name: 'Prototype Name', phone: '9876543210', createdAt: DateTime.now(), updatedAt: DateTime.now()),
                    pendingAmount: 5000.0,
                    locale: locale,
                  ),
                  itemBuilder: (context, index) {
                    final farmer = farmerProvider.farmers[index];
                    final pendingAmount = workProvider.allFarmerPendingAmounts[farmer.id] ?? 0.0;
                    
                    return _FarmerListItem(
                      farmer: farmer,
                      pendingAmount: pendingAmount,
                      locale: locale,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddFarmerScreen(isBottomSheet: true),
          );
        },
        label: Text(locale.translate('farmer_list.add_farmer'), style: const TextStyle(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _FarmerListItem extends StatelessWidget {
  final Farmer farmer;
  final double pendingAmount;
  final AppLocalizations locale;

  const _FarmerListItem({
    required this.farmer,
    required this.pendingAmount,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FarmerProfileScreen(farmerId: farmer.id),
            ),
          ).then((_) {
            if (context.mounted) {
              Provider.of<WorkProvider>(context, listen: false).loadAllFarmerPendingAmounts();
            }
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: ColorUtils.getAvatarColor(farmer.name).withOpacity(0.35),
                child: Text(
                  farmer.name.isNotEmpty ? farmer.name[0].toUpperCase() : '?',
                  style: TextStyle(color: ColorUtils.getAvatarColor(farmer.name), fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmer.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (farmer.phone != null && farmer.phone!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(farmer.phone!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${pendingAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: pendingAmount > 0 ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    locale.translate('farmer_list.pending_amount'),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
