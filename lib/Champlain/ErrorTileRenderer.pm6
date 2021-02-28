use v6.c;

use NativeCall;

use Champlain::Raw::Types;

our subset ChamplainErrorTileRendererAncestry is export of Mu
  where ChamplainErrorTileRenderer | ChamplainRendererAncestry;

class Champlain::ErrorTileRenderer is Champlain::Renderer {
  has ChamplainErrorTileRenderer $!cetr;

  submethod BUILD (:$error-renderer) {
    self.setChamplainErrorTileRenderer($error-renderer) if $error-renderer;
  }

  method setChamplainErrorTileRenderer (ChamplainErrorTileRendererAncestry $_) {
    my $to-parent;

    $!cetr = do {
      when ChamplainErrorTileRenderer {
        $to-parent = cast(ChamplainRenderer, $to-parent);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainErrorTileRenderer, $_);
      }
    }
    self.setChamplainRenderer($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainErrorTileRenderer
  { $!cetr }

  multi method new (
    ChamplainErrorTileRendererAncestry $error-renderer,
                                   :$ref           = True
  ) {
    return Nil unless $error-renderer;

    my $o = self.bless( :$error-renderer );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $error-tiles = champlain_error_tile_renderer_new();

    $error-tiles ?? self.bless( :$error-tiles ) !! Nil;
  }

  method get_tile_size {
    champlain_error_tile_renderer_get_tile_size($!cetr);
  }

  method get_type {
    unstable_get_type(
      state ($n, $t);

      unstable_get_type(
        self.^name,
        champlain_error_tile_renderer_get_type,
        $n,
        $t
      );
  }

  method set_tile_size (Int() $size) {
    my guint $s = $size;

    champlain_error_tile_renderer_set_tile_size($!cetr, $s);
  }
}

### /usr/include/champlain-0.12/champlain/champlain-error-tile-renderer.h

sub champlain_error_tile_renderer_get_tile_size (
  ChamplainErrorTileRenderer $renderer)
(
  returns guint
  is native(champlain)
  is export
{ * }

sub champlain_error_tile_renderer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_error_tile_renderer_new (guint $tile_size)
  returns ChamplainErrorTileRenderer
  is native(champlain)
  is export
{ * }

sub champlain_error_tile_renderer_set_tile_size (
  ChamplainErrorTileRenderer $renderer,
  guint                      $size
)
  is native(champlain)
  is export
{ * }
