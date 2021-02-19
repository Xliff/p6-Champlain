use v6.c;

use Champlain::Raw::Types;
use Champlain::FileCache;

use Champlain::FileCache;

our subset ChamplainFileCacheAncestry is export of Mu
  where ChamplainFileCache | ChamplainTileCacheAncestry;

class Champlain::FileCache is Champlain::FileCache {
  has ChamplainFileCache $!cfc is implementor;

  submethod BUILD (:$file-cache) {
    self.setChamplainFileCache($file-cache) if $file-cache;
  }

  method setChamplainFileCache (ChamplainFileCacheAncestry $_) {
    my $to-parent;

    $!cfc = do {
      when ChamplainFileCache {
        $to-parent = cast(ChamplainTileCache, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainFileCache, $_);
      }
    }
    self.setChamplainTileCache($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainFileCache
    is also<ChamplainFileCache>
  { $!cfc }

  multi method new (ChamplainFileCacheAncestry $file-cache, :$ref = True) {
    return Nil unless $file-cache;

    my $o = self.bless( :$file-cache );
    $o.ref if $ref;
    $o
  }

  method new_full (
    Int()               $size_limit,
    Str()               $cache_dir,
    ChamplainRenderer() $renderer
  ) {
    my guint $s = $size_limit;

    my $file-cache = champlain_file_cache_new_full($s, $cache_dir, $renderer);

    $file-cache ?? self.bless( :$file-cache ) !! Nil;
  }

  # Type: gchar
  method cache-dir is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('cache-dir', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'cache-dir is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method size-limit is rw  {
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

  method get_cache_dir {
    champlain_file_cache_get_cache_dir($!cfc);
  }

  method get_size_limit {
    champlain_file_cache_get_size_limit($!cfc);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_file_cache_get_type,
      $n,
      $t
    );
  }

  method purge {
    champlain_file_cache_purge($!cfc);
  }

  method purge_on_idle {
    champlain_file_cache_purge_on_idle($!cfc);
  }

  method set_size_limit (Int() $size_limit) {
    my guint $s = $size_limit;

    champlain_file_cache_set_size_limit($!cfc, $s);
  }

}
