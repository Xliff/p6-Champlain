use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Pango::Raw::Definitions;
use Pango::Raw::Enums;
use Clutter::Raw::Definitions;
use Clutter::Raw::Structs;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::Label;

### /usr/include/champlain-0.12/champlain/champlain-label.h

sub champlain_label_get_alignment (ChamplainLabel $label)
  returns PangoAlignment
  is native(champlain)
  is export
{ * }

sub champlain_label_get_attributes (ChamplainLabel $label)
  returns PangoAttrList
  is native(champlain)
  is export
{ * }

sub champlain_label_get_color (ChamplainLabel $label)
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_label_get_draw_background (ChamplainLabel $label)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_label_get_draw_shadow (ChamplainLabel $label)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_label_get_ellipsize (ChamplainLabel $label)
  returns PangoEllipsizeMode
  is native(champlain)
  is export
{ * }

sub champlain_label_get_font_name (ChamplainLabel $label)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_label_get_image (ChamplainLabel $label)
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_label_get_single_line_mode (ChamplainLabel $label)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_label_get_text (ChamplainLabel $label)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_label_get_text_color (ChamplainLabel $label)
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_label_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_label_get_use_markup (ChamplainLabel $label)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_label_get_wrap (ChamplainLabel $label)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_label_get_wrap_mode (ChamplainLabel $label)
  returns PangoWrapMode
  is native(champlain)
  is export
{ * }

sub champlain_label_new ()
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_label_new_from_file (
  Str                     $filename,
  CArray[Pointer[GError]] $error
)
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_label_new_full (Str $text, ClutterActor $actor)
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_label_new_with_image (ClutterActor $actor)
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_label_new_with_text (
  Str          $text,
  Str          $font,
  ClutterColor $text_color,
  ClutterColor $label_color
)
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_label_set_alignment (
  ChamplainLabel $label,
  PangoAlignment $alignment
)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_attributes (ChamplainLabel $label, PangoAttrList $list)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_color (ChamplainLabel $label, ClutterColor $color)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_draw_background (
  ChamplainLabel $label,
  gboolean       $background
)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_draw_shadow (ChamplainLabel $label, gboolean $shadow)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_ellipsize (
  ChamplainLabel     $label,
  PangoEllipsizeMode $mode
)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_font_name (ChamplainLabel $label, Str $font_name)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_image (ChamplainLabel $label, ClutterActor $image)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_single_line_mode (
  ChamplainLabel $label,
  gboolean       $mode
)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_text (ChamplainLabel $label, Str $text)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_text_color (
  ChamplainLabel $label,
  ClutterColor   $color
)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_use_markup (
  ChamplainLabel $label,
  gboolean       $use_markup
)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_wrap (ChamplainLabel $label, gboolean $wrap)
  is native(champlain)
  is export
{ * }

sub champlain_label_set_wrap_mode (
  ChamplainLabel $label,
  PangoWrapMode  $wrap_mode
)
  is native(champlain)
  is export
{ * }
