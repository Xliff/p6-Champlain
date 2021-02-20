use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::Scale;

### /usr/include/champlain-0.12/champlain/champlain-scale.h

sub champlain_scale_connect_view (ChamplainScale $scale, ChamplainView $view)
  is native(champlain)
  is export
{ * }

sub champlain_scale_disconnect_view (ChamplainScale $scale)
  is native(champlain)
  is export
{ * }

sub champlain_scale_get_max_width (ChamplainScale $scale)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_scale_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_scale_get_unit (ChamplainScale $scale)
  returns ChamplainUnit
  is native(champlain)
  is export
{ * }

sub champlain_scale_new ()
  returns ChamplainScale
  is native(champlain)
  is export
{ * }

sub champlain_scale_set_max_width (ChamplainScale $scale, guint $value)
  is native(champlain)
  is export
{ * }

sub champlain_scale_set_unit (ChamplainScale $scale, ChamplainUnit $unit)
  is native(champlain)
  is export
{ * }
