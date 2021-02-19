use v6.c;

use Method::Also;

use NativeCall;

use Champlain::Raw::Types;
use Champlain::Raw::NetworkBboxTileSource;

use Champlain::TileSource;

our subset ChamplainNetworkBboxTileSourceAncestry is export of Mu
  where ChamplainNetworkBboxTileSource | ChamplainTileSourceAncestry;

class Champlain::NetworkBboxTileSource is Champlain::TileSource {
  has ChamplainNetworkBboxTileSource $!cnbts;

  submethod BUILD (:$Bbox-tile-source) {
    self.setChamplainNetworkBboxTileSource($Bbox-tile-source)
      if $Bbox-tile-source;
  }

  method setChamplainNetworkBboxTileSource(
    ChamplainNetworkBboxTileSourceAncestry $_
  ) {
    my $to-parent;

    $!cnbts = do {
      when ChamplainNetworkBboxTileSource {
        $to-parent = cast(ChamplainTileSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainNetworkBboxTileSource, $_);
      }
    }
    self.setChamplainTileSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainNetworkBboxTileSource
    is also<ChamplainNetworkBboxTileSource>
  { $!cnbts }

  method new (
    ChamplainNetworkBboxTileSourceAncestry $Bbox-tile-source,
                                           :$ref             = True
  ) {
    return Nil unless $Bbox-tile-source;

    my $o = self.bless( :$Bbox-tile-source );
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
    my $Bbox-tile-source = champlain_network_Bbox_tile_source_new_full(
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

    $Bbox-tile-source ?? self.bless( :$Bbox-tile-source ) !! Nil;
  }

  method load_map_data (Str() $map_path) {
    champlain_network_Bbox_tile_source_load_map_data($!cnbts, $map_path);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_network_Bbox_tile_source_get_type,
      $n,
      $t
    );
  }

}
