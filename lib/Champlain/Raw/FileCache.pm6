use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::FileCache;

### /usr/include/champlain-0.12/champlain/champlain-file-cache.h

sub champlain_file_cache_get_cache_dir (ChamplainFileCache $file_cache)
  returns Str
  is native(champlain)
  is export
{ * }

sub champlain_file_cache_get_size_limit (ChamplainFileCache $file_cache)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_file_cache_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_file_cache_new_full (
  guint             $size_limit,
  Str               $cache_dir,
  ChamplainRenderer $renderer
)
  returns ChamplainFileCache
  is native(champlain)
  is export
{ * }

sub champlain_file_cache_purge (ChamplainFileCache $file_cache)
  is native(champlain)
  is export
{ * }

sub champlain_file_cache_purge_on_idle (ChamplainFileCache $file_cache)
  is native(champlain)
  is export
{ * }

sub champlain_file_cache_set_size_limit (
  ChamplainFileCache $file_cache,
  guint              $size_limit
)
  is native(champlain)
  is export
{ * }
