use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlaion::Raw::ChamplainNetworkBboxTileSource;

### /usr/include/champlain-0.12/champlain/champlain-network-bbox-tile-source.h

sub champlain_network_bbox_tile_source_get_api_uri (
  ChamplainNetworkBboxTileSource $map_data_source
)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_network_bbox_tile_source_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_network_bbox_tile_source_load_map_data (
  ChamplainNetworkBboxTileSource $map_data_source,
  ChamplainBoundingBox           $bbox
)
  is native(champlain)
  is export
{ * }

sub champlain_network_bbox_tile_source_new_full (
  Str                    $id,
  Str                    $name,
  Str                    $license,
  Str                    $license_uri,
  guint                  $min_zoom,
  guint                  $max_zoom,
  guint                  $tile_size,
  ChamplainMapProjection $projection,
  ChamplainRenderer      $renderer
)
  returns ChamplainNetworkBboxTileSource
  is native(champlain)
  is export
{ * }

sub champlain_network_bbox_tile_source_set_api_uri (
  ChamplainNetworkBboxTileSource $map_data_source,
  Str                            $api_uri
)
  is native(champlain)
  is export
{ * }

sub champlain_network_bbox_tile_source_set_user_agent (
  ChamplainNetworkBboxTileSource $map_data_source,
  Str                            $user_agent
)
  is native(champlain)
  is export
{ * }
