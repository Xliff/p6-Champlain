use v6.c;

use Method::Also;

use NativeCall;

use Champlain::Raw::Types;
use Champlain::Raw::NetworkBBoxTileSource;

use Champlain::TileSource;

our subset ChamplainNetworkBBoxTileSourceAncestry is export of Mu
  where ChamplainNetworkBBoxTileSource | ChamplainTileSourceAncestry;

class Champlain::NetworkBBoxTileSource is Champlain::TileSource {
  has ChamplainNetworkBBoxTileSource $!cnbts;

  submethod BUILD (:$bbox-tile-source) {
    self.setChamplainNetworkBBoxTileSource($bbox-tile-source)
      if $bbox-tile-source;
  }

  method setChamplainNetworkBBoxTileSource(
    ChamplainNetworkBBoxTileSourceAncestry $_
  ) {
    my $to-parent;

    $!cnbts = do {
      when ChamplainNetworkBBoxTileSource {
        $to-parent = cast(ChamplainTileSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainNetworkBBoxTileSource, $_);
      }
    }
    self.setChamplainTileSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainNetworkBBoxTileSource
    is also<ChamplainNetworkBBoxTileSource>
  { $!cnbts }

  method new (
    ChamplainNetworkBBoxTileSourceAncestry $bbox-tile-source,
                                           :$ref             = True
  ) {
    return Nil unless $bbox-tile-source;

    my $o = self.bless( :$bbox-tile-source );
    $o.ref if $ref;
    $o;
  }

  method new_full (
    Str()               $id,
    Str()               $name,
    Str()               $license,
    Str()               $license_uri,
    Int()               $min_zoom,
    Int()               $max_zoom,
    Int()               $tile_size,
    Int()               $projection,
    ChamplainRenderer() $renderer
 ) {
    my ChamplainMapProjection $p = $projection;

    my guint($mnz, $mxz, $ts) = ($min_zoom, $max_zoom, $tile_size);
    my $bbox-tile-source = champlain_network_bbox_tile_source_new_full(
      $id,
      $name,
      $license,
      $license_uri,
      $mnz,
      $mxz,
      $ts,
      $p,
      $renderer
    );

    $bbox-tile-source ?? self.bless( :$bbox-tile-source ) !! Nil;
  }

  method load_map_data (Str() $map_path) {
    champlain_network_bbox_tile_source_load_map_data($!cnbts, $map_path);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_network_bbox_tile_source_get_type,
      $n,
      $t
    );
  }

}
