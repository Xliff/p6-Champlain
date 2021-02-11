use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::MarkerLayer;

### /usr/include/champlain-0.12/champlain/champlain-marker-layer.h

sub champlain_marker_layer_add_marker (
  ChamplainMarkerLayer $layer,
  ChamplainMarker      $marker
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_animate_in_all_markers (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_animate_out_all_markers (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_get_markers (ChamplainMarkerLayer $layer)
  returns GList
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_get_selected (ChamplainMarkerLayer $layer)
  returns GList
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_get_selection_mode (ChamplainMarkerLayer $layer)
  returns ChamplainSelectionMode
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_hide_all_markers (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_new ()
  returns ChamplainMarkerLayer
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_new_full (ChamplainSelectionMode $mode)
  returns ChamplainMarkerLayer
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_remove_all (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_remove_marker (
  ChamplainMarkerLayer $layer,
  ChamplainMarker      $marker
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_select_all_markers (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_set_all_markers_draggable (
  ChamplainMarkerLayer $layer
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_set_all_markers_undraggable (
  ChamplainMarkerLayer $layer
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_set_selection_mode (
  ChamplainMarkerLayer   $layer,
  ChamplainSelectionMode $mode
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_show_all_markers (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }

sub champlain_marker_layer_unselect_all_markers (ChamplainMarkerLayer $layer)
  is native(champlain)
  is export
{ * }
