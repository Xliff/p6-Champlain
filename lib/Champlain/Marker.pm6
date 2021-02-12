use v6.c;

use Champlain::Raw::Types;
use Champlain::Raw::Marker;

use Clutter::Actor;
use Clutter::Color;

use Champlain::Roles::Location;

our subset ChamplainMarkerAncestry is export of Mu
  where ChamplainMarker | ClutterActorAncestry;

class Champlain::Marker is Clutter::Actor {
  also does Champlain::Roles::Location;

  has ChamplainMarker $!cm;

  submethod BUILD (:$marker) {
    self.setChamplainMarker($marker) if $marker;
  }

  method setChamplainMarker(ChamplainMarkerAncestry $_) {
    my $to-parent;

    $!cm = do {
      when ChamplainMarker {
        $to-parent = cast(ClutterActor, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMarker, $_);
      }
    }
    self.setClutterActor($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMarker
  { $!cm }

  multi method new (ChamplainMarkerAncestry $marker, :$ref = True) {
    return Nil unless $marker;

    my $o = self.bless( :$marker );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $marker = champlain_marker_new();

    $marker ?? self.bless( :$marker ) !! Nil;
  }

  # Type: gboolean
  method draggable is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('draggable', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('draggable', $gv);
      }
    );
  }

  # Type: gboolean
  method selectable is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('selectable', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('selectable', $gv);
      }
    );
  }

  # Type: gboolean
  method selected is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('selected', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
       $gv.boolean = $val;
        self.prop_set('selected', $gv);
      }
    );
  }

  # Is originally:
  # ChamplainMarker, ClutterEvent, gpointer --> void
  method button-press {
    self.connect-clutter-event($!cm, 'button-press');
  }

  # Is originally:
  # ChamplainMarker, ClutterEvent, gpointer --> void
  method button-release {
    self.connect-clutter-event($!cm, 'button-release');
  }

  # Is originally:
  # ChamplainMarker, ClutterEvent, gpointer --> void
  method drag-finish {
    self.connect-clutter-event($!cm, 'drag-finish');
  }

  method animate_in {
    champlain_marker_animate_in($!cm);
  }

  method animate_in_with_delay (Int() $delay) {
    my guint $d = $delay;

    champlain_marker_animate_in_with_delay($!cm, $d);
  }

  method animate_out {
    champlain_marker_animate_out($!cm);
  }

  method animate_out_with_delay (Int() $delay) {
    my guint $d = $delay;

    champlain_marker_animate_out_with_delay($!cm, $delay);
  }

  method get_draggable {
    so champlain_marker_get_draggable($!cm);
  }

  method get_selectable {
    so champlain_marker_get_selectable($!cm);
  }

  method get_selected {
    so champlain_marker_get_selected($!cm);
  }

  method get_selection_color (:$raw = False) {
    my $cc = champlain_marker_get_selection_color($!cm);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_selection_text_color (:$raw = False) {
    champlain_marker_get_selection_text_color($!cm);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_marker_get_type,
      $n,
      $t
    );
  }

  method set_draggable (Int() $value) {
    my gboolean $v = $value;

    champlain_marker_set_draggable($!cm, $v);
  }

  method set_selectable (Int() $value) {
    my gboolean $v = $value;

    champlain_marker_set_selectable($!cm, $v);
  }

  method set_selected (Int() $value) {
    my gboolean $v = $value;

    champlain_marker_set_selected($!cm, $v);
  }

  method set_selection_color (
    Champlain::Marker:U:
    ClutterColor() $color
  ) {
    champlain_marker_set_selection_color($cc);
  }

  method set_selection_text_color (
    Champlain::Marker:U:
    ClutterColor() $color
  ) {
    champlain_marker_set_selection_text_color($cc);
  }
}
