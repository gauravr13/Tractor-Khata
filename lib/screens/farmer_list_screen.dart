import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../providers/work_provider.dart';
import '../services/localization_service.dart';
import 'farmer_profile_screen.dart';
import '../database/database.dart'; // Needed for Farmer type
import '../providers/auth_provider.dart';
import '../providers/driver_provider.dart';
import '../widgets/staggered_list_item.dart';
import 'add_farmer_screen.dart';

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
      Provider.of<FarmerProvider>(context, listen: false).loadFarmers();
      Provider.of<WorkProvider>(context, listen: false).loadAllFarmerPendingAmounts();
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<DriverProvider>(context, listen: false).syncWithGoogle(authProvider.user);
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
      appBar: AppBar(
        title: Text(locale.translate('farmer_list.title')),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _isSearchVisible ? locale.translate('common.cancel') : locale.translate('common.search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
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
              height: _isSearchVisible ? 70.0 : 0.0,
              curve: Curves.easeOutCubic,
              child: _isSearchVisible ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: locale.translate('farmer_list.search_hint'),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
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
                    child: Text(
                      locale.translate('farmer_list.no_farmers'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80, top: 8),
                  itemCount: farmerProvider.farmers.length,
                  cacheExtent: 1000, // Preload more items for smooth scrolling
                  itemBuilder: (context, index) {
                    final farmer = farmerProvider.farmers[index];
                    final pendingAmount = workProvider.allFarmerPendingAmounts[farmer.id] ?? 0.0;
                    
                    return StaggeredListItem(
                      index: index,
                      child: _FarmerListItem(
                        farmer: farmer,
                        pendingAmount: pendingAmount,
                        locale: locale,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AddFarmerScreen(isBottomSheet: true),
            );
          },
          label: Text(locale.translate('farmer_list.add_farmer')),
          icon: const Icon(Icons.add),
        ),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0, // Flat design for better performance
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Hero(
                tag: 'avatar_${farmer.id}',
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.green.shade50,
                  child: Text(
                    farmer.name.isNotEmpty ? farmer.name[0].toUpperCase() : '?',
                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmer.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (farmer.phone != null && farmer.phone!.isNotEmpty)
                      Text(farmer.phone!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${pendingAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: pendingAmount > 0 ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                  Text(
                    locale.translate('farmer_list.pending_amount'),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
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
