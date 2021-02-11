use v6.c;

use NativeCall;

use Champlain::Raw::Types;

role Champlain::Roles::Location {
  has ChamplainLocation $!cl;

  method get_latitude {
    champlain_location_get_latitude($!cl);
  }

  method get_longitude {
    champlain_location_get_longitude($!cl);
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
    my Num ($lat, $long) = ($latitude, $longitude);

    champlain_location_set_location($!cl, $lat, $long);
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
