use v6.c;

use MONKEY-TYPING;

use Champlain::Raw::Types;
use Champlain::Raw::BoundingBox;

augment class ChamplainBoundingBox {

  method new {
    champlain_bounding_box_new();
  }

  method compose (ChamplainBoundingBox $other) {
    champlain_bounding_box_compose(self, $other);
  }

  method copy {
    champlain_bounding_box_copy(self);
  }

  method covers (Num() $latitude, Num() $longitude) {
    my ($lat, $long) = ($latitude, $longitude);

    so champlain_bounding_box_covers(self, $lat, $long);
  }

  method extend (Num() $latitude, Num() $longitude) {
    my ($lat, $long) = ($latitude, $longitude);

    so champlain_bounding_box_extend(self, $lat, $long);
  }

  method free {
    champlain_bounding_box_free(self);
  }

  proto method get_center (|)
  { * }

  multi method get_center {
    self.get_center($, $);
  }
  multi method get_center ($latitude is rw, $longitude is rw) {
    my ($lat, $long) = 0 xx 2;

    champlain_bounding_box_get_center(self, $lat, $long);
    ($latitude, $longitude) = ($lat, $long);
  }

  method get_type  {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_bounding_box_get_type,
      $n,
      $t
    )
  }

  method is_valid {
    so champlain_bounding_box_is_valid(self);
  }

}
