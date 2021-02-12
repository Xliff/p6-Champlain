use v6.c;

use NativeCall;

use GLib::Raw::Definitions;

use GLib::Roles::Pointers;

unit package Champlain::Raw::Definitions;

# Forced compile counter
constant forced = 0;

constant champlain is export = 'champlain-0.12',v0;

class ChamplainCoordinate  is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLayer       is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLocation    is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMapSource   is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMarker      is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMarkerLayer is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainPathLayer   is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainPoint       is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainRenderer    is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainTile        is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainView        is repr<CPointer> is export does GLib::Roles::Pointers { }

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

class ChamplainBoundingBox is export is repr<CStruct> does GLib::Roles::Pointers {
  has gdouble $.left   is rw;
  has gdouble $.top    is rw;
  has gdouble $.right  is rw;
  has gdouble $.bottom is rw;
}
