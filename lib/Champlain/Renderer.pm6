use v6.c;

use Method::Also;

use NativeCall;
use NativeHelpers::Blob;

use Champlain::Raw::Types;

use GLib::Roles::Object;

our subset ChamplainRendererAncestry is export of Mu
  where ChamplainRenderer | GObject;

class Champlain::Renderer {
  also does GLib::Roles::Object;

  has ChamplainRenderer $!cr is implementor;

  submethod BUILD (:$renderer) {
    self.setChamplainRenderer($renderer) if $renderer;
  }

  method setChamplainRenderer (ChamplainRendererAncestry $_) {
    my $to-parent;

    $!cr = do {
      when ChamplainRenderer {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainRenderer, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainRenderer
    is also<ChamplainRenderer>
  { $!cr }

  method new (ChamplainRendererAncestry $renderer, :$ref = True) {
    return Nil unless $renderer;

    my $o = self.bless( :$renderer );
    $o.ref if $ref;
    $o;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_renderer_get_type,
      $n,
      $t
    );
  }

  method render (ChamplainTile() $tile) {
    champlain_renderer_render($!cr, $tile);
  }

  proto method set_data (|)
      is also<set-data>
  { * }

  multi method set_data (@data) {
    samewith( ArrayToCArray(uint8, @data), @data.elems );
  }
  multi method set_data (Str $data, $size = $data.chars, :$encoding = 'utf-8') {
    samewith( $data.encode($encoding), $size );
  }
  multi method set_data (Buf $data, $size = $data.elems) {
    samewith( pointer-to($data), $data.elems );
  }
  multi method set_data (CArray[uint8] $data, $size = $data.elems) {
    samewith( pointer-to($data), $size );
  }
  multi method set_data (Pointer $data, Int() $size) {
    my guint $s = $size;

    champlain_renderer_set_data($!cr, $data, $s);
  }

}


### /usr/include/champlain-0.12/champlain/champlain-renderer.h

sub champlain_renderer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_renderer_render (
  ChamplainRenderer $renderer,
  ChamplainTile     $tile
)
  is native(champlain)
  is export
{ * }

sub champlain_renderer_set_data (
  ChamplainRenderer $renderer,
  Pointer           $data,
  guint             $size
)
  is native(champlain)
  is export
{ * }
