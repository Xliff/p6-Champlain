use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Pango::Raw::Enums;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::License;

### /usr/include/champlain-0.12/champlain/champlain-license.h

sub champlain_license_connect_view (
  ChamplainLicense $license,
  ChamplainView    $view
)
  is native(champlain)
  is export
{ * }

sub champlain_license_disconnect_view (ChamplainLicense $license)
  is native(champlain)
  is export
{ * }

sub champlain_license_get_alignment (ChamplainLicense $license)
  returns PangoAlignment
  is native(champlain)
  is export
{ * }

sub champlain_license_get_extra_text (ChamplainLicense $license)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_license_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_license_new ()
  returns ChamplainLicense
  is native(champlain)
  is export
{ * }

sub champlain_license_set_alignment (
  ChamplainLicense $license,
  PangoAlignment   $alignment
)
  is native(champlain)
  is export
{ * }

sub champlain_license_set_extra_text (ChamplainLicense $license, Str $text)
  is native(champlain)
  is export
{ * }
