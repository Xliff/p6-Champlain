use v6.c;

use Method::Also;
use NativeCall;

use Champlain::Raw::Types;

use Clutter::Actor;

our subset ChamplainLayerAncestry is export of Mu
  where ChamplainLayer | ClutterActorAncestry;

class Champlain::Layer is Clutter::Actor {
  has ChamplainLayer $!cl is implementor;

  submethod BUILD (:$layer) {
    self.setChamplainLayer($layer) if $layer;
  }

  method setChamplainLayer(ChamplainLayerAncestry $_) {
    my $to-parent;

    $!cl = do {
      when ChamplainLayer {
        $to-parent = cast(ClutterActor, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainLayer, $_);
      }
    }
    self.setClutterActor($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainLayer
    is also<ChamplainLayer>
  { $!cl }

  multi method new (ChamplainLayerAncestry $layer, :$ref = True) {
    return Nil unless $layer;

    my $o = self.bless( :$layer );
    $o.ref if $ref;
    $o;
  }

  method get_bounding_box {
    champlain_layer_get_bounding_box($!cl);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_layer_get_type,
      $n,
      $t
    );
  }

  method set_view (ChamplainView $view) {
    champlain_layer_set_view($!cl, $view);
  }

}

### /usr/include/champlain-0.12/champlain/champlain-layer.h

sub champlain_layer_get_bounding_box (ChamplainLayer $layer)
  returns ChamplainBoundingBox
  is native(champlain)
  is export
{ * }

sub champlain_layer_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_layer_set_view (ChamplainLayer $layer, ChamplainView $view)
  is native(champlain)
  is export
{ * }
