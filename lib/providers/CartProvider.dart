import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/config/AppColors.dart';

import '../models/Album.dart';
import 'AlbumProvider.dart';
import 'AuthProvider.dart';
import 'BaseProvider.dart';

class CartProvider extends BaseProvider with BaseMixins {
  List<Album> cart = [];
  String? url;
  Map<String, dynamic>? request;
  String? completed;
  bool showPopMessage = false;

  void addAlbum(Album album) {
    if (!cart.contains(album)) {
      cart.add(album);
      notifyListeners();
    }
  }

  void removeAlbum(Album album) {
    cart.remove(album);
    notifyListeners();
  }

  void clearCart() {
    cart = [];
    notifyListeners();
  }

  /// Vérifie l’état de la facture PayDunya et déclenche l’enregistrement côté serveur si `completed`
  Future<void> getResponse(BuildContext context, String email) async {
    if (request == null || request!['token'] == null) return;

    final confirmUrl =
        'https://app.paydunya.com/sandbox-api/v1/checkout-invoice/confirm/${request!['token']}';

    final response = await http.get(
      Uri.parse(confirmUrl),
      headers: const {
        'Content-Type': 'application/json',
        'PAYDUNYA-MASTER-KEY': 'PbGPDHfX-nCK1-jXjH-2ifY-EDdkAgpWvL8W',
        'PAYDUNYA-PRIVATE-KEY': 'test_private_6HRGpqGOTDFSlOtz4YpBDg4Mf6F',
        'PAYDUNYA-TOKEN': 'eWBnLwkEX8f7XNmEQVo8',
      },
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    completed = body['status']?.toString();
    if (completed == 'completed') {
      await _boughtSuccessful(context, email);
    }
  }

  void albumBought(Album album, AlbumProvider albumProvider) {
    // Assure-toi que l'index est valide
    final idx = albumProvider.allAlbums.indexWhere((a) => a.id == album.id);
    if (idx != -1) {
      albumProvider.allAlbums[idx].isBought = true;
    }
  }

  /// Crée la demande PayDunya (sandbox)
  Future<Map<String, dynamic>> postRequest() async {
    final createUrl = 'https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create';

    String description = '';
    double totalAmount = 0.0;

    for (final album in cart) {
      description = '$description\n${album.name}';
      totalAmount += (album.price ?? 0.0);
    }

    final body = json.encode({
      'invoice': {
        // FCFA approximatif (655) – adapte si besoin
        'total_amount': (totalAmount * 655).toStringAsFixed(2),
        'description': description,
      },
      'store': {'name': 'Senetunes'},
      'actions': {
        'callback_url': 'http://www.magasin-le-choco.com/callback_url.php',
      },
    });

    final response = await http.post(
      Uri.parse(createUrl),
      headers: const {
        'Content-Type': 'application/json',
        'PAYDUNYA-MASTER-KEY': 'PbGPDHfX-nCK1-jXjH-2ifY-EDdkAgpWvL8W',
        'PAYDUNYA-PRIVATE-KEY': 'test_private_6HRGpqGOTDFSlOtz4YpBDg4Mf6F',
        'PAYDUNYA-TOKEN': 'eWBnLwkEX8f7XNmEQVo8',
      },
      body: body,
    );

    request = json.decode(response.body) as Map<String, dynamic>;
    notifyListeners();
    return request!;
  }

  int _boughtOnceGuard = 0;

  Future<void> _boughtSuccessful(BuildContext context, String email) async {
    if (_boughtOnceGuard == 0) _boughtOnceGuard = 1;

    if (_boughtOnceGuard == 1) {
      Fluttertoast.showToast(msg: $t(context, 'album_purchase_success'));
      showPopMessage = true;
      _boughtOnceGuard = -1;
    }

    // Déclare l’achat côté API
    for (final album in cart) {
      final basicAuth = 'Basic ${base64Encode(utf8.encode('X8HFP87CWWGX8WUE6C193HT27PQ3P6QM:'))}';
      final xml = '''<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
  <albums>
    <description><![CDATA[${album.description ?? ''}]]></description>
    <totalPaid>${album.price ?? 0}</totalPaid>
    <payment>paydunya</payment>
    <artistInfo notFilterable="true"><artistId><![CDATA[${album.artistId}]]></artistId></artistInfo>
    <songs><albumId>${album.id}</albumId><albumId>40</albumId></songs>
    <userEmail>$email</userEmail>
  </albums>
</prestashop>''';

      final response = await http.post(
        Uri.parse(
          'http://ec2-35-180-207-66.eu-west-3.compute.amazonaws.com/senetunesproduction/api/order_supplier?schema=blank',
        ),
        headers: <String, String>{
          'authorization': basicAuth,
          'content-type': 'text/xml;charset=utf-8',
        },
        body: xml,
      );

      // debugPrint(response.body);
    }

    request = null;
    clearCart();

    // Rafraîchit les états “achetés”
    final auth = context.read<AuthProvider>();
    final albums = context.read<AlbumProvider>();

    await auth.fetchBoughtAlbums(auth.user!.email);
    await albums.updateBoughtAlbums(auth.boughtAlbumsIds);

    notifyListeners();
  }
}
