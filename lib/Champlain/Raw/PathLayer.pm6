use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Clutter::Raw::Structs;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::PathLayer;

### /usr/include/champlain-0.12/champlain/champlain-path-layer.h

sub champlain_path_layer_add_node (
  ChamplainPathLayer $layer,
  ChamplainLocation  $location
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_closed (ChamplainPathLayer $layer)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_dash (ChamplainPathLayer $layer)
  returns GList
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_fill (ChamplainPathLayer $layer)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_fill_color (ChamplainPathLayer $layer)
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_nodes (ChamplainPathLayer $layer)
  returns GList
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_stroke (ChamplainPathLayer $layer)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_stroke_color (ChamplainPathLayer $layer)
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_stroke_width (ChamplainPathLayer $layer)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_get_visible (ChamplainPathLayer $layer)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_insert_node (
  ChamplainPathLayer $layer,
  ChamplainLocation  $location,
  guint              $position
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_new ()
  returns ChamplainPathLayer
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_remove_all (ChamplainPathLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_remove_node (
  ChamplainPathLayer $layer,
  ChamplainLocation  $location
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_closed (
  ChamplainPathLayer $layer,
  gboolean           $value
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_dash (
  ChamplainPathLayer $layer,
  GList              $dash_pattern
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_fill (
  ChamplainPathLayer $layer,
  gboolean           $value
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_fill_color (
  ChamplainPathLayer $layer,
  ClutterColor       $color
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_stroke (
  ChamplainPathLayer $layer,
  gboolean           $value
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_stroke_color (
  ChamplainPathLayer $layer,
  ClutterColor       $color
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_stroke_width (
  ChamplainPathLayer $layer,
  gdouble            $value
)
  is native(champlain)
  is export
{ * }

sub champlain_path_layer_set_visible (
  ChamplainPathLayer $layer,
  gboolean           $value
)
  is native(champlain)
  is export
{ * }
