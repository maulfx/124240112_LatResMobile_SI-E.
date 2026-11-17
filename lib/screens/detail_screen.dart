import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/space_item.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final SpaceItem item;
  final String endpoint;

  const DetailScreen({
    super.key,
    required this.item,
    required this.endpoint,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late SpaceItem _item;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _checkFavoriteStatus();
    _loadDetailFromApi();
  }

  Future<void> _checkFavoriteStatus() async {
    final fav = await FavoriteService.isFavorite(_item.id);
    if (mounted) {
      setState(() {
        _isFavorite = fav;
      });
    }
  }

  Future<void> _loadDetailFromApi() async {
    try {
      final detail = await ApiService.getItemDetail(widget.endpoint, _item.id);
      if (mounted) {
        setState(() {
          _item = detail;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    final added = await FavoriteService.toggleFavorite(_item);
    if (mounted) {
      setState(() {
        _isFavorite = added;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added ? 'Ditambahkan ke favorite' : 'Dihapus dari favorite',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _launchOfficialSite(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka URL berita')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: const Color(0xFF5B67CA),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            tooltip: 'Tambah / Hapus Favorite',
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8E5F7),
        foregroundColor: const Color(0xFF5B67CA),
        tooltip: 'Buka Web',
        onPressed: () => _launchOfficialSite(_item.url),
        child: const Icon(Icons.open_in_new),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_item.imageUrl.isNotEmpty)
              Image.network(
                _item.imageUrl,
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 230,
                  width: double.infinity,
                  color: const Color(0xFFE8E5F7),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 230,
                width: double.infinity,
                color: const Color(0xFFE8E5F7),
                child: const Center(
                  child: Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _item.newsSite,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _item.publishedAt,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 28),
                  Text(
                    _item.summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
