use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::MapSource::Desc;

### /usr/include/champlain-0.12/champlain/champlain-map-source-desc.h

sub champlain_map_source_desc_get_constructor (ChamplainMapSourceDesc $desc)
  returns Pointer # &func(ChamplainMapSourceDesc --> ChamplainMapSource)
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_data (ChamplainMapSourceDesc $desc)
  returns Pointer
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_id (ChamplainMapSourceDesc $desc)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_license (ChamplainMapSourceDesc $desc)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_license_uri (ChamplainMapSourceDesc $desc)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_max_zoom_level (ChamplainMapSourceDesc $desc)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_min_zoom_level (ChamplainMapSourceDesc $desc)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_name (ChamplainMapSourceDesc $desc)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_projection (ChamplainMapSourceDesc $desc)
  returns ChamplainMapProjection
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_tile_size (ChamplainMapSourceDesc $desc)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_get_uri_format (ChamplainMapSourceDesc $desc)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_desc_new_full (
  Str                    $id,
  Str                    $name,
  Str                    $license,
  Str                    $license_uri,
  guint                  $min_zoom,
  guint                  $max_zoom,
  guint                  $tile_size,
  ChamplainMapProjection $projection,
  Str                    $uri_format,
                         &constructor (
                           ChamplainMapSourceDesc --> ChamplainMapSource
                         ),
  gpointer               $data
)
  returns ChamplainMapSourceDesc
  is native(champlain)
  is export
{ * }
