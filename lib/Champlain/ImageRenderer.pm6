use v6.c;

use NativeCall;

use Champlain::Raw::Types;

use Champlain::Renderer;

our subset ChamplainImageRendererAncestry is export of Mu
  where ChamplainImageRenderer | ChamplainRendererAncestry;

class Champlain::ImageRenderer is Champlain::Renderer {
  has ChamplainImageRenderer $!cir;

  submethod BUILD (:$image-renderer) {
    self.setChamplainImageRenderer($image-renderer) if $image-renderer;
  }

  method setChamplainImageRenderer (ChamplainImageRendererAncestry $_) {
    my $to-parent;

    $!cir = do {
      when ChamplainImageRenderer {
        $to-parent = cast(ChamplainRenderer, $to-parent);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainImageRenderer, $_);
      }
    }
    self.setChamplainRenderer($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainImageRenderer
  { $!cir }

  multi method new (
    ChamplainImageRendererAncestry $image-renderer,
                                   :$ref           = True
  ) {
    return Nil unless $image-renderer;

    my $o = self.bless( :$image-renderer );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $image-renderer = champlain_image_renderer_new();

    $image-renderer ?? self.bless( :$image-renderer ) !! Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_image_renderer_get_type,
      $n,
      $t
    );
  }
}


### /usr/include/champlain-0.12/champlain/champlain-image-renderer.h

sub champlain_image_renderer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_image_renderer_new ()
  returns ChamplainImageRenderer
  is native(champlain)
  is export
{ * }
