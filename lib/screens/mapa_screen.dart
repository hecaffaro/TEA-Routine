import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? _mapController;
  LatLng? _posicaoAtual;
  final Set<Marker> _marcadores = {};

  @override
  void initState() {
    super.initState();
    _obterLocalizacao();
  }

  Future<void> _obterLocalizacao() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      final posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _posicaoAtual = LatLng(posicao.latitude, posicao.longitude);
        _adicionarMarcadores();
      });

      // Move a câmera para a posição atual, se o controlador já estiver disponível
      if (_mapController != null && _posicaoAtual != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_posicaoAtual!, 16),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de localização negada')),
      );
    }
  }

  void _adicionarMarcadores() {
    if (_posicaoAtual == null) return;

    _marcadores.clear();

    // Marcador da localização atual
    _marcadores.add(
      Marker(
        markerId: const MarkerId('atual'),
        position: _posicaoAtual!,
        infoWindow: const InfoWindow(title: 'Você está aqui'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Pontos mockados do projeto Smart HAS
    _marcadores.addAll([
      Marker(
        markerId: const MarkerId('ponto1'),
        position: LatLng(_posicaoAtual!.latitude + 0.001, _posicaoAtual!.longitude + 0.001),
        infoWindow: const InfoWindow(title: 'Posto de saúde'),
      ),
      Marker(
        markerId: const MarkerId('ponto2'),
        position: LatLng(_posicaoAtual!.latitude - 0.001, _posicaoAtual!.longitude - 0.001),
        infoWindow: const InfoWindow(title: 'Centro de apoio TEA'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa - Smart HAS')),
      body: _posicaoAtual == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;

                // Caso a localização já tenha sido obtida, centraliza o mapa nela
                if (_posicaoAtual != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(_posicaoAtual!, 16),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: _posicaoAtual!,
                zoom: 16,
              ),
              myLocationEnabled: true,
              markers: _marcadores,
            ),
    );
  }
}
