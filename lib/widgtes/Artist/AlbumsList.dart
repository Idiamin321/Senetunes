import 'package:flutter/material.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Album.dart';
import 'package:senetunes/widgtes/Album/AlbumFavouriteButton.dart';
import 'package:senetunes/widgtes/Album/AlbumTileActions.dart';
import 'package:senetunes/widgtes/Common/BaseImage.dart';
import 'package:senetunes/widgtes/Search/BaseMessageScreen.dart';

class AlbumsList extends StatelessWidget with BaseMixins {
  final List<Album> albums;
  const AlbumsList({
    Key key,
    @required this.albums,
  }) : super(key: key);

  _buildTile(BuildContext context, Album album) => Column(children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.albumDetail,
              arguments: album,
            );
          },
          title: Text(
            album.name,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: Text(
            '${album.tracks.length} sons',
            style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
          ),
          leading: BaseImage(
            heroId: album.id,
            imageUrl: album.media.thumbnail,
            height: 40,
            width: 40,
            radius: 5.0,
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AlbumFavouriteButton(
                album: album,
              ),
              TrackTileActions(
                route: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.albumDetail,
                    arguments: album,
                  );
                },
                title: 'Écouter les sons',
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).cardColor,
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: albums != null && albums.length > 0
                ? ListView.builder(
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      return _buildTile(context, albums[index]);
                    },
                  )
                : BaseMessageScreen(
                    title: $t(context, 'no_albums'),
                    icon: Icons.data_usage,
                    subtitle: $t(context, 'msg_no_albums'),
                  ),
          ),
        ),
      ],
    );
  }
}
