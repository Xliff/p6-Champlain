use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Roles::Pointers;

unit package Champlain::Raw::Definitions;

# Forced compile counter
constant forced = 0;

constant champlain     is export = 'champlain-0.12',v0;
constant champlain-gtk is export = 'champlain-gtk-0.12',v0;

class ChamplainCoordinate            is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainFileCache             is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainFileTileSource        is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLabel                 is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLayer                 is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLicense               is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLocation              is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMapSource             is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMarker                is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMarkerLayer           is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMemoryCache           is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMemphisRenderer       is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainNetworkBboxTileSource is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainNetworkTileSource     is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainNullTileSource        is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainPathLayer             is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainPoint                 is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainRenderer              is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainScale                 is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainTile                  is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainTileCache             is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainTileSource            is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainView                  is repr<CPointer> is export does GLib::Roles::Pointers { }

class GtkChamplainEmbed              is repr<CPointer> is export does GLib::Roles::Pointers { }

constant ChamplainMapProjection is export := guint32;
our enum ChamplainMapProjectionEnum is export <
  CHAMPLAIN_MAP_PROJECTION_MERCATOR
>;

constant ChamplainMemphisRuleType is export := guint32;
our enum ChamplainMemphisRuleEnum is export <
  CHAMPLAIN_MEMPHIS_RULE_TYPE_UNKNOWN
  CHAMPLAIN_MEMPHIS_RULE_TYPE_NODE
  CHAMPLAIN_MEMPHIS_RULE_TYPE_WAY
  CHAMPLAIN_MEMPHIS_RULE_TYPE_RELATION
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

class ChamplainMemphisRuleAttr is export is repr<CStruct> does GLib::Roles::Pointers {
  has guint8  $.z_min;
  has guint8  $.z_max;
  has guint8  $.color_red;
  has guint8  $.color_green;
  has guint8  $.color_blue;
  has guint8  $.color_alpha;
  has gchar   $.style;
  has gdouble $.size;

  method z-min is rw {
    Proxy.new:
      FETCH => -> $           { $!z_min },
      STORE => -> $, Int() \z { $!z_min = z }
  }

  method z-max is rw {
    Proxy.new:
      FETCH => -> $           { $!z_max },
      STORE => -> $, Int() \z { $!z_max = z }
  }

  method color_red is rw {
    Proxy.new:
      FETCH => -> $           { $!color_red },
      STORE => -> $, Int() \r { $!color_red = r }
  }

  method color_green is rw {
    Proxy.new:
      FETCH => -> $           { $!color_green },
      STORE => -> $, Int() \g { $!color_green = g }
  }

  method color_blue is rw {
    Proxy.new:
      FETCH => -> $           { $!color_blue },
      STORE => -> $, Int() \b { $!color_blue = b }
  }

  method color_alpha is rw {
    Proxy.new:
      FETCH => ->             { $!color_alpha },
      STORE => -> $, Int() \a { $!color_alpha = a }
  }

}

class ChamplainMemphisRule is export is repr<CStruct> does GLib::Roles::Pointers {
  # Write proxies for all attributes
  has CArray[Str]              $.keys    is rw;
  has CArray[Str]              $.values  is rw;
  has ChamplainMemphisRuleType $.type    is rw;
  has ChamplainMemphisRuleAttr $.polygon is rw;
  has ChamplainMemphisRuleAttr $.line    is rw;
  has ChamplainMemphisRuleAttr $.border  is rw;
  has ChamplainMemphisRuleAttr $.text    is rw;
}
