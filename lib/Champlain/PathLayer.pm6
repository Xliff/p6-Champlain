use v6.c;

use Champlain::Raw::Types;
use Champlain::Raw::PathLayer;

use Clutter::Color;
use Champlain::Layer;

use Champlain::Roles::Location;

our subset ChamplainPathLayerAncestry is export of Mu
  where ChamplainPathLayer | ChamplainLayerAncestry;

class Champlain::PathLayer is Champlain::Layer {
  has ChamplainPathLayer $!pl

  submethod BUILD (:$path-layer) {
    self.setChamplainPathLayer($path-layer) if $path-layer;
  }

  method setChamplainPathLayer(ChamplainPathLayerAncestry $_) {
    my $to-parent;

    $!cpl = do {
      when ChamplainPathLayer {
        $to-parent = cast(ChamplainLayer, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainPathLayer, $_);
      }
    }
    self.setChamplainLayer($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainPathLayer
    is also<ChamplainPathLayer>
  { $!cpl }

  multi method new (ChamplainPathLayerAncestry $path-layer, :$ref = True) {
    return Nil unless $path-layer;

    my $o = self.bless( :$path-layer );
    $o.ref if $ref;
    $o;
  }
  method new {
    my $path-layer = champlain_path_layer_new();

    $path-layer ?? self.bless( :$path-layer ) !! Nil;
  }

  # Type: gboolean
  method closed is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('closed', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('closed', $gv);
      }
    );
  }

  # Type: gboolean
  method fill is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('fill', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('fill', $gv);
      }
    );
  }

  # Type: ClutterColor
  method fill-color (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Clutter::Color.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('fill-color', $gv)
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
        self.prop_set('fill-color', $gv);
      }
    );
  }

  # Type: gboolean
  method stroke is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('stroke', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('stroke', $gv);
      }
    );
  }

  # Type: ClutterColor
  method stroke-color is rw  {
    my $gv = GLib::Value.new( Clutter::Color.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('stroke-color', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ClutterColor,
          Clutter::Color
        );
      },
      STORE => -> $, ClutterColor() $val is copy {
        $gv.object = $object;
        self.prop_set('stroke-color', $gv);
      }
    );
  }

  # Type: gdouble
  method stroke-width is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('stroke-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('stroke-width', $gv);
      }
    );
  }

  # Type: gboolean
  method visible is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('visible', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('visible', $gv);
      }
    );
  }

  method add_node (ChamplainLocation() $location) {
    champlain_path_layer_add_node($!cpl, $location);
  }

  method get_closed {
    so hamplain_path_layer_get_closed($!cpl);
  }

  method get_dash (:$glist = False, :$raw = False) {
    returnGList(
      champlain_path_layer_get_dash($!cpl),
      $glist,
      $raw,
      guint
    );
  }

  method get_fill {
    so champlain_path_layer_get_fill($!cpl);
  }

  # Transfer: unknown
  method get_fill_color (:$raw = False) {
    my $cc = champlain_path_layer_get_fill_color($!cpl);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil
  }

  method get_nodes (:$glist = False, :$raw = False) {
    returnGList(
      champlain_path_layer_get_nodes($!cpl).
      $glist,
      $raw,
      ChamplainLocation,
      Champlain::Location
    )
  }

  method get_stroke {
    so champlain_path_layer_get_stroke($!cpl);
  }

  # Transfer: unknown
  method get_stroke_color (:$raw = False) {
    my $cc = champlain_path_layer_get_stroke_color($!cpl);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil
  }

  method get_stroke_width {
    champlain_path_layer_get_stroke_width($!cpl);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      champlain_path_layer_get_type,
      $n,
      $t
    );
  }

  method get_visible {
    so champlain_path_layer_get_visible($!cpl);
  }

  method insert_node (ChamplainLocation() $location, Int() $position) {
    my guint $p = $position;

    champlain_path_layer_insert_node($!cpl, $location, $position);
  }

  method remove_all {
    champlain_path_layer_remove_all($!cpl);
  }

  method remove_node (ChamplainLocation() $location) {
    champlain_path_layer_remove_node($!cpl, $location);
  }

  method set_closed (Int() $value) {
    my gboolean $v = $value.so.Int;

    champlain_path_layer_set_closed($!cpl, $value);
  }

  method set_dash (GList() $dash_pattern) {
    champlain_path_layer_set_dash($!cpl, $dash_pattern);
  }

  method set_fill (Int() $value) {
    my gboolean $v = $value.so.Int;

    champlain_path_layer_set_fill($!cpl, $value);
  }

  method set_fill_color (ClutterColor() $color) {
    champlain_path_layer_set_fill_color($!cpl, $color);
  }

  method set_stroke (Int() $value) {
    my gboolean $v = $value.so.Int;

    champlain_path_layer_set_stroke($!cpl, $value);
  }

  method set_stroke_color (ClutterColor() $color) {
    champlain_path_layer_set_stroke_color($!cpl, $color);
  }

  method set_stroke_width (Int() $value) {
    my gboolean $v = $value.so.Int;

    champlain_path_layer_set_stroke_width($!cpl, $value);
  }

  method set_visible (Int() $value) {
    my gboolean $v = $value.so.Int;

    champlain_path_layer_set_visible($!cpl, $value);
  }

}
