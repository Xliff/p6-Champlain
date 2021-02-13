use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::Point;

use Champlain::Marker;

our subset ChamplainPointAncestry is export of Mu
  where ChamplainPoint | ChamplainMarkerAncestry;

class Champlain::Point is Champlain::Marker {
  has ChamplainPoint $!cp is implementor;

  submethod BUILD (:$point) {
    self.setChamplainPoint($point) if $point;
  }

  method setChamplainPoint(ChamplainPointAncestry $_) {
    my $to-parent;

    $!cp = do {
      when ChamplainPoint {
        $to-parent = cast(ChamplainPoint, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainPoint, $_);
      }
    }
    self.setChamplainPoint($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainPoint
    is also<ChamplainPoint>
  { $!cp }

  multi method new (ChamplainPointAncestry $point, :$ref = True) {
    return Nil unless $point;

    my $o = self.bless( :$point );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $point = champlain_point_new();

    $point ?? self.bless( :$point ) !! Nil;
  }

  method new_full (Num() $size, ClutterColor() $color) is also<new-full> {
    my gdouble $s = $size;

    champlain_point_new_full($!cp, $size, $color);
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
        );
      },
      STORE => -> $, ClutterColor() $val is copy {
        $gv.object = $val;
        self.prop_set('color', $gv);
      }
    );
  }

  # Type: gdouble
  method size is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('size', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('size', $gv);
      }
    );
  }

  method get_color (:$raw = False) is also<get-color> {
    my $cc = champlain_point_get_color($!cp);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_size is also<get-size> {
    champlain_point_get_size($!cp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_point_get_type,
      $n,
      $t
    );
  }

  method set_color (ClutterColor() $color) is also<set-color> {
    champlain_point_set_color($!cp, $color);
  }

  method set_size (Num() $size) is also<set-size> {
    my gdouble $s = $size;

    champlain_point_set_size($!cp, $s);
  }

}
