use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::View;

use GLib::GList;
use GLib::Value;
use Clutter::Actor;

use Champlain::MapSource;

my @attributes = <
  animate-zoom                animate_zoom
  deceleration
  goto-animation-duration     goto_animation_duration
  goto-animation-mode         goto_animation_mode
  keep-center-on-resize       keep_center_on_resize
  kinetic-mode                kinetic_mode
  latitude
  longitude
  max-zoom-level              max_zoom_level
  min-zoom-level              min_zoom_level
  state
  zoom-level                  zoom_level
  zoom-on-double-click        zoom_on_double_click
>;


our subset ChamplainViewAncestry is export of Mu
  where ChamplainView | ClutterActorAncestry;

class Champlain::View is Clutter::Actor {
  has ChamplainView $!cv is implementor;

  submethod BUILD (:$view) {
    self.setChamplainView($view) if $view;
  }

  method setChamplainView(ChamplainViewAncestry $_) {
    my $to-parent;

    $!cv = do {
      when ChamplainView {
        $to-parent = cast(ClutterActor, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainView, $_);
      }
    }
    self.setClutterActor($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainView
    is also<ChamplainView>
  { $!cv }

  multi method new (ChamplainViewAncestry $view, :$ref = True) {
    return Nil unless $view;

    my $o = self.bless( :$view );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $view = champlain_view_new();

    $view ?? self.bless( :$view ) !! Nil;
  }

  method setup(*%data) {
    for %data.keys -> $_ is copy {
      when @attributes.any  {
        say "CvAA: {$_}" if $DEBUG;
        self."$_"() = %data{$_};
        %data{$_}:delete;
      }

      when 'location' | 'center-on' | 'center_on' {
        self.center_on( |%data{$_} );
        %data{$_}:delete;
      }

      # when @add-methods.any {
      #   my $proper-name = S:g/'-'/_/;
      #   say "CvA: {$_}" if $DEBUG;
      #   self."add_{ $proper-name }"( |%data{$_} );
      #   %data{$_}:delete;
      # }
      #
      # when @set-methods.any {
      #   my $proper-name = S:g/'-'/_/;
      #   say "CvSM: {$_}" if $DEBUG;
      #   self."set_{ $proper-name }"( |%data{$_} );
      #   %data{$_}:delete;
      # }

    }
    self.Clutter::Actor::setup(|%data) if %data.keys;
    self
  }

  # Type: gboolean
  method animate-zoom is rw  is also<animate_zoom> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('animate-zoom', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('animate-zoom', $gv);
      }
    );
  }

