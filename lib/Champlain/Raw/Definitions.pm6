use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Subs;
use GLib::Raw::Structs;
use GLib::Roles::Pointers;

unit package Champlain::Raw::Definitions;

# Forced compile counter
constant forced = 186;

constant CHAMPLAIN_MAP_SOURCE_OSM_OSMARENDER    is export = 'osm-osmarender';
constant CHAMPLAIN_MAP_SOURCE_OAM               is export = 'OpenAerialMap';
constant CHAMPLAIN_MAP_SOURCE_OSM_MAPQUEST      is export = 'osm-mapquest';
constant CHAMPLAIN_MAP_SOURCE_OSM_AERIAL_MAP    is export = 'osm-aerialmap';
constant CHAMPLAIN_MAP_SOURCE_OSM_MAPNIK        is export = 'osm-mapnik';
constant CHAMPLAIN_MAP_SOURCE_OSM_CYCLE_MAP     is export = 'osm-cyclemap';
constant CHAMPLAIN_MAP_SOURCE_OSM_TRANSPORT_MAP is export = 'osm-transportmap';
constant CHAMPLAIN_MAP_SOURCE_MFF_RELIEF        is export = 'mff-relief';
constant CHAMPLAIN_MAP_SOURCE_OWM_CLOUDS        is export = 'owm-clouds';
constant CHAMPLAIN_MAP_SOURCE_OWM_PRECIPITATION is export = 'owm-precipitation';
constant CHAMPLAIN_MAP_SOURCE_OWM_PRESSURE      is export = 'owm-pressure';
constant CHAMPLAIN_MAP_SOURCE_OWM_WIND          is export = 'owm-wind';
constant CHAMPLAIN_MAP_SOURCE_OWM_TEMPERATURE   is export = 'owm-temperature';
constant CHAMPLAIN_MAP_SOURCE_MEMPHIS_LOCAL     is export = 'memphis-local';
constant CHAMPLAIN_MAP_SOURCE_MEMPHIS_NETWORK   is export = 'memphis-network';

constant champlain     is export = 'champlain-0.12',v0;
constant champlain-gtk is export = 'champlain-gtk-0.12',v0;

class ChamplainCoordinate            is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainErrorTileRenderer     is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainFileCache             is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainFileTileSource        is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainImageRenderer         is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLabel                 is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLayer                 is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLicense               is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainLocation              is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMapSource             is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMapSourceChain        is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMapSourceDesc         is repr<CPointer> is export does GLib::Roles::Pointers { }
class ChamplainMapSourceFactory      is repr<CPointer> is export does GLib::Roles::Pointers { }
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
      STORE => -> $, Int() \z { $!z_min = z };
  }

  method z-max is rw {
    Proxy.new:
      FETCH => -> $           { $!z_max },
      STORE => -> $, Int() \z { $!z_max = z };
  }

  method color_red is rw {
    Proxy.new:
      FETCH => -> $           { $!color_red },
      STORE => -> $, Int() \r { $!color_red = r };
  }

  method color_green is rw {
    Proxy.new:
      FETCH => -> $           { $!color_green },
      STORE => -> $, Int() \g { $!color_green = g };
  }

  method color_blue is rw {
    Proxy.new:
      FETCH => -> $           { $!color_blue },
      STORE => -> $, Int() \b { $!color_blue = b };
  }

  method color_alpha is rw {
    Proxy.new:
      FETCH => ->             { $!color_alpha },
      STORE => -> $, Int() \a { $!color_alpha = a };
  }

}

class ChamplainMemphisRule is export is repr<CStruct> does GLib::Roles::Pointers {
  # Write proxies for all attributes
  has CArray[Str]              $!keys;
  has CArray[Str]              $!values;
  has ChamplainMemphisRuleType $.type     is rw;
  has ChamplainMemphisRuleAttr $!polygon;
  has ChamplainMemphisRuleAttr $!line;
  has ChamplainMemphisRuleAttr $!border;
  has ChamplainMemphisRuleAttr $!text;

  method keys is rw {
    Proxy.new:
      FETCH => -> $          { $!keys },
      STORE => -> $, $newVal {
        my $to-bind;

        given $newVal {
          when Positional  { $to-bind = ArrayToCArray(Str, $newVal) }
          when CArray[Str] { $to-bind = $_ }

          default {
            die "Impossible to bind a { .^name } to {
                 &*ROUTINE.^name } as it only takes values acceptible to
                 a CArray[Str]";
          }
        }

        $!keys := $to-bind;
      }
  }

  method values is rw {
    Proxy.new:
      FETCH => -> $          { $!values },
      STORE => -> $, $newVal {
        my $to-bind;

        given $newVal {
          when Positional  { $to-bind = ArrayToCArray(Str, $newVal) }
          when CArray[Str] { $to-bind = $_ }

          default {
            die "Impossible to bind a { .^name } to {
                 &*ROUTINE.^name } as it only takes values acceptible to
                 a CArray[Str]";
          }
        }

        $!values := $to-bind;
      }
  }

  method polygon is rw {
    Proxy.new:
      FETCH => -> $  { $!polygon },
      STORE => -> $, ChamplainMemphisRuleAttr() $newVal {
        $!polygon := $newVal;
      };
  }

  method line is rw {
    Proxy.new:
      FETCH => -> $  { $!line },
      STORE => -> $, ChamplainMemphisRuleAttr() $newVal {
        $!line := $newVal;
      };
  }

  method border is rw {
    Proxy.new:
      FETCH => -> $  { $!border },
      STORE => -> $, ChamplainMemphisRuleAttr() $newVal {
        $!border := $newVal;
      };
  }

  method text is rw {
    Proxy.new:
      FETCH => -> $  { $!text },
      STORE => -> $, ChamplainMemphisRuleAttr() $newVal {
        $!text := $newVal;
      };
  }

  # cw: Currently, this CANNOT be used, but the definition is here to
  #     mark intent. The reason this cannot be used is that we need
  #     a per-instance tracking method to denote whether it was
  #     C or Raku allocated. Raku allocated structs do not need to be free'd
  #     REPR CStrut classes *cannot* take on non-C members, so any such
  #     tracking structure would need to be external. It would also have to
  #     have its own allocation and marking mechanisms.  As of this writing,
  #     the only shoultion would be to mark all C-based instances by
  #     running them in a function, ala:
  #       c-allocated(ChamplainMemphisRule, $instance)
  #
  #     This would have to be run on ALL c-allocated ChamplainMemphisRule
  #     instances or a crash is likely at GC-time. Typically I would
  #     prefer the API do more work than the code, which is why find this
  #     solution suboptimal.
  #
  # submethod DESTROY {
  #   free(self);
  # }
}