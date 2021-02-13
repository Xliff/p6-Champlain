use v6.c;

use NativeCall;

use Champlain::Raw::Types;

use Champlain::MapSource;

our subset ChamplainTileCacheAncestry is export of Mu
  where ChamplainTileCache | ChamplainMapSourceAncestry;

class Champlain::TileCache is Champlain::MapSource {
  has ChamplainTileCache $!ctc is implementor;

  submethod BUILD (:$tile-cache) {
    self.setChamplainTileCache($tile-cache) if $tile-cache;
  }

  method setChamplainTileCache (ChamplainTileCacheAncestry $_) {
    my $to-parent;

    $!ctc = do {
      when ChamplainTileCache {
        $to-parent = cast(ChamplainMapSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainTileCache, $_);
      }
    }
    self.setChamplainMapSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainTileCache
  { $!ctc }

  multi method new (ChamplainTileCacheAncestry $tile-cache, :$ref = True) {
    return Nil unless $tile-cache;

    my $o = self.bless( :$tile-cache );
    $o.ref if $ref;
    $o
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_tile_cache_get_type,
      $n,
      $t
    );
  }

  method on_tile_filled (ChamplainTile() $tile) {
    champlain_tile_cache_on_tile_filled($!ctc, $tile);
  }

  method refresh_tile_time (ChamplainTile() $tile) {
    champlain_tile_cache_refresh_tile_time($!ctc, $tile);
  }

  method store_tile (ChamplainTile() $tile, Str() $contents, Int() $size) {
    my gsize $s = $size;

    champlain_tile_cache_store_tile($!ctc, $tile, $contents, $s);
  }


}


### /usr/include/champlain-0.12/champlain/champlain-tile-cache.h

sub champlain_tile_cache_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_tile_cache_on_tile_filled (
  ChamplainTileCache $tile_cache,
  ChamplainTile      $tile
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_cache_refresh_tile_time (
  ChamplainTileCache $tile_cache,
  ChamplainTile      $tile
)
  is native(champlain)
  is export
{ * }

sub champlain_tile_cache_store_tile (
  ChamplainTileCache $tile_cache,
  ChamplainTile      $tile, 
  Str                $contents, 
  gsize              $size
)
  is native(champlain)
  is export
{ * }
