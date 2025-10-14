#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
collect_sources.py
Parcourt un projet Flutter et agrège dans un unique .txt le contenu des fichiers
explicitement listés par l'utilisateur (config/build + lib/).

Usage:
  python collect_sources.py
  python collect_sources.py --root "C:/Projets/senetunes" --out "build_sources.txt"
"""

import argparse
import sys
import os
from pathlib import Path
from datetime import datetime
import glob
from typing import List, Tuple, Optional

# -------- Utils

def read_text_best_effort(p: Path) -> Optional[str]:
    """Lit un fichier texte en UTF-8, fallback latin-1 si nécessaire."""
    try:
        return p.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        try:
            return p.read_text(encoding="latin-1")
        except Exception:
            return None
    except Exception:
        return None

def find_first_existing(root: Path, candidates: List[Path]) -> Optional[Path]:
    """Retourne le premier chemin existant parmi les candidats."""
    for c in candidates:
        full = (root / c).resolve()
        if full.exists():
            return full
    return None

def find_all_existing(root: Path, patterns: List[str]) -> List[Path]:
    """Retourne tous les chemins existants pour des patterns glob relatifs au root."""
    found: List[Path] = []
    for pat in patterns:
        for match in glob.glob(str(root / pat), recursive=True):
            p = Path(match)
            if p.exists() and p.is_file():
                found.append(p.resolve())
    return found

def header_for(path: Path) -> str:
    return f"\n\n===== BEGIN FILE: {path} =====\n"

def footer_for(path: Path) -> str:
    return f"\n===== END FILE: {path} =====\n"

# -------- Listes fournies par l'utilisateur

CONFIG_BUILD_VARIANTS: List[List[Path]] = [
    # pubspec.yaml
    [Path("pubspec.yaml")],
    # analysis_options.yaml (si présent)
    [Path("analysis_options.yaml")],
    # android/gradle.properties
    [Path("android/gradle.properties")],
    # settings.gradle(.kts)
    [Path("android/settings.gradle.kts"), Path("android/settings.gradle")],
    # build.gradle(.kts) racine android
    [Path("android/build.gradle.kts"), Path("android/build.gradle")],
    # app/build.gradle(.kts)
    [Path("android/app/build.gradle.kts"), Path("android/app/build.gradle")],
    # gradle wrapper props
    [Path("android/gradle/wrapper/gradle-wrapper.properties")],
    # AndroidManifest
    [Path("android/app/src/main/AndroidManifest.xml")],
]
# MainActivity (kt ou java) -> via glob
MAIN_ACTIVITY_PATTERNS = [
    "android/app/src/main/kotlin/**/MainActivity.kt",
    "android/app/src/main/java/**/MainActivity.java",
]
# (Optionnel) iOS
IOS_PODFILE = [Path("ios/Podfile")]

# Tous les fichiers lib/ demandés
LIB_FILES = [
    # main
    Path("lib/main.dart"),
    # Screens
    Path("lib/screens/exploreScreen.dart"),
    Path("lib/screens/PlayerScreen.dart"),
    Path("lib/screens/downloadPlayerScreen.dart"),
    Path("lib/screens/album/AlbumDetailScreen.dart"),
    Path("lib/screens/album/AlbumsScreen.dart"),
    Path("lib/screens/album/SearchScreen.dart"),
    Path("lib/screens/Artist/ArtistDetailScreen.dart"),
    Path("lib/screens/Artist/ArtistsScreen.dart"),
    Path("lib/screens/Category/CategoryDetailScreen.dart"),
    Path("lib/screens/Category/CategoryScreen.dart"),
    Path("lib/screens/Download/DownloadScreen.dart"),
    Path("lib/screens/Download/DownloadDetailsScreen.dart"),
    Path("lib/screens/Favourites/FavouritesScreen.dart"),
    Path("lib/screens/Favourites/MyFavouritesScreen.dart"),
    Path("lib/screens/Bought Albums/BoughtAlbumsScreen.dart"),
    Path("lib/screens/Bought Albums/BoughtAlbumsDetailsScreen.dart"),
    Path("lib/screens/Cart/Cart.dart"),
    Path("lib/screens/Auth/WelcomeScreen.dart"),
    Path("lib/screens/Auth/ConfirmationScreen.dart"),
    Path("lib/screens/Auth/LoginScreen.dart"),
    Path("lib/screens/Auth/RegisterScreen.dart"),
    Path("lib/screens/Auth/UserAccountPage.dart"),
    Path("lib/screens/WebView/WebView.dart"),
    # Widgets
    Path("lib/widgtes/track/TrackCarousel/TrackCarouselWidget.dart"),
    Path("lib/widgtes/Track/TrackTile.dart"),
    Path("lib/widgtes/Track/TrackBottomBar.dart"),
    Path("lib/widgtes/Track/TrackPlayButton.dart"),
    Path("lib/widgtes/track/TrackFavouriteButton.dart"),
    Path("lib/widgtes/Album/AlbumsWidget.dart"),
    Path("lib/widgtes/Album/AlbumTile.dart"),
    Path("lib/widgtes/Album/AlbumTileActions.dart"),
    Path("lib/widgtes/Artist/ArtistCardForScreen.dart"),
    Path("lib/widgtes/Artist/TrackTileForArtist.dart"),
    Path("lib/widgtes/Artist/AlbumsList.dart"),
    Path("lib/widgtes/Artist/ArtistCarousel/ArtistWidget.dart"),
    Path("lib/widgtes/Category/CategoryWidget.dart"),
    Path("lib/widgtes/Category/CategoryTile.dart"),
    Path("lib/widgtes/Common/BaseAppBar.dart"),
    Path("lib/widgtes/Common/BaseConnectivity.dart"),
    Path("lib/widgtes/Common/BaseAuthCheck.dart"),
    Path("lib/widgtes/Common/BaseDrawer.dart"),
    Path("lib/widgtes/Common/BaseScreenHeading.dart"),
    Path("lib/widgtes/Common/BaseBlocButton.dart"),
    Path("lib/widgtes/Common/OutlineBorderButton.dart"),
    Path("lib/widgtes/Common/DownloadButton.dart"),
    Path("lib/widgtes/Common/PopOverWidget.dart"),
    Path("lib/widgtes/Common/BasicAppBar.dart"),
    Path("lib/widgtes/Common/WidgetHeader.dart"),
    Path("lib/widgtes/ImagePreview.dart"),
    Path("lib/widgtes/PositionSeekWidget.dart"),
    Path("lib/widgtes/Search/SearchBox.dart"),
    Path("lib/widgtes/Playlist/PlaylistChoice.dart"),
    Path("lib/widgtes/Playlist/PlaylistCard.dart"),
    # Providers / Logic
    Path("lib/providers/AuthProvider.dart"),
    Path("lib/providers/AlbumProvider.dart"),
    Path("lib/providers/ArtistProvider.dart"),
    Path("lib/providers/CategoryProvider.dart"),
    Path("lib/providers/PlayerProvider.dart"),
    Path("lib/providers/PlaylistProvider.dart"),
    Path("lib/providers/CartProvider.dart"),
    Path("lib/providers/DownloadProvider.dart"),
    Path("lib/providers/DownloadLogic.dart"),
    Path("lib/providers/UsersProvider.dart"),
    Path("lib/providers/FavoriteProvider.dart"),
    # Modèles / Config / Utils
    Path("lib/models/Album.dart"),
    Path("lib/models/Artist.dart"),
    Path("lib/models/Track.dart"),
    Path("lib/models/Media.dart"),
    Path("lib/models/User.dart"),
    Path("lib/models/Category.dart"),
    Path("lib/models/DownloadTaskInfo.dart"),
    Path("lib/config/AppTheme.dart"),
    Path("lib/config/AppColors.dart"),
    Path("lib/config/AppRoutes.dart"),
    Path("lib/config/Applocalizations.dart"),
    Path("lib/config/AppValidation_rules.dart"),
    Path("lib/mixins/BaseMixins.dart"),
]

def main():
    parser = argparse.ArgumentParser(description="Collecte de fichiers source Flutter dans un unique .txt")
    parser.add_argument("--root", type=str, default=".", help="Racine du projet (par défaut: dossier courant).")
    parser.add_argument("--out", type=str, default="", help="Nom du fichier de sortie (txt).")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    if not root.exists():
        print(f"[ERREUR] Le dossier racine n'existe pas: {root}", file=sys.stderr)
        sys.exit(1)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_name = args.out if args.out else f"collected_source_{timestamp}.txt"
    out_path = (root / out_name).resolve()

    missing: List[str] = []
    written_files: List[Path] = []

    print(f"[i] Racine projet: {root}")
    print(f"[i] Fichier de sortie: {out_path.name}")

    with out_path.open("w", encoding="utf-8") as out:
        out.write(f"# Source bundle généré le {datetime.now().isoformat()}\n")
        out.write(f"# Racine: {root}\n")

        # 1) Config / Build (avec variantes)
        out.write("\n\n########## SECTION: CONFIG / BUILD ##########\n")
        for variants in CONFIG_BUILD_VARIANTS:
            found = find_first_existing(root, variants)
            if found:
                content = read_text_best_effort(found)
                if content is None:
                    missing.append(f"{found} (lecture impossible)")
                else:
                    out.write(header_for(found))
                    out.write(content)
                    out.write(footer_for(found))
                    written_files.append(found)
            else:
                missing.append(" / ".join([str((root / v).resolve()) for v in variants]))

        # MainActivity via glob (on inclut tous ceux trouvés)
        activity_files = find_all_existing(root, MAIN_ACTIVITY_PATTERNS)
        if activity_files:
            for f in activity_files:
                content = read_text_best_effort(f)
                if content is None:
                    missing.append(f"{f} (lecture impossible)")
                else:
                    out.write(header_for(f))
                    out.write(content)
                    out.write(footer_for(f))
                    written_files.append(f)
        else:
            missing.append("MainActivity.kt|java non trouvé (patterns glob)")

        # iOS Podfile (optionnel)
        for p in IOS_PODFILE:
            full = (root / p).resolve()
            if full.exists():
                content = read_text_best_effort(full)
                if content is None:
                    missing.append(f"{full} (lecture impossible)")
                else:
                    out.write(header_for(full))
                    out.write(content)
                    out.write(footer_for(full))
                    written_files.append(full)
            else:
                # pas bloquant, optionnel: on n’ajoute pas aux manquants
                pass

        # 2) lib/ fichiers explicitement listés
        out.write("\n\n########## SECTION: LIB ##########\n")
        for rel in LIB_FILES:
            full = (root / rel).resolve()
            if full.exists():
                content = read_text_best_effort(full)
                if content is None:
                    missing.append(f"{full} (lecture impossible)")
                else:
                    out.write(header_for(full))
                    out.write(content)
                    out.write(footer_for(full))
                    written_files.append(full)
            else:
                missing.append(str(full))

        # Récapitulatif
        out.write("\n\n########## RÉCAP ##########\n")
        out.write(f"Fichiers collectés: {len(written_files)}\n")
        for f in written_files:
            out.write(f" - {f}\n")

        if missing:
            out.write("\nFichiers manquants ou illisibles:\n")
            for m in missing:
                out.write(f" - {m}\n")
        else:
            out.write("\nAucun fichier manquant 🎉\n")

    print(f"[✓] Terminé. Fichiers collectés: {len(written_files)}")
    if missing:
        print(f"[!] Manquants/illisibles: {len(missing)} (voir la section 'RÉCAP' dans {out_path.name})")
    print(f"[→] Sortie : {out_path}")

if __name__ == "__main__":
    main()
