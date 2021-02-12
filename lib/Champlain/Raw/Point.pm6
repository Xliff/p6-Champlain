use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Clutter::Raw::Structs;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::Point;

### /usr/include/champlain-0.12/champlain/champlain-point.h

sub champlain_point_get_color (ChamplainPoint $point)
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_point_get_size (ChamplainPoint $point)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_point_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_point_new ()
  returns ChamplainPoint
  is native(champlain)
  is export
{ * }

sub champlain_point_new_full (gdouble $size, ClutterColor $color)
  returns ChamplainPoint
  is native(champlain)
  is export
{ * }

sub champlain_point_set_color (ChamplainPoint $point, ClutterColor $color)
  is native(champlain)
  is export
{ * }

sub champlain_point_set_size (ChamplainPoint $point, gdouble $size)
  is native(champlain)
  is export
{ * }
