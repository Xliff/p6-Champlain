use v6.c;

use NativeCall;

use Champlain::Raw::Types;

role Champlain::Roles::Location {
  has ChamplainLocation $!cl;

  method roleInit-ChamplainLocation {
    my \i = findProperImplementor(self.^attributes);

    $!cl = cast( ChamplainLocation, i.get_value(self) );
  }

  method Champlain::Raw::Definitions::ChamplainLocation
  { $!cl }
  method ChamplainLocation
  { $!cl }

  method get_latitude {
    champlain_location_get_latitude($!cl);
  }

  method get_longitude {
    champlain_location_get_longitude($!cl);
  }

  method getLocation {
    (
      self.get_latitude,
      self.get_longitude
    );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_location_get_type,
      $n,
      $t
    );
  }

  method set_location (Num() $latitude, Num() $longitude) {
    my gdouble ($lat, $long) = ($latitude, $longitude);

    champlain_location_set_location($!cl, $lat, $long);
  }

}


use GLib::Roles::Object;

our subset ChamplainLocationAncestry is export of Mu
  where ChamplainLocation | GObject;

class Champlain::Location {
  also does GLib::Roles::Object;
  also does Champlain::Roles::Location;

  submethod BUILD (:$location) {
    self.setChamplainLocation($location) if $location;
  }

  method setChamplainLocation (ChamplainLocationAncestry $_) {
    my $to-parent;

    $!cl = do {
      when ChamplainLocation {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainLocation, $_);
      }
    }
    self!setObject($to-parent);
  }

  method new (ChamplainLocationAncestry $location, :$ref = True) {
    return Nil unless $location;

    my $o = self.bless( :$location );
    $o.ref if $ref;
    $o;
  }

}

### /usr/include/champlain-0.12/champlain/champlain-location.h

sub champlain_location_get_latitude (ChamplainLocation $location)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_location_get_longitude (ChamplainLocation $location)
  returns gdouble
  is native(champlain)
  is export
{ * }

sub champlain_location_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_location_set_location (
  ChamplainLocation $location,
  gdouble           $latitude,
  gdouble           $longitude
)
  is native(champlain)
  is export
{ * }
