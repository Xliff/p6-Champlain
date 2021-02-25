use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::FileCache;

use Champlain::TileCache;

our subset ChamplainFileCacheAncestry is export of Mu
  where ChamplainFileCache | ChamplainTileCacheAncestry;

class Champlain::FileCache is Champlain::TileCache {
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
  )
    is also<new-full>
  {
    my guint $s = $size_limit;

    my $file-cache = champlain_file_cache_new_full($s, $cache_dir, $renderer);

    $file-cache ?? self.bless( :$file-cache ) !! Nil;
  }

  # Type: gchar
  method cache-dir is rw  is also<cache_dir> {
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

  method get_cache_dir is also<get-cache-dir> {
    champlain_file_cache_get_cache_dir($!cfc);
  }

  method get_size_limit is also<get-size-limit> {
    champlain_file_cache_get_size_limit($!cfc);
  }

  method get_type is also<get-type> {
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

  method purge_on_idle is also<purge-on-idle> {
    champlain_file_cache_purge_on_idle($!cfc);
  }

  method set_size_limit (Int() $size_limit) is also<set-size-limit> {
    my guint $s = $size_limit;

    champlain_file_cache_set_size_limit($!cfc, $s);
  }

}
