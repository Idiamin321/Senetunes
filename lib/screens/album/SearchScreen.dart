import 'package:flutter/material.dart';
import 'package:flutter_rekord_app/mixins/BaseMixins.dart';
import 'package:flutter_rekord_app/models/Track.dart';
import 'package:flutter_rekord_app/providers/AlbumProvider.dart';
import 'package:flutter_rekord_app/widgtes/Search/BaseMessageScreen.dart';
import 'package:flutter_rekord_app/widgtes/Search/SearchBox.dart';
import 'package:flutter_rekord_app/widgtes/common/CustomCircularProgressIndicator.dart';
import 'package:flutter_rekord_app/widgtes/track/TrackTile.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with BaseMixins {
  String searchKeyword = "";
  List<Track> searchedTracks = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider = Provider.of<AlbumProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SearchBox(
                onSearch: (s) {
                  setState(() {
                    searchKeyword = s;
                  });
                  if (s.length > 0) {
                    searchedTracks = albumProvider.searchData(s);
                  }
                },
              ),
              Expanded(
                flex: 2,
                child: albumProvider.isLoaded
                    ? searchedTracks.length == 0
                        ? BaseMessageScreen(
                            title: searchKeyword == null || searchKeyword.isEmpty
                                ? $t(context, 'search_screen_title')
                                : $t(context, 'search_screen_title_not_found'),
                            subtitle: $t(context, 'search_screen_subtitle'),
                            icon: Icons.search,
                          )
                        : ListView.builder(
                            itemCount: searchedTracks.length,
                            itemBuilder: (context, index) {
                              return TrackTile(
                                track: searchedTracks[index],
                                index: index,
                                album: searchedTracks[index].albumInfo,
                              );
                            })
                    : CustomCircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
