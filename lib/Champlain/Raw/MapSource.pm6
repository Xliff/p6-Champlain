use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

### /usr/include/champlain-0.12/champlain/champlain-map-source.h

sub champlain_map_source_fill_tile (
  ChamplainMapSource $map_source,
  ChamplainTile      $tile
)
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_column_count (
  ChamplainMapSource $map_source,
  guint              $zoom_level
)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_id (ChamplainMapSource $map_source)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_latitude (
  ChamplainMapSource $map_source,
  guint              $zoom_level,
  gdouble            $y
)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_license (ChamplainMapSource $map_source)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_license_uri (ChamplainMapSource $map_source)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_longitude (
  ChamplainMapSource $map_source,
  guint              $zoom_level,
  gdouble            $x
)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_max_zoom_level (ChamplainMapSource $map_source)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_meters_per_pixel (
  ChamplainMapSource $map_source,
  guint              $zoom_level,
  gdouble            $latitude,
  gdouble            $longitude
)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_min_zoom_level (ChamplainMapSource $map_source)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_name (ChamplainMapSource $map_source)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_next_source (ChamplainMapSource $map_source)
  returns ChamplainMapSource
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_projection (ChamplainMapSource $map_source)
  returns ChamplainMapProjection
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_renderer (ChamplainMapSource $map_source)
  returns ChamplainRenderer
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_row_count (
  ChamplainMapSource $map_source,
  guint              $zoom_level
)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_tile_size (ChamplainMapSource $map_source)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_x (
  ChamplainMapSource $map_source,
  guint              $zoom_level,
  gdouble            $longitude
)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_map_source_get_y (
  ChamplainMapSource $map_source,
  guint              $zoom_level,
  gdouble            $latitude
)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_map_source_set_next_source (
  ChamplainMapSource $map_source,
  ChamplainMapSource $next_source
)
  is native(champlain)
  is export
{ * }

sub champlain_map_source_set_renderer (
  ChamplainMapSource $map_source,
  ChamplainRenderer  $renderer
)
  is native(champlain)
  is export
{ * }
