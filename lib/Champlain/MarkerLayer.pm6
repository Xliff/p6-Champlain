use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::MarkerLayer;

use GLib::GList;
use Champlain::Layer;

our subset ChamplainMarkerLayerAncestry is export
  when ChamplainMarkerLayer | ChamplainLayerAncestry;

class Champlain::MarkerLayer is Champlain::Layer {
  has ChamplainMarkerLayer $!cml;

  submethod BUILD (:$marker-layer) {
    self.setChamplainMarkerLayer($marker-layer) if $marker-layer;
  }

  method setChamplainMarkerLayer(ChamplainMarkerLayerAncestry $_) {
    my $to-parent;

    $!cml = do {
      when ChamplainMarkerLayer {
        $to-parent = cast(ChamplainLayer, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMarkerLayer, $_);
      }
    }
    self.setChamplainLayer($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMarkerLayer
    is also<ChamplainMarkerLayer>
  { $!cml }

  multi method new (ChamplainMarkerLayerAncestry $marker-layer, :$ref = True) {
    return Nil unless $marker-layer;

    my $o = self.bless( :$marker-layer );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $marker-layer = champlain_marker_layer_new();

    $marker-layer ?? self.bless( :$marker-layer ) !! Nil;
  }

  method new_full (Int() $mode) is also<new-full> {
    my ChamplainSelectionMode $m = $mode;

    my $marker-layer = champlain_marker_layer_new_full($mode);

    $marker-layer ?? self.bless( :$marker-layer ) !! Nil;
  }

  method add_marker (ChamplainMarker() $marker) is also<add-marker> {
    champlain_marker_layer_add_marker($!cml, $marker);
  }

  method animate_in_all_markers is also<animate-in-all-markers> {
    champlain_marker_layer_animate_in_all_markers($!cml);
  }

  method animate_out_all_markers is also<animate-out-all-markers> {
    champlain_marker_layer_animate_out_all_markers($!cml);
  }

  method get_markers (:$glist = False, :$raw = False) is also<get-markers> {
    returnGList(
      champlain_marker_layer_get_markers($!cml);
      $glist,
      $raw,
      ChamplainMarker,
      Champlain::Marker
    );
  }

  method get_selected (:$glist = False, :$raw = False) is also<get-selected> {
    returnGList(
      champlain_marker_layer_get_selected($!cml),
      $glist,
      $raw,
      ChamplainMarker,
      Champlain::Marker
    );
  }

  method get_selection_mode is also<get-selection-mode> {
    ChamplainSelectionModeEnum(
      champlain_marker_layer_get_selection_mode($!cml)
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      champlain_marker_layer_get_type,
      $n,
      $t
    );
  }

  method hide_all_markers is also<hide-all-markers> {
    champlain_marker_layer_hide_all_markers($!cml);
  }

  method remove_all is also<remove-all> {
    champlain_marker_layer_remove_all($!cml);
  }

  method remove_marker (ChamplainMarker() $marker) is also<remove-marker> {
    champlain_marker_layer_remove_marker($!cml, $marker);
  }

  method select_all_markers is also<select-all-markers> {
    champlain_marker_layer_select_all_markers($!cml);
  }

  method set_all_mfarkers_draggable is also<set-all-mfarkers-draggable> {
    champlain_marker_layer_set_all_markers_draggable($!cml);
  }

  method set_all_markers_undraggable is also<set-all-markers-undraggable> {
    champlain_marker_layer_set_all_markers_undraggable($!cml);
  }

  method set_selection_mode (Int() $mode) is also<set-selection-mode> {
    my ChamplainSelectionMode $m = $mode;

    champlain_marker_layer_set_selection_mode($!cml, $m);
  }

  method show_all_markers is also<show-all-markers> {
    champlain_marker_layer_show_all_markers($!cml);
  }

  method unselect_all_markers is also<unselect-all-markers> {
    champlain_marker_layer_unselect_all_markers($!cml);
  }

}
