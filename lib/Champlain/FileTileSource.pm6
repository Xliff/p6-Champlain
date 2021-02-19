use v6.c;

use Method::Also;

use NativeCall;

use Champlain::Raw::Types;

use Champlain::TileSource;

our subset ChamplainFileTileSourceAncestry is export of Mu
  where ChamplainFileTileSource | ChamplainTileSourceAncestry;

class Champlain::FileTileSource is Champlain::TileSource {
  has ChamplainFileTileSource $!cfts;

  submethod BUILD (:$file-tile-source) {
    self.setChamplainFileTileSource($file-tile-source) if $file-tile-source;
  }

  method setChamplainFileTileSource(ChamplainFileTileSourceAncestry $_) {
    my $to-parent;

    $!cfts = do {
      when ChamplainFileTileSource {
        $to-parent = cast(ChamplainTileSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainFileTileSource, $_);
      }
    }
    self.setChamplainTileSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainFileTileSource
    is also<ChamplainFileTileSource>
  { $!cfts }

  method new (ChamplainFileTileSourceAncestry $file-tile-source, :$ref = True) {
    return Nil unless $file-tile-source;

    my $o = self.bless( :$file-tile-source );
    $o.ref if $ref;
    $o;
  }

  method load_map_data (Str() $map_path) {
    champlain_file_tile_source_load_map_data($!cfts, $map_path);
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

    my guint ($mnz, $mxz, $ts) = ($min_zoom, $max_zoom, $tile_size);
    my $file-tile-source = champlain_file_tile_source_new_full(
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

    $file-tile-source ?? self.bless( :$file-tile-source ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_file_tile_source_get_type,
      $n,
      $t
    );
  }

}


### /usr/include/champlain-0.12/champlain/champlain-file-tile-source.h

sub champlain_file_tile_source_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_file_tile_source_load_map_data (
  ChamplainFileTileSource $self,
  Str                     $map_path
)
  is native(champlain)
  is export
{ * }

sub champlain_file_tile_source_new_full (
  Str                    $id,
  Str                    $name,
  Str                    $license,
  Str                    $license_uri,
  guint                  $min_zoom,
  guint                  $max_zoom,
  guint                  $tile_size,
  ChamplainMapProjection $projection,
  ChamplainRenderer      $renderer
)
  returns ChamplainFileTileSource
  is native(champlain)
  is export
{ * }
