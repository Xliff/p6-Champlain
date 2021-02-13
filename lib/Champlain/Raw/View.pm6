use v6.c;

use NativeCall;

use Cairo;
use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Clutter::Raw::Definitions;
use Clutter::Raw::Enums;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::View;

### /usr/include/champlain-0.12/champlain/champlain-view.h

sub champlain_view_add_layer (ChamplainView $view, ChamplainLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_view_add_overlay_source (
  ChamplainView      $view,
  ChamplainMapSource $map_source,
  guint8             $opacity
)
  is native(champlain)
  is export
{ * }

sub champlain_view_bin_layout_add (
  ChamplainView       $view,
  ClutterActor        $child,
  ClutterBinAlignment $x_align,
  ClutterBinAlignment $y_align
)
  is native(champlain)
  is export
{ * }

sub champlain_view_center_on (
  ChamplainView $view,
  gdouble       $latitude,
  gdouble       $longitude
)
  is native(champlain)
  is export
{ * }

sub champlain_view_ensure_layers_visible (
  ChamplainView $view,
  gboolean      $animate
)
  is native(champlain)
  is export
{ * }

sub champlain_view_ensure_visible (
  ChamplainView        $view,
  ChamplainBoundingBox $bbox,
  gboolean             $animate
)
  is native(champlain)
  is export
{ * }

sub champlain_view_get_animate_zoom (ChamplainView $view)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_view_get_background_pattern (ChamplainView $view)
  returns ClutterContent
  is native(champlain)
  is export
{ * }

sub champlain_view_get_bounding_box (ChamplainView $view)
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }

sub champlain_view_get_bounding_box_for_zoom_level (
  ChamplainView $view,
  guint         $zoom_level
)
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }

sub champlain_view_get_center_latitude (ChamplainView $view)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_get_center_longitude (ChamplainView $view)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_get_deceleration (ChamplainView $view)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_get_horizontal_wrap (ChamplainView $view)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_view_get_keep_center_on_resize (ChamplainView $view)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_view_get_kinetic_mode (ChamplainView $view)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_view_get_license_actor (ChamplainView $view)
  returns ChamplainLicense
  is native(champlain)
  is export
{ * }

sub champlain_view_get_map_source (ChamplainView $view)
  returns ChamplainMapSource
  is native(champlain)
  is export
{ * }

sub champlain_view_get_max_zoom_level (ChamplainView $view)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_view_get_min_zoom_level (ChamplainView $view)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_view_get_overlay_sources (ChamplainView $view)
  returns GList
  is native(champlain)
  is export
{ * }

sub champlain_view_get_state (ChamplainView $view)
  returns ChamplainState
  is native(champlain)
  is export
{ * }

sub champlain_view_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_view_get_viewport_anchor (
  ChamplainView $view,
  gint          $anchor_x is rw,
  gint          $anchor_y is rw
)
  is native(champlain)
  is export
{ * }

sub champlain_view_get_viewport_origin (
  ChamplainView $view,
  gint          $x is rw,
  gint          $y is rw
)
  is native(champlain)
  is export
{ * }

sub champlain_view_get_world (ChamplainView $view)
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }

sub champlain_view_get_zoom_level (ChamplainView $view)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_view_get_zoom_on_double_click (ChamplainView $view)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_view_go_to (
  ChamplainView $view,
  gdouble       $latitude,
  gdouble       $longitude
)
  is native(champlain)
  is export
{ * }

sub champlain_view_latitude_to_y (ChamplainView $view, gdouble $latitude)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_longitude_to_x (ChamplainView $view, gdouble $longitude)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_new ()
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_view_reload_tiles (ChamplainView $view)
  is native(champlain)
  is export
{ * }

sub champlain_view_remove_layer (ChamplainView $view, ChamplainLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_view_remove_overlay_source (
  ChamplainView      $view,
  ChamplainMapSource $map_source
)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_animate_zoom (ChamplainView $view, gboolean $value)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_background_pattern (
  ChamplainView  $view,
  ClutterContent $background
)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_deceleration (ChamplainView $view, gdouble $rate)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_horizontal_wrap (ChamplainView $view, gboolean $wrap)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_keep_center_on_resize (
  ChamplainView $view,
  gboolean      $value
)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_kinetic_mode (ChamplainView $view, gboolean $kinetic)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_map_source (
  ChamplainView      $view,
  ChamplainMapSource $map_source
)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_max_zoom_level (ChamplainView $view, guint $zoom_level)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_min_zoom_level (ChamplainView $view, guint $zoom_level)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_world (ChamplainView $view, ChamplainBoundingBox $bbox)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_zoom_level (ChamplainView $view, guint $zoom_level)
  is native(champlain)
  is export
{ * }

sub champlain_view_set_zoom_on_double_click (
  ChamplainView $view,
  gboolean      $value
)
  is native(champlain)
  is export
{ * }

sub champlain_view_stop_go_to (ChamplainView $view)
  is native(champlain)
  is export
{ * }

sub champlain_view_to_surface (ChamplainView $view, gboolean $include_layers)
  returns Pointer # cairo_surface_t
  is native(champlain)
  is export
{ * }

sub champlain_view_x_to_longitude (ChamplainView $view, gdouble $x)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_y_to_latitude (ChamplainView $view, gdouble $y)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_view_zoom_in (ChamplainView $view)
  is native(champlain)
  is export
{ * }

sub champlain_view_zoom_out (ChamplainView $view)
  is native(champlain)
  is export
{ * }
