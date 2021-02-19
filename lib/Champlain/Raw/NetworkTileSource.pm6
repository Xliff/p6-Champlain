use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::NetworklTileSource;

### /usr/include/champlain-0.12/champlain/champlain-network-tile-source.h

sub champlain_network_tile_source_get_max_conns (
  ChamplainNetworkTileSource $tile_source
)
  returns gint
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_get_offline (
  ChamplainNetworkTileSource $tile_source
)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_get_proxy_uri (
  ChamplainNetworkTileSource $tile_source
)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_get_uri_format (
  ChamplainNetworkTileSource $tile_source
)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_new_full (
  Str                    $id,
  Str                    $name,
  Str                    $license,
  Str                    $license_uri,
  guint                  $min_zoom,
  guint                  $max_zoom,
  guint                  $tile_size,
  ChamplainMapProjection $projection,
  Str                    $uri_format,
  ChamplainRenderer      $renderer
)
  returns ChamplainNetworkTileSource
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_set_max_conns (
  ChamplainNetworkTileSource $tile_source,
  gint                       $max_conns
)
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_set_offline (
  ChamplainNetworkTileSource $tile_source,
  gboolean                   $offline
)
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_set_proxy_uri (
  ChamplainNetworkTileSource $tile_source,
  Str                        $proxy_uri
)
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_set_uri_format (
  ChamplainNetworkTileSource $tile_source,
  Str                        $uri_format
)
  is native(champlain)
  is export
{ * }

sub champlain_network_tile_source_set_user_agent (
  ChamplainNetworkTileSource $tile_source,
  Str                        $user_agent
)
  is native(champlain)
  is export
{ * }
