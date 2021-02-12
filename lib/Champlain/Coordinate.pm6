use v6.c;

use NativeCall;

use Champlain::Raw::Types;

use GLib::Roles::Object;
use Champlain::Roles::Location;

our subset ChamplainCoordinateAncestry is export of Mu
  where ChamplainCoordinate | GObject;

class Champlain::Coordinate {
  also does GLib::Roles::Object;
  also does Champlain::Roles::Location;

  has ChamplainCoordinate $!cc;

  submethod BUILD (:$coord) {
    self.setChamplainCoordinate($coord) if $coord;
  }

  method setChamplainCoordinate (ChamplainCoordinateAncestry $_) {
    my $to-parent;

    $!cc = do {
      when ChamplainCoordinate {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainCoordinate, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-ChamplainLocation;
  }

  method Champlain::Raw::Definitions::ChamplainCoordinate
  { $!cc }

  multi method new (ChamplainCoordinateAncestry $coord, :$ref = True) {
    return Nil unless $coord;

    my $o = self.bless( :$coord );
    $o.ref if $ref;
    $o
  }
  multi method new {
    my $coord = champlain_coordinate_new();

    $coord ?? self.bless( :$coord ) !! Nil;
  }

  method new_full (Num() $latitude, Num() $longitude) {
    my gdouble ($lat, $long) = ($latitude, $longitude);

    my $coord = champlain_coordinate_new_full($lat, $long);
    $coord ?? self.bless( :$coord ) !! Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_coordinate_get_type,
      $n,
      $t
    );
  }

}



### /usr/include/champlain-0.12/champlain/champlain-coordinate.h

sub champlain_coordinate_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_coordinate_new ()
  returns ChamplainCoordinate
  is native(champlain)
  is export
{ * }

sub champlain_coordinate_new_full (gdouble $latitude, gdouble $longitude)
  returns ChamplainCoordinate
  is native(champlain)
  is export
{ * }
