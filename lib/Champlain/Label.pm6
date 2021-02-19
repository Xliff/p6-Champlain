use v6.c;

use Method::Also;
use NativeCall;

use Champlain::Raw::Types;
use Champlain::Raw::Label;

use GLib::Value;
use Clutter::Actor;
use Clutter::Color;
use Champlain::Marker;

our subset ChamplainLabelAncestry is export of Mu
  where ChamplainLabel | ChamplainMarkerAncestry;

my @attributes = <
  alignment
  color
  draw-background
  ellipsize
  font-name
  image
  single-line-mode
  text
  use-markup
  wrap
  wrap-mode
>;

class Champlain::Label is Champlain::Marker {
  has ChamplainLabel $!cl is implementor;

  submethod BUILD (:$label) {
    self.setChamplainLabel($label) if $label;
  }

  method setChamplainLabel(ChamplainLabelAncestry $_) {
    my $to-parent;

    $!cl = do {
      when ChamplainLabel {
        $to-parent = cast(ChamplainMarker, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainLabel, $_);
      }
    }
    self.setChamplainMarker($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainLabel
    is also<ChamplainLabel>
  { $!cl }

  multi method new (ChamplainLabelAncestry $label, :$ref = True) {
    return Nil unless $label;

    my $o = self.bless( :$label );
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
  )
    is also<new-from-file>
  {
    clear_error;
    my $label = champlain_label_new_from_file($filename, $error);
    set_error($error);

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_full (Str() $text, ClutterActor() $actor) is also<new-full> {
    my $label = champlain_label_new_full($text, $actor);

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_with_image (ClutterActor() $actor) is also<new-with-image> {
    my $label = champlain_label_new_with_image($actor);

    $label ?? self.bless( :$label ) !! Nil;
  }

  method new_with_text (
    Str()          $text,
    Str()          $font,
    ClutterColor() $text_color   = ClutterColor,
    ClutterColor() $label_color  = ClutterColor
  )
    is also<new-with-text>
  {
    my $label = champlain_label_new_with_text(
      $text,
      $font,
      $text_color,
      $label_color
    );

    $label ?? self.bless( :$label ) !! Nil;
  }

  method setup(*%data) {
    for %data.keys -> $_ is copy {

      when @attributes.any  {
        my $proper-name = S:g/'-'/_/;
        say "CLAA: {$_}" if $DEBUG;
        self."$proper-name"() = %data{$_};
        %data{$_}:delete;
      }

      # when @set-methods.any {
      #   my $proper-name = S:g/'-'/_/;
      #   say "CLSM: {$_}" if $DEBUG;
      #   self."set_{ $proper-name }"( |%data{$_} );
      #   %data{$_}:delete
      # }

    }
    # Not as clean as I like it, but it solves problems nextwith does NOT.
    self.Champlain::Marker::setup( |%data ) if %data.keys;
    self;
  }

  # Type: PangoAlignment
  method alignment is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(PangoAlignment) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('alignment', $gv)
        );
        PangoAlignmentEnum( $gv.valueFromType(PangoAlignment) );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(PangoAlignment) = $val;
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
          $gv.boxed,
          $raw,
          ClutterColor,
          Clutter::Color
        )
      },
      STORE => -> $, ClutterColor() $val is copy {
        $gv.boxed = $val;
        self.prop_set('color', $gv);
      }
    );
  }

  # Type: gboolean
  method draw-background is rw  is also<draw_background> {
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
  method font-name is rw  is also<font_name> {
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
  method single-line-mode is rw  is also<single_line_mode> {
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
  method text-color (:$raw = False) is rw  is also<text_color> {
    my $gv = GLib::Value.new( Clutter::Color.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-color', $gv)
        );

        propReturnObject(
          $gv.boxed,
          $raw,
          ClutterColor,
          Clutter::Color
        );
      },
      STORE => -> $, ClutterColor() $val is copy {
        $gv.boxed = $val;
        self.prop_set('text-color', $gv);
      }
    );
  }

  # Type: gboolean
  method use-markup is rw  is also<use_markup> {
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
  method wrap-mode is rw  is also<wrap_mode> {
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

  method get_alignment is also<get-alignment> {
    PangoAlignmentEnum( champlain_label_get_alignment($!cl) );
  }

  # Transfer: unknown
  method get_attributes (:$raw = False) is also<get-attributes> {
    my $pal = champlain_label_get_attributes($!cl);

    $pal ??
      ( $raw ?? $pal !! Pango::AttributeList.new($pal) )
      !!
      Nil;
  }

  # Transfer: unknown
  method get_color (:$raw = False) is also<get-color> {
    my $cc = champlain_label_get_color($!cl);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_draw_background is also<get-draw-background> {
    so champlain_label_get_draw_background($!cl);
  }

  method get_draw_shadow is also<get-draw-shadow> {
    so champlain_label_get_draw_shadow($!cl);
  }

  method get_ellipsize is also<get-ellipsize> {
    PangoEllipsizeModeEnum( champlain_label_get_ellipsize($!cl) );
  }

  method get_font_name is also<get-font-name> {
    champlain_label_get_font_name($!cl);
  }

  # Transfer: none;
  method get_image (:$raw = False) is also<get-image> {
    my $ca = champlain_label_get_image($!cl);

    $ca ??
      ( $raw ?? $ca !! Clutter::Actor.new($ca) )
      !!
      Nil
  }

  method get_single_line_mode is also<get-single-line-mode> {
    so champlain_label_get_single_line_mode($!cl);
  }

  method get_text is also<get-text> {
    champlain_label_get_text($!cl);
  }

  method get_text_color (:$raw = False) is also<get-text-color> {
    my $cc = champlain_label_get_text_color($!cl);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_label_get_type,
      $n,
      $t
    );
  }

  method get_use_markup is also<get-use-markup> {
    so champlain_label_get_use_markup($!cl);
  }

  method get_wrap is also<get-wrap> {
    so champlain_label_get_wrap($!cl);
  }

  method get_wrap_mode is also<get-wrap-mode> {
    PangoWrapModeEnum( champlain_label_get_wrap_mode($!cl) );
  }

  method set_alignment (Int() $alignment) is also<set-alignment> {
    my PangoAlignment $a = $alignment;

    champlain_label_set_alignment($!cl, $a);
  }

  method set_attributes (PangoAttrList() $list) is also<set-attributes> {
    champlain_label_set_attributes($!cl, $list);
  }

  method set_color (ClutterColor() $color) is also<set-color> {
    champlain_label_set_color($!cl, $color);
  }

  method set_draw_background (Int() $background) is also<set-draw-background> {
    my gboolean $b = $background.so.Int;

    champlain_label_set_draw_background($!cl, $b);
  }

  method set_draw_shadow (Int() $shadow) is also<set-draw-shadow> {
    my gboolean $s = $shadow.so.Int;

    champlain_label_set_draw_shadow($!cl, $s);
  }

  method set_ellipsize (Int() $mode) is also<set-ellipsize> {
    my PangoEllipsizeMode $m = $mode;

    champlain_label_set_ellipsize($!cl, $mode);
  }

  method set_font_name (Str() $font_name) is also<set-font-name> {
    champlain_label_set_font_name($!cl, $font_name);
  }

  method set_image (ChamplainLabel() $image) is also<set-image> {
    champlain_label_set_image($!cl, $image);
  }

  method set_single_line_mode (Int() $mode) is also<set-single-line-mode> {
    my gboolean $m = $mode.so.Int;

    champlain_label_set_single_line_mode($!cl, $m);
  }

  method set_text (Str() $text) is also<set-text> {
    champlain_label_set_text($!cl, $text);
  }

  method set_text_color (ClutterColor() $color) is also<set-text-color> {
    champlain_label_set_text_color($!cl, $color);
  }

  method set_use_markup (Int() $use_markup) is also<set-use-markup> {
    my gboolean $u = $use_markup;

    champlain_label_set_use_markup($!cl, $use_markup);
  }

  method set_wrap (Int() $wrap) is also<set-wrap> {
    my gboolean $w = $wrap.so.Int;

    champlain_label_set_wrap($!cl, $w);
  }

  method set_wrap_mode (Int() $wrap_mode) is also<set-wrap-mode> {
    my PangoWrapMode $w = $wrap_mode;

    champlain_label_set_wrap_mode($!cl, $w);
  }

}