  # Type: ClutterActor
  method background-pattern (:$raw = False) is rw  is also<background_pattern> {
    my $gv = GLib::Value.new( Clutter::Actor.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('background-pattern', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ClutterActor,
          Clutter::Actor
        );
      },
      STORE => -> $, ClutterActor() $val is copy {
        $gv.object = $val;
        self.prop_set('background-pattern', $gv);
      }
    );
  }

  # Type: gdouble
  method deceleration is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('deceleration', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('deceleration', $gv);
      }
    );
  }

  # Type: guint
  method goto-animation-duration is rw  is also<goto_animation_duration> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('goto-animation-duration', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('goto-animation-duration', $gv);
      }
    );
  }

  # Type: ClutterAnimationMode
  method goto-animation-mode is rw  is also<goto_animation_mode> {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(ClutterAnimationMode) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('goto-animation-mode', $gv)
        );
        ClutterAnimationModeEnum(
          GLib::Value.valueFromEnum(ClutterAnimationMode)
        );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(ClutterAnimationMode) = $val;
        self.prop_set('goto-animation-mode', $gv);
      }
    );
  }

  # Type: gboolean
  method keep-center-on-resize is rw  is also<keep_center_on_resize> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('keep-center-on-resize', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('keep-center-on-resize', $gv);
      }
    );
  }

  # Type: gboolean
  method kinetic-mode is rw  is also<kinetic_mode> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kinetic-mode', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('kinetic-mode', $gv);
      }
    );
  }

  # Type: gdouble
  method latitude is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('latitude', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('latitude', $gv);
      }
    );
  }

  # Type: gdouble
  method longitude is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('longitude', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('longitude', $gv);
      }
    );
  }

  # Type: ChamplainMapSource
  method map-source (:$raw = False) is rw  is also<map_source> {
    my $gv = GLib::Value.new( Champlain::MapSource.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('map-source', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ChamplainMapSource,
          Champlain::MapSource
        );
      },
      STORE => -> $, ChamplainMapSource() $val is copy {
        $gv.object = $val;
        self.prop_set('map-source', $gv);
      }
    );
  }

  # Type: guint
  method max-zoom-level is rw  is also<max_zoom_level> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('max-zoom-level', $gv);
      }
    );
  }

  # Type: guint
  method min-zoom-level is rw  is also<min_zoom_level> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('min-zoom-level', $gv);
      }
    );
  }

  # Type: ChamplainState
  method state is rw  {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(ChamplainState) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('state', $gv)
        );
        ChamplainStateEnum( $gv.valueFromEnum(ChamplainState) )
      },
      STORE => -> $, $val is copy {
        warn 'state does not allow writing'
      }
    );
  }

  # Type: guint
  method zoom-level is rw  is also<zoom_level> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('zoom-level', $gv);
      }
    );
  }

  # Type: gboolean
  method zoom-on-double-click is rw  is also<zoom_on_double_click> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('zoom-on-double-click', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('zoom-on-double-click', $gv);
      }
    );
  }

  # Is originally:
  # ChamplainView, gpointer --> void
  method animation-completed is also<animation_completed> {
    self.connect($!cv, 'animation-completed');
  }

  # Is originally:
  # ChamplainView, gpointer --> void
  method layer-relocated is also<layer_relocated> {
    self.connect($!cv, 'layer-relocated');
  }

  method add_layer (ChamplainLayer() $layer) is also<add-layer> {
    champlain_view_add_layer($!cv, $layer);
  }

  method add_overlay_source (
    ChamplainMapSource() $map_source,
    Int()                $opacity
  ) is also<add-overlay-source> {
    my guint8 $o = $opacity;

    champlain_view_add_overlay_source($!cv, $map_source, $o);
  }

  method bin_layout_add (
    ClutterActor() $child,
    Int()          $x_align,
    Int()          $y_align
  ) is also<bin-layout-add> {
    my ClutterBinAlignment ($xa, $ya) = ($x_align, $y_align);

    champlain_view_bin_layout_add($!cv, $child, $xa, $ya);
  }

  method center_on (Num() $latitude, Num() $longitude) is also<center-on> {
    my gdouble ($lat, $long) = ($latitude, $longitude);

    champlain_view_center_on($!cv, $lat, $long);
  }

  method ensure_layers_visible (Int() $animate) is also<ensure-layers-visible> {
    my gboolean $a = $animate.so.Int;

    champlain_view_ensure_layers_visible($!cv, $a);
  }

  method ensure_visible (ChamplainBoundingBox $bbox, Int() $animate) is also<ensure-visible> {
    my gboolean $a = $animate.so.Int;

    champlain_view_ensure_visible($!cv, $bbox, $a);
  }

  method get_animate_zoom is also<get-animate-zoom> {
    so champlain_view_get_animate_zoom($!cv);
  }

  # Transfer: none
  method get_background_pattern (:$raw = False) is also<get-background-pattern> {
    my $cc = champlain_view_get_background_pattern($!cv);

    $cc ??
      ( $raw ?? $cc !! Clutter::Content.new($cc) )
      !!
      Nil
  }

  method get_bounding_box is also<get-bounding-box> {
    champlain_view_get_bounding_box($!cv);
  }

  method get_bounding_box_for_zoom_level (Int() $zoom_level) is also<get-bounding-box-for-zoom-level> {
    my guint $z = $zoom_level;

    champlain_view_get_bounding_box_for_zoom_level($!cv, $z);
  }

  method get_center_latitude is also<get-center-latitude> {
    champlain_view_get_center_latitude($!cv);
  }

  method get_center_longitude is also<get-center-longitude> {
    champlain_view_get_center_longitude($!cv);
  }

  method get_deceleration is also<get-deceleration> {
    champlain_view_get_deceleration($!cv);
  }

  method get_horizontal_wrap is also<get-horizontal-wrap> {
    so champlain_view_get_horizontal_wrap($!cv);
  }

  method get_keep_center_on_resize is also<get-keep-center-on-resize> {
    so champlain_view_get_keep_center_on_resize($!cv);
  }

  method get_kinetic_mode is also<get-kinetic-mode> {
    so champlain_view_get_kinetic_mode($!cv);
  }

  # Transfer: none
  method get_license_actor (:$raw = False) is also<get-license-actor> {
    my $l = champlain_view_get_license_actor($!cv);

    $l ??
      ( $raw ?? $l !! Champlain::License.new($l) )
      !!
      Nil;
  }

  # Transfer: none
  method get_map_source (:$raw = False) is also<get-map-source> {
    my $ms = champlain_view_get_map_source($!cv);

    $ms ??
      ( $raw ?? $ms !! Champlain::MapSource.new($ms) )
      !!
      Nil;
  }

  method get_max_zoom_level is also<get-max-zoom-level> {
    champlain_view_get_max_zoom_level($!cv);
  }

  method get_min_zoom_level is also<get-min-zoom-level> {
    champlain_view_get_min_zoom_level($!cv);
  }

  method get_overlay_sources (:$glist = False, :$raw = False) is also<get-overlay-sources> {
    returnGList(
      champlain_view_get_overlay_sources($!cv),
      $glist,
      $raw,
      ChamplainMapSource,
      Champlain::MapSource
    );
  }

  method get_state is also<get-state> {
    ChamplainStateEnum( champlain_view_get_state($!cv) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_view_get_type,
      $n,
      $t
    );
  }

  proto method get_viewport_anchor (|)
      is also<get-viewport-anchor>
  { * }

  multi method get_viewport_anchor {
    samewith($, $);
  }
  multi method get_viewport_anchor ($anchor_x is rw, $anchor_y is rw) {
    my gint ($ax, $ay) = 0 xx 2;

    champlain_view_get_viewport_anchor($!cv, $ax, $ay);
    ($anchor_x, $anchor_y) = ($ax, $ay);
  }

  proto method get_viewport_origin (|)
      is also<get-viewport-origin>
  { * }

  multi method get_viewport_origin {
    samewith($, $);
  }
  multi method get_viewport_origin ($x is rw, $y is rw) {
    my gint ($xx, $yy) = 0 xx 2;

    champlain_view_get_viewport_origin($!cv, $xx, $yy);
    ($x, $y) = ($xx, $yy);
  }

  method get_world is also<get-world> {
    champlain_view_get_world($!cv);
  }

  method get_zoom_level is also<get-zoom-level> {
    champlain_view_get_zoom_level($!cv);
  }

  method get_zoom_on_double_click is also<get-zoom-on-double-click> {
    so champlain_view_get_zoom_on_double_click($!cv);
  }

  method go_to (Num() $latitude, Num() $longitude) is also<go-to> {
    my gdouble ($lat, $long) = ($latitude, $longitude);

    champlain_view_go_to($!cv, $lat, $long);
  }

  method latitude_to_y (Num() $latitude) is also<latitude-to-y> {
    my gdouble $l = $latitude;

    champlain_view_latitude_to_y($!cv, $l);
  }

  method longitude_to_x (Num() $longitude) is also<longitude-to-x> {
    my gdouble $l = $longitude;

    champlain_view_longitude_to_x($!cv, $l);
  }

  method reload_tiles is also<reload-tiles> {
    champlain_view_reload_tiles($!cv);
  }

  method remove_layer (ChamplainLayer() $layer) is also<remove-layer> {
    champlain_view_remove_layer($!cv, $layer);
  }

  method remove_overlay_source (ChamplainMapSource() $map_source) is also<remove-overlay-source> {
    champlain_view_remove_overlay_source($!cv, $map_source);
  }

  method set_animate_zoom (Int() $value) is also<set-animate-zoom> {
    my gboolean $v = $value.so.Int;

    champlain_view_set_animate_zoom($!cv, $v);
  }

  method set_background_pattern (ClutterContent() $background) is also<set-background-pattern> {
    champlain_view_set_background_pattern($!cv, $background);
  }

  method set_deceleration (Num() $rate) is also<set-deceleration> {
    my gdouble $r = $rate;

    champlain_view_set_deceleration($!cv, $r);
  }

  method set_horizontal_wrap (Int() $wrap) is also<set-horizontal-wrap> {
    my gboolean $w = $wrap.so.Int;

    champlain_view_set_horizontal_wrap($!cv, $w);
  }

  method set_keep_center_on_resize (Int() $value) is also<set-keep-center-on-resize> {
    my gboolean $v = $value.so.Int;

    champlain_view_set_keep_center_on_resize($!cv, $v);
  }

  method set_kinetic_mode (Int() $kinetic) is also<set-kinetic-mode> {
    my gboolean $k = $kinetic.so.Int;

    champlain_view_set_kinetic_mode($!cv, $k);
  }

  method set_map_source (ChamplainMapSource() $map_source) is also<set-map-source> {
    champlain_view_set_map_source($!cv, $map_source);
  }

  method set_max_zoom_level (Int() $zoom_level) is also<set-max-zoom-level> {
    my guint $z = $zoom_level;

    champlain_view_set_max_zoom_level($!cv, $z);
  }

  method set_min_zoom_level (Int() $zoom_level) is also<set-min-zoom-level> {
    my guint $z = $zoom_level;

    champlain_view_set_min_zoom_level($!cv, $z);
  }

  method set_world (ChamplainBoundingBox $bbox) is also<set-world> {
    champlain_view_set_world($!cv, $bbox);
  }

  method set_zoom_level (Int() $zoom_level) is also<set-zoom-level> {
    my guint $z = $zoom_level;

    champlain_view_set_zoom_level($!cv, $z);
  }

  method set_zoom_on_double_click (Num() $value) is also<set-zoom-on-double-click> {
    my gboolean $v = $value.so.Int;

    champlain_view_set_zoom_on_double_click($!cv, $v);
  }

  method stop_go_to is also<stop-go-to> {
    champlain_view_stop_go_to($!cv);
  }

  method to_surface (Int() $include_layers) is also<to-surface> {
    my gboolean $i = $include_layers.so.Int;

    champlain_view_to_surface($!cv, $i);
  }

  method x_to_longitude (Num() $x) is also<x-to-longitude> {
    my gdouble $xx = $x;

    champlain_view_x_to_longitude($!cv, $xx);
  }

  method y_to_latitude (Num() $y) is also<y-to-latitude> {
    my gdouble $yy = $y;

    champlain_view_y_to_latitude($!cv, $yy);
  }

  method zoom_in is also<zoom-in> {
    champlain_view_zoom_in($!cv);
  }

  method zoom_out is also<zoom-out> {
    champlain_view_zoom_out($!cv);
  }


}
