use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::TileSource;

use Champlain::MapSource;
use Champlain::TileCache;

our subset ChamplainTileSourceAncestry is export of Mu
  where ChamplainTileSource | ChamplainMapSourceAncestry;

class Champlain::TileSource is Champlain::MapSource {
  has ChamplainTileSource $!cts is implementor;

  submethod BUILD (:$tile-source) {
    self.setChamplainTileSource($tile-source) if $tile-source;
  }

  method setChamplainTileSource (ChamplainTileSourceAncestry $_) {
    my $to-parent;

    $!cts = do {
      when ChamplainTileSource {
        $to-parent = cast(ChamplainMapSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainTileSource, $_);
      }
    }
    self.setChamplainMapSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainTileSource
    is also<ChamplainTileSource>
  { $!cts }

  multi method new (ChamplainTileSourceAncestry $tile-source, :$ref = True) {
    return Nil unless $tile-source;

    my $o = self.bless( :$tile-source );
    $o.ref if $ref;
    $o
  }

  # Type: ChamplainTileCache
  method cache (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Champlain::TileCache.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('cache', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ChamplainTileCache,
          Champlain::TileCache
        );
      },
      STORE => -> $, ChamplainTileCache() $val is copy {
        $gv.object = $val;
        self.prop_set('cache', $gv);
      }
    );
  }

  # Type: gchar
  method id is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('id', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'id is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method license is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('license', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'license is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method license-uri is rw  is also<license_uri> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('license-uri', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'license-uri is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method max-zoom-level is rw  is also<max_zoom_level> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'max-zoom-level is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method min-zoom-level is rw  is also<min_zoom_level> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'min-zoom-level is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method name is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'name is a construct-only attribute'
      }
    );
  }

  # Type: ChamplainMapProjection
  method projection is rw  {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(ChamplainMapProjection) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('projection', $gv)
        );
        ChamplainMapProjectionEnum(
          $gv.valueFromEnum(ChamplainMapProjection)
        )
      },
      STORE => -> $, $val is copy {
        warn 'projection is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method tile-size is rw  is also<tile_size> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tile-size', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'tile-size is a construct-only attribute'
      }
    );
  }

  # Transfer: none
  method get_cache (:$raw = False) is also<get-cache> {
    my $tc = champlain_tile_source_get_cache($!cts);

    $tc ??
      ( $raw ?? $tc !! Champlain::TileCache.new($tc) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      ^champlain_tile_source_get_type,
      $n,
      $t
    );
  }

  method set_cache (ChamplainTileCache() $cache) is also<set-cache> {
    champlain_tile_source_set_cache($!cts, $cache);
  }

  method set_id (Str() $id) is also<set-id> {
    champlain_tile_source_set_id($!cts, $id);
  }

  method set_license (Str() $license) is also<set-license> {
    champlain_tile_source_set_license($!cts, $license);
  }

  method set_license_uri (Str() $license_uri) is also<set-license-uri> {
    champlain_tile_source_set_license_uri($!cts, $license_uri);
  }

  method set_max_zoom_level (Int() $zoom_level) is also<set-max-zoom-level> {
    my guint $z = $zoom_level;

    champlain_tile_source_set_max_zoom_level($!cts, $z);
  }

  method set_min_zoom_level (Int() $zoom_level) is also<set-min-zoom-level> {
    my guint $z = $zoom_level;

    champlain_tile_source_set_min_zoom_level($!cts, $z);
  }

  method set_name (Str() $name) is also<set-name> {
    champlain_tile_source_set_name($!cts, $name);
  }

  method set_projection (Int() $projection) is also<set-projection> {
    my ChamplainMapProjection $p = $projection;

    champlain_tile_source_set_projection($!cts, $p);
  }

  method set_tile_size (Int() $tile_size) is also<set-tile-size> {
    my guint $t = $tile_size;

    champlain_tile_source_set_tile_size($!cts, $t);
  }

}
