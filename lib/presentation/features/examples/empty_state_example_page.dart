import 'package:flutter/material.dart';
import '../../shared_widgets/enhanced_list_view.dart';
import '../../shared_widgets/empty_state_variations.dart';

/// Example page showing how to use Enhanced ListView with various empty states
class EmptyStateExamplePage extends StatefulWidget {
  const EmptyStateExamplePage({Key? key}) : super(key: key);

  @override
  State<EmptyStateExamplePage> createState() => _EmptyStateExamplePageState();
}

class _EmptyStateExamplePageState extends State<EmptyStateExamplePage> {
  List<String> items = [];
  bool isLoading = false;
  int selectedExample = 0;

  List<Map<String, dynamic>> get examples => [
        {
          'title': 'Basic Empty List',
          'builder': () => _buildBasicEmptyList(),
        },
        {
          'title': 'Search Results',
          'builder': () => _buildSearchResults(),
        },
        {
          'title': 'No Favorites',
          'builder': () => _buildNoFavorites(),
        },
        {
          'title': 'Network Error',
          'builder': () => _buildNetworkError(),
        },
        {
          'title': 'Snap Accounts',
          'builder': () => _buildSnapAccounts(),
        },
        {
          'title': 'Loading State',
          'builder': () => _buildLoadingState(),
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empty State Examples'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshList,
          ),
        ],
      ),
      body: Column(
        children: [
          // Example selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: examples.length,
              itemBuilder: (context, index) {
                final isSelected = selectedExample == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(examples[index]['title']),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedExample = index;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Example content
          Expanded(
            child: examples[selectedExample]['builder'](),
          ),
        ],
      ),
      floatingActionButton: selectedExample == 0
          ? FloatingActionButton(
              onPressed: _addItem,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBasicEmptyList() {
    return EnhancedListView<String>(
      items: items,
      isLoading: isLoading,
      emptyTitle: "No Items Found",
      emptyMessage:
          "You haven't added any items yet. Tap the button below to get started!",
      emptyIcon: Icons.inbox_outlined,
      emptyActionText: "Add First Item",
      onEmptyAction: _addItem,
      itemBuilder: (context, item, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(item),
          subtitle: Text('Item #${index + 1}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeItem(index),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return EmptyStateVariations.noSearchResults(
      searchQuery: "Flutter Tutorial",
      onClearSearch: () {
        // Handle clear search
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search cleared')),
        );
      },
    );
  }

  Widget _buildNoFavorites() {
    return EmptyStateVariations.noFavorites(
      onBrowseItems: () {
        // Handle browse items
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to browse items')),
        );
      },
    );
  }

  Widget _buildNetworkError() {
    return EmptyStateVariations.networkError(
      onRetry: () {
        // Handle retry
        setState(() {
          isLoading = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading = false;
          });
        });
      },
    );
  }

  Widget _buildSnapAccounts() {
    return EmptyStateVariations.noSnapAccounts(
      onConnect: () {
        // Handle connect account
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Snap Auth')),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return EnhancedListView<String>(
      items: const [],
      isLoading: true,
      emptyTitle: "Loading Data",
      emptyMessage: "Please wait while we load your data...",
      emptyIcon: Icons.data_usage_outlined,
      loadingWidget: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
      itemBuilder: (context, item, index) {
        return ListTile(title: Text(item));
      },
    );
  }

  void _addItem() {
    setState(() {
      items.add('Item ${items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _refreshList() {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        // Optionally add some sample data
        if (items.isEmpty && selectedExample == 0) {
          items.addAll(['Sample Item 1', 'Sample Item 2', 'Sample Item 3']);
        }
      });
    });
  }
}
