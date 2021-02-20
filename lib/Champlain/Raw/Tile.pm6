use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Clutter::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::Tile;

### /usr/include/champlain-0.12/champlain/champlain-tile.h

sub champlain_tile_display_content (ChamplainTile $self)
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_content (ChamplainTile $self)
  returns ClutterActor
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_etag (ChamplainTile $self)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_fade_in (ChamplainTile $self)
  returns uint32
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_modified_time (ChamplainTile $self)
  returns GTimeVal
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_size (ChamplainTile $self)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_state (ChamplainTile $self)
  returns ChamplainState
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_x (ChamplainTile $self)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_y (ChamplainTile $self)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_tile_get_zoom_level (ChamplainTile $self)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_tile_new ()
  returns ChamplainTile
  is native(champlain)
  is export
{ * }

sub champlain_tile_new_full (guint $x, guint $y, guint $size, guint $zoom_level)
  returns ChamplainTile
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_content (ChamplainTile $self, ClutterActor $actor)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_etag (ChamplainTile $self, Str $etag)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_fade_in (ChamplainTile $self, gboolean $fade_in)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_modified_time (ChamplainTile $self, GTimeVal $time)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_size (ChamplainTile $self, guint $size)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_state (ChamplainTile $self, ChamplainState $state)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_x (ChamplainTile $self, guint $x)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_y (ChamplainTile $self, guint $y)
  is native(champlain)
  is export
{ * }

sub champlain_tile_set_zoom_level (ChamplainTile $self, guint $zoom_level)
  is native(champlain)
  is export
{ * }
