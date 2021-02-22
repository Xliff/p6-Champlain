use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Champlain::Raw::Definitions;

unit package Champlain::Raw::MapSourceFactory;

### /usr/include/champlain-0.12/champlain/champlain-map-source-factory.h

sub champlain_map_source_factory_create (
  ChamplainMapSourceFactory $factory,
  Str                       $id
)
  returns ChamplainMapSource
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_create_cached_source (
  ChamplainMapSourceFactory $factory,
  Str                       $id
)
  returns ChamplainMapSource
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_create_error_source (
  ChamplainMapSourceFactory $factory,
  guint                     $tile_size
)
  returns ChamplainMapSource
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_create_memcached_source (
  ChamplainMapSourceFactory $factory,
  Str                       $id
)
  returns ChamplainMapSource
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_dup_default ()
  returns ChamplainMapSourceFactory
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_get_registered (
  ChamplainMapSourceFactory $factory
)
  returns GSList
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_map_source_factory_register (
  ChamplainMapSourceFactory $factory,
  ChamplainMapSourceDesc    $desc
)
  returns uint32
  is native(champlain)
  is export
{ * }
