use v6.c;

use Method::Also;

use NativeCall;

use Champlain::Raw::Types;

use Champlain::TileCache;

our subset ChamplainMemoryCacheAncestry is export of Mu
  where ChamplainMemoryCache | ChamplainTileCacheAncestry;

class Champlain::MemoryCache is Champlain::TileCache {
  has ChamplainMemoryCache $!cmc;

  submethod BUILD (:$memory-cache) {
    self.setChamplainMemoryCache($memory-cache) if $memory-cache;
  }

  method setChamplainMemoryCache (ChamplainMemoryCacheAncestry $_) {
    my $to-parent;

    $!cmc = do {
      when ChamplainMemoryCache {
        $to-parent = cast(ChamplainTileCache, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMemoryCache, $_);
      }
    }
    self.setChamplainTileCache($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMemoryCache
    is also<ChamplainMemoryCache>
  { $!cmc }

  multi method new (ChamplainMemoryCacheAncestry $memory-cache, :$ref = True) {
    return Nil unless $memory-cache;

    my $o = self.bless( :$memory-cache );
    $o.ref if $ref;
    $o
  }

  method new_full (Int() $size_limit, ChamplainRenderer() $renderer)
    is also<new-full>
  {
    my guint $s = $size_limit;

    my $memory-cache = champlain_memory_cache_new_full($size_limit, $renderer);

    $memory-cache ?? self.bless( :$memory-cache ) !! Nil;
  }

  # Type: guint
  method size-limit is rw  is also<size_limit> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('size-limit', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'size-limit is a construct-only attribute'
      }
    );
  }

  method clean {
    champlain_memory_cache_clean($!cmc);
  }

  method get_size_limit is also<get-size-limit> {
    champlain_memory_cache_get_size_limit($!cmc);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_memory_cache_get_type,
      $n,
      $t
    );
  }

  method set_size_limit (Int() $size_limit) is also<set-size-limit> {
    my guint $s = $size_limit;

    champlain_memory_cache_set_size_limit($!cmc, $s);
  }

}


### /usr/include/champlain-0.12/champlain/champlain-memory-cache.h

sub champlain_memory_cache_clean (ChamplainMemoryCache $memory_cache)
  is native(champlain)
  is export
{ * }

sub champlain_memory_cache_get_size_limit (ChamplainMemoryCache $memory_cache)
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_memory_cache_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_memory_cache_new_full (
  guint             $size_limit,
  ChamplainRenderer $renderer
)
  returns ChamplainMemoryCache
  is native(champlain)
  is export
{ * }

sub champlain_memory_cache_set_size_limit (
  ChamplainMemoryCache $memory_cache,
  guint                $size_limit
)
  is native(champlain)
  is export
{ * }
