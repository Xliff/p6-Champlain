use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Clutter::Raw::Structs;
use Champlain::Raw::Definitions;

### /usr/include/champlain-0.12/champlain/champlain-memphis-renderer.h

sub champlain_memphis_renderer_get_background_color (
  ChamplainMemphisRenderer $renderer
)
  returns ClutterColor
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_get_bounding_box (
  ChamplainMemphisRenderer $renderer
)
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_get_rule (
  ChamplainMemphisRenderer $renderer,
  Str                      $id
)
  returns ChamplainMemphisRule
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_get_rule_ids (ChamplainMemphisRenderer $renderer)
  returns GList
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_get_tile_size (
  ChamplainMemphisRenderer $renderer
)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_load_rules (
  ChamplainMemphisRenderer $renderer,
  Str                      $rules_path
)
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_new_full (guint $tile_size)
  returns ChamplainMemphisRenderer
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_remove_rule (
  ChamplainMemphisRenderer $renderer,
  Str                      $id
)
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_set_background_color (
  ChamplainMemphisRenderer $renderer,
  ClutterColor             $color
)
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_set_rule (
  ChamplainMemphisRenderer $renderer,
  ChamplainMemphisRule     $rule
)
  is native(champlain)
  is export
{ * }

sub champlain_memphis_renderer_set_tile_size (
  ChamplainMemphisRenderer $renderer,
  guint                    $size
)
  is native(champlain)
  is export
{ * }
