use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::TileSource;

### /usr/include/champlain-0.12/champlain/champlain-tile-source.h

sub champlain_tile_source_get_cache (ChamplainTileSource $tile_source)
  returns ChamplainTileCache
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_cache (
  ChamplainTileSource $tile_source,
  ChamplainTileCache $cache
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_id (ChamplainTileSource $tile_source, Str $id)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_license (
  ChamplainTileSource $tile_source,
  Str                 $license
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_license_uri (
  ChamplainTileSource $tile_source,
  Str                 $license_uri
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_max_zoom_level (
  ChamplainTileSource $tile_source,
  guint               $zoom_level
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_min_zoom_level (
  ChamplainTileSource $tile_source,
  guint               $zoom_level
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_name (
  ChamplainTileSource $tile_source,
  Str                 $name
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_projection (
  ChamplainTileSource    $tile_source,
  ChamplainMapProjection $projection
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_source_set_tile_size (
  ChamplainTileSource $tile_source,
  guint               $tile_size
)
  is native(champlain)
  is export
{ * }
