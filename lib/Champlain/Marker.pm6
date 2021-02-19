use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::Marker;

use Clutter::Actor;
use Clutter::Color;

use Champlain::Roles::Location;

my @attributes  = <draggable selectable selected>;
my @set-methods = <
  location
  selection_color         selection-color
  selection_text_color    selction-text-color
>;

our subset ChamplainMarkerAncestry is export of Mu
  where ChamplainMarker | ClutterActorAncestry;

class Champlain::Marker is Clutter::Actor {
  also does Champlain::Roles::Location;

  has ChamplainMarker $!cm is implementor;

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
    self.roleInit-ChamplainLocation;
  }

  method Champlain::Raw::Definitions::ChamplainMarker
    is also<ChamplainMarker>
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

  method setup(*%data) {
    for %data.keys -> $_ is copy {

      when @attributes.any  {
        my $proper-name = S:g/'-'/_/;
        say "CMAA: {$_}" if $DEBUG;
        self."$proper-name"() = %data{$_};
        %data{$_}:delete;
      }

      when @set-methods.any {
        my $proper-name = S:g/'-'/_/;
        say "CMSM: {$_}" if $DEBUG;
        self."set_{ $proper-name }"( |%data{$_} );
        %data{$_}:delete
      }

    }
    # Not as clean as I like it, but it solves problems nextwith does NOT.
    self.Clutter::Actor::setup(|%data) if %data.keys;
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
  method button-press is also<button_press> {
    self.connect-clutter-event($!cm, 'button-press');
  }

  # Is originally:
  # ChamplainMarker, ClutterEvent, gpointer --> void
  method button-release is also<button_release> {
    self.connect-clutter-event($!cm, 'button-release');
  }

  # Is originally:
  # ChamplainMarker, ClutterEvent, gpointer --> void
  method drag-finish is also<drag_finish> {
    self.connect-clutter-event($!cm, 'drag-finish');
  }

  method animate_in is also<animate-in> {
    champlain_marker_animate_in($!cm);
  }

  method animate_in_with_delay (Int() $delay) is also<animate-in-with-delay> {
    my guint $d = $delay;

    champlain_marker_animate_in_with_delay($!cm, $d);
  }

  method animate_out is also<animate-out> {
    champlain_marker_animate_out($!cm);
  }

  method animate_out_with_delay (Int() $delay) is also<animate-out-with-delay> {
    my guint $d = $delay;

    champlain_marker_animate_out_with_delay($!cm, $delay);
  }

  method get_draggable is also<get-draggable> {
    so champlain_marker_get_draggable($!cm);
  }

  method get_selectable is also<get-selectable> {
    so champlain_marker_get_selectable($!cm);
  }

  method get_selected is also<get-selected> {
    so champlain_marker_get_selected($!cm);
  }

  method get_selection_color (:$raw = False) is also<get-selection-color> {
    my $cc = champlain_marker_get_selection_color();

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_selection_text_color (:$raw = False) is also<get-selection-text-color> {
    my $cc = champlain_marker_get_selection_text_color();

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_marker_get_type,
      $n,
      $t
    );
  }

  method set_draggable (Int() $value) is also<set-draggable> {
    my gboolean $v = $value;

    champlain_marker_set_draggable($!cm, $v);
  }

  method set_selectable (Int() $value) is also<set-selectable> {
    my gboolean $v = $value;

    champlain_marker_set_selectable($!cm, $v);
  }

  method set_selected (Int() $value) is also<set-selected> {
    my gboolean $v = $value;

    champlain_marker_set_selected($!cm, $v);
  }

  method set_selection_color (
    Champlain::Marker:U:
    ClutterColor() $color
  )
    is also<set-selection-color>
  {
    champlain_marker_set_selection_color($color);
  }

  method set_selection_text_color (
    Champlain::Marker:U:
    ClutterColor() $color
  )
    is also<set-selection-text-color>
  {
    champlain_marker_set_selection_text_color($color);
  }
}
