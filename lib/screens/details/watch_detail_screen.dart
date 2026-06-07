import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/api_watch_model.dart';
import '../../providers/cart_provider.dart';

class WatchDetailScreen extends StatelessWidget {
  final ApiWatchModel watch;

  const WatchDetailScreen({super.key, required this.watch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // OrientationBuilder listens to device rotation
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildPortraitLayout(context, theme);
        } else {
          return _buildLandscapeLayout(context, theme);
        }
      },
    );
  }

  // PORTRAIT LAYOUT

  Widget _buildPortraitLayout(BuildContext context, ThemeData theme) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildBackButton(context, theme),
      ),
      body: Column(
        children: [
          // Top Half Hero Image
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildHeroImage(),
                // Vertical gradient fading into background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.scaffoldBackgroundColor.withOpacity(0.0),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Half Details
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: theme.scaffoldBackgroundColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: _buildWatchDetails(theme),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
          child: _buildAddToCartButton(context),
        ),
      ),
    );
  }

  // LANDSCAPE LAYOUT (Split Screen Design)

  Widget _buildLandscapeLayout(BuildContext context, ThemeData theme) {
    return Scaffold(
      body: Row(
        children: [
          // Left Half: Hero Image
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildHeroImage(),
                // Horizontal gradient fading into the right half
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  width: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          theme.scaffoldBackgroundColor.withOpacity(0.0),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
                // Safe Area just for the back button so it avoids notches
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: _buildBackButton(context, theme),
                  ),
                ),
              ],
            ),
          ),

          // Right Half: Details and Button
          Expanded(
            flex: 1,
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: SafeArea(
                left: false, // Image handles left safe area
                child: Column(
                  children: [
                    // Scrollable text area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 24.0,
                          top: 24.0,
                        ),
                        child: _buildWatchDetails(theme),
                      ),
                    ),
                    // Sticky button pushed to the bottom of the right side
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        24.0,
                        16.0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildAddToCartButton(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // REUSABLE COMPONENTS

  Widget _buildHeroImage() {
    return Hero(
      tag: 'watch_${watch.id}',
      child:
          watch.image.startsWith('http')
              ? Image.network(
                watch.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
              : Image.asset(watch.image, fit: BoxFit.cover),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.watch, size: 60, color: Colors.grey),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: theme.iconTheme.color,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildWatchDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          watch.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${watch.price}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.amber,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: theme.dividerColor.withOpacity(0.3), thickness: 1),
        const SizedBox(height: 24),
        Text(
          'About this timepiece',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          watch.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            height: 1.7,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CartProvider>().addToCart(watch);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to cart'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text(
        'Add to Cart',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
