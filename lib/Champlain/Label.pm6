use v6.c;

use Champlain::Raw::Types;
use Champlain::Raw::Label;

use GLib::Value;
use Clutter::Actor;
use Clutter::Color;
use Champlain::Marker;

our subset ChamplainLabelAncestry is export of Mu
  where ChamplainLabel | ChamplainMarkerAncestry;

class Champlain::Label is Champlain::Marker {
  has ChamplainLabel $!cl;

  submethod BUILD (:$marker) {
    self.setChamplainLabel($marker) if $marker;
  }

  method setChamplainLabel(ChamplainLabelAncestry $_) {
    my $to-parent;

    $!cl = do {
      when ChamplainLabel {
        $to-parent = cast(ChamplainLabel, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainLabel, $_);
      }
    }
    self.setChamplainLabel($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainLabel
  { $!cl }

  multi method new (ChamplainLabelAncestry $marker, :$ref = True) {
    return Nil unless $marker;

    my $o = self.bless( :$marker );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $label = champlain_label_new();

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_from_file (
    Str                     $filename,
    CArray[Pointer[GError]] $error    = gerror
  ) {
    clear_error;
    my $label = champlain_label_new_from_file($!cl, $filename, $error);
    set_error($error);

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_full (Str() $text, ClutterActor() $actor) {
    my $label = champlain_label_new_full($text, $actor);

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_with_image (ChamplainLabel $actor) {
    my $image = champlain_label_new_with_image($actor);

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_with_text (
    Str()          $text,
    Str()          $font,
    ClutterColor() $text_color,
    ClutterColor() $label_color
  ) {
    my $label = champlain_label_new_with_text(
      $text,
      $font,
      $text_color,
      $label_color
    );

    $label ?? self.bless( :$label ) !! Nil;
  }

  # Type: PangoAlignment
  method alignment is rw  {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(PangoAlignment) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('alignment', $gv)
        );
        PangoAlignmentEnum( $gv.valueFromEnum(PangoAlignment) );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(PangoAlignment) = $val;
        self.prop_set('alignment', $gv);
      }
    );
  }

  # Type: ClutterColor
  method color (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Clutter::Color.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('color', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ClutterColor,
          Clutter::Color
        )
      },
      STORE => -> $, ClutterColor() $val is copy {
        $gv.object = $val;
        self.prop_set('color', $gv);
      }
    );
  }

  # Type: gboolean
  method draw-background is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('draw-background', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('draw-background', $gv);
      }
    );
  }

  # Type: PangoEllipsizeMode
  method ellipsize is rw  {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(PangoEllipsizeMode) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ellipsize', $gv)
        );
        PangoEllipsizeModeEnum( $gv.valueFromEnum(PangoEllipsizeMode) )
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(PangoEllipsizeMode) = $val;
        self.prop_set('ellipsize', $gv);
      }
    );
  }

  # Type: gchar
  method font-name is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('font-name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('font-name', $gv);
      }
    );
  }

  # Type: ClutterActor
  method image (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Clutter::Actor.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('image', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ClutterActor,
          Clutter::Actor
        )
      },
      STORE => -> $, ClutterActor() $val is copy {
        $gv.object = $val;
        self.prop_set('image', $gv);
      }
    );
  }

  # Type: gboolean
  method single-line-mode is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('single-line-mode', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('single-line-mode', $gv);
      }
    );
  }

  # Type: gchar
  method text is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('text', $gv);
      }
    );
  }

  # Type: ClutterColor
  method text-color (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Clutter::Color.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-color', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ClutterColor,
          Clutter::Color
        );
      },
      STORE => -> $, ClutterColor() $val is copy {
        $gv.object = $val;
        self.prop_set('text-color', $gv);
      }
    );
  }

  # Type: gboolean
  method use-markup is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('use-markup', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('use-markup', $gv);
      }
    );
  }

  # Type: gboolean
  method wrap is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('wrap', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('wrap', $gv);
      }
    );
  }

  # Type: PangoWrapMode
  method wrap-mode is rw  {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(PangoWrapMode) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('wrap-mode', $gv)
        );
        PangoWrapModeEnum( $gv.valueFromEnum(PangoWrapMode) )
      },
      STORE => -> $, Int()  $val is copy {
        $gv.valueFromEnum(PangoWrapMode) = $val;
        self.prop_set('wrap-mode', $gv);
      }
    );
  }

  method get_alignment {
    PangoAlignmentEnum( champlain_label_get_alignment($!cl) );
  }

  # Transfer: unknown
  method get_attributes (:$raw = False) {
    my $pal = champlain_label_get_attributes($!cl);

    $pal ??
      ( $raw ?? $pal !! Pango::AttributeList.new($pal) )
      !!
      Nil;
  }

  # Transfer: unknown
  method get_color (:$raw = False) {
    my $cc = champlain_label_get_color($!cl);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_draw_background {
    so champlain_label_get_draw_background($!cl);
  }

  method get_draw_shadow {
    so champlain_label_get_draw_shadow($!cl);
  }

  method get_ellipsize {
    PangoEllipsizeModeEnum( champlain_label_get_ellipsize($!cl) );
  }

  method get_font_name {
    champlain_label_get_font_name($!cl);
  }

  # Transfer: none;
  method get_image (:$raw = False) {
    my $ca = champlain_label_get_image($!cl);

    $ca ??
      ( $raw ?? $ca !! Clutter::Actor.new($ca) )
      !!
      Nil
  }

  method get_single_line_mode {
    so champlain_label_get_single_line_mode($!cl);
  }

  method get_text {
    champlain_label_get_text($!cl);
  }

  method get_text_color (:$raw = False) {
    my $cc = champlain_label_get_text_color($!cl);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_label_get_type,
      $n,
      $t
    );
  }

  method get_use_markup {
    so champlain_label_get_use_markup($!cl);
  }

  method get_wrap {
    so champlain_label_get_wrap($!cl);
  }

  method get_wrap_mode {
    PangoWrapModeEnum( champlain_label_get_wrap_mode($!cl) );
  }

  method set_alignment (Int() $alignment) {
    my PangoAlignment $a = $alignment;

    champlain_label_set_alignment($!cl, $a);
  }

  method set_attributes (PangoAttrList() $list) {
    champlain_label_set_attributes($!cl, $list);
  }

  method set_color (ClutterColor() $color) {
    champlain_label_set_color($!cl, $color);
  }

  method set_draw_background (Int() $background) {
    my gboolean $b = $background.so.Int;

    champlain_label_set_draw_background($!cl, $b);
  }

  method set_draw_shadow (Int() $shadow) {
    my gboolean $s = $shadow.so.Int;

    champlain_label_set_draw_shadow($!cl, $s);
  }

  method set_ellipsize (Int() $mode) {
    my PangoEllipsizeMode $m = $mode;

    champlain_label_set_ellipsize($!cl, $mode);
  }

  method set_font_name (Str() $font_name) {
    champlain_label_set_font_name($!cl, $font_name);
  }

  method set_image (ChamplainLabel() $image) {
    champlain_label_set_image($!cl, $image);
  }

  method set_single_line_mode (Int() $mode) {
    my gboolean $m = $mode.so.Int;

    champlain_label_set_single_line_mode($!cl, $m);
  }

  method set_text (Str() $text) {
    champlain_label_set_text($!cl, $text);
  }

  method set_text_color (ClutterColor() $color) {
    champlain_label_set_text_color($!cl, $color);
  }

  method set_use_markup (Int() $use_markup) {
    my gboolean $u = $use_markup;

    champlain_label_set_use_markup($!cl, $use_markup);
  }

  method set_wrap (Int() $wrap) {
    my gboolean $w = $wrap.so.Int;

    champlain_label_set_wrap($!cl, $w);
  }

  method set_wrap_mode (Int() $wrap_mode) {
    my PangoWrapMode $w = $wrap_mode;

    champlain_label_set_wrap_mode($!cl, $w);
  }

}
