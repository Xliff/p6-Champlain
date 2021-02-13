use v6.c;

use Method::Also;

use NativeCall;
use NativeHelpers::Blob;

use Champlain::Raw::Types;

use GLib::Roles::Object;

class Champlain::Renderer {
  also does GLib::Roles::Object;

  has ChamplainRenderer $!cr is implementor;

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
  multi method set_data (Pointer $data, guint $size) {
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
