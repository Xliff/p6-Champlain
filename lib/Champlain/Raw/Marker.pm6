use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::Marker;

### /usr/include/champlain-0.12/champlain/champlain-marker.h

sub champlain_marker_animate_in (ChamplainMarker $marker)
  is native(champlain)
  is export
{ * }

sub champlain_marker_animate_in_with_delay (
  ChamplainMarker $marker,
  guint           $delay
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_animate_out (ChamplainMarker $marker)
  is native(champlain)
  is export
{ * }

sub champlain_marker_animate_out_with_delay (
  ChamplainMarker $marker,
  guint           $delay
)
  is native(champlain)
  is export
{ * }

sub champlain_marker_get_draggable (ChamplainMarker $marker)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_marker_get_selectable (ChamplainMarker $marker)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_marker_get_selected (ChamplainMarker $marker)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_marker_get_selection_color ()
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_marker_get_selection_text_color ()
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_marker_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_marker_new ()
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_marker_set_draggable (ChamplainMarker $marker, gboolean $value)
  is native(champlain)
  is export
{ * }

sub champlain_marker_set_selectable (ChamplainMarker $marker, gboolean $value)
  is native(champlain)
  is export
{ * }

sub champlain_marker_set_selected (ChamplainMarker $marker, gboolean $value)
  is native(champlain)
  is export
{ * }

sub champlain_marker_set_selection_color (ClutterColor $color)
  is native(champlain)
  is export
{ * }

sub champlain_marker_set_selection_text_color (ClutterColor $color)
  is native(champlain)
  is export
{ * }
