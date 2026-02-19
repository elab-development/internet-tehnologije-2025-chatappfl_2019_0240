import 'package:chatapp_flutter/widgets/chanel_tile.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_client/chatapp_client.dart';
import '../main.dart'; // Pristup globalnom 'client'
import '../const/colors.dart';
import '../widgets/app_drawer.dart';
import 'chat_screen.dart'; // Napravi prazan fajl ako ga nemaš da ne crveni

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista kanala u kojima ulogovani korisnik učestvuje
  List<Channel>? _channels;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ensureStreamOpen();
    _loadChannels();
  }

  Future<void> _ensureStreamOpen() async {
    try {
      await client.openStreamingConnection();
      debugPrint("📡 HomeScreen: Strim otvoren!");
    } catch (e) {
      debugPrint("ℹ️ HomeScreen: Stream već otvoren ili greška: $e");
    }
  }

  // Funkcija koja povlači kanale direktno preko tvog novog endpointa
  Future<void> _loadChannels() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Poziv ka tvom ChannelEndpoint-u na bekendu
      final channels = await client.channel.getChannels();

      setState(() {
        _channels = channels;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Greška pri učitavanju kanala: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Lasta 493 Chat'),
        backgroundColor: AppColors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChannels,
          ),
        ],
      ),
      drawer: const AppDrawer(), // Tvoj ufuljeni Drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red))
          : RefreshIndicator(
              onRefresh: _loadChannels,
              child: _channels == null || _channels!.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _channels!.length,
                      itemBuilder: (context, index) => ChannelTile(
                        channel: _channels![index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatScreen(channel: _channels![index]),
                          ),
                        ),
                      ),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.red,
        onPressed: _showCreateChannelDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bus_alert, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'Nema aktivnih linija.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          TextButton(
            onPressed: _loadChannels,
            child: const Text(
              'Pokušaj ponovo',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateChannelDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: const Text(
          'Nova Chat Linija',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Ime kanala (npr. Mladenovac-Beograd)',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.red),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Otkaži',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              try {
                // Poziv ka tvom ChannelEndpoint.createChannel
                await client.channel.createChannel(name, 'public');
                if (mounted) {
                  Navigator.pop(context);
                  _loadChannels(); // Odmah osveži listu
                }
              } catch (e) {
                debugPrint('Greška pri kreiranju: $e');
              }
            },
            child: const Text('Kreiraj', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
