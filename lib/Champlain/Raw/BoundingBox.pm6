use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::BoundingBox;

### /usr/include/champlain-0.12/champlain/champlain-bounding-box.h

sub champlain_bounding_box_compose (
  ChamplainBoundingBox $bbox,
  ChamplainBoundingBox $other
)
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_copy (ChamplainBoundingBox $bbox)
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_covers (
  ChamplainBoundingBox $bbox,
  gdouble              $latitude,
  gdouble              $longitude
)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_extend (
  ChamplainBoundingBox $bbox,
  gdouble              $latitude,
  gdouble              $longitude
)
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_free (ChamplainBoundingBox $bbox)
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_get_center (
  ChamplainBoundingBox $bbox,
  gdouble              $latitude  is rw,
  gdouble              $longitude is rw
)
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_is_valid (ChamplainBoundingBox $bbox)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_bounding_box_new ()
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }
