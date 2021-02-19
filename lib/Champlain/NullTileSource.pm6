use v6.c;

use Method::Also;

use NativeCall;

use Champlain::Raw::Types;

use Champlain::TileSource;

our subset ChamplainNullTileSourceAncestry is export of Mu
  where ChamplainNullTileSource | ChamplainTileSourceAncestry;

class Champlain::NullTileSource is Champlain::TileSource {
  has ChamplainNullTileSource $!cnts;

  submethod BUILD (:$null-tile-source) {
    self.setChamplainNullTileSource($null-tile-source) if $null-tile-source;
  }

  method setChamplainNullTileSource(ChamplainNullTileSourceAncestry $_) {
    my $to-parent;

    $!cnts = do {
      when ChamplainNullTileSource {
        $to-parent = cast(ChamplainTileSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainNullTileSource, $_);
      }
    }
    self.setChamplainTileSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainNullTileSource
    is also<ChamplainNullTileSource>
  { $!cnts }

  method new (ChamplainNullTileSourceAncestry $null-tile-source, :$ref = True) {
    return Nil unless $null-tile-source;

    my $o = self.bless( :$null-tile-source );
    $o.ref if $ref;
    $o;
  }

  method new_full (ChamplainRenderer() $renderer) is also<new-full> {
    my $null-tile-source = champlain_null_tile_source_new_full($renderer);

    $null-tile-source ?? self.bless( :$null-tile-source ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_null_tile_source_get_type,
      $n,
      $t
    );
  }

}

### /usr/include/champlain-0.12/champlain/champlain-null-tile-source.h

sub champlain_null_tile_source_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_null_tile_source_new_full (ChamplainRenderer $renderer)
  returns ChamplainNullTileSource
  is native(champlain)
  is export
{ * }
