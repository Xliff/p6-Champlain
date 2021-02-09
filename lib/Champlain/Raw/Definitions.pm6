use v6.c;

use NativeCall;
use GLib::Raw::Definitions;

unit package Champlain::Raw::Definitions;

constant ChamplainMapProjection is export := guint32;
our enum ChamplainMapProjectionEnum is export <
  CHAMPLAIN_MAP_PROJECTION_MERCATOR
>;

constant ChamplainSelectionMode is export := guint32;
our enum ChamplainSelectionModeEnum is export <
  CHAMPLAIN_SELECTION_NONE
  CHAMPLAIN_SELECTION_SINGLE
  CHAMPLAIN_SELECTION_MULTIPLE
>;

constant ChamplainState is export := guint32;
our enum ChamplainStateEnum is export <
  CHAMPLAIN_STATE_NONE
  CHAMPLAIN_STATE_LOADING
  CHAMPLAIN_STATE_LOADED
  CHAMPLAIN_STATE_DONE
>;

constant ChamplainUnit is export := guint32;
our enum ChamplainUnitEnum is export <
  CHAMPLAIN_UNIT_KM
  CHAMPLAIN_UNIT_MILES
>;

class ChamplainBoundingBox is repr<CStruct> does GLib::Roles::Pointers {
  has gdouble $.left   is rw;
  has gdouble $.top    is rw;
  has gdouble $.right  is rw;
  has gdouble $.bottom is rw;
}
