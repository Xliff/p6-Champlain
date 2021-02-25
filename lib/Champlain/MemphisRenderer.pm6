use v6.c;

use Method::Also;

use NativeCall;

use Champlain::Raw::Types;
use Champlain::Raw::MemphisRenderer;

use GLib::GList;
use Clutter::Color;
use Champlain::Renderer;

our subset ChamplainMemphisRendererAncestry is export of Mu
  where ChamplainMemphisRenderer | ChamplainRendererAncestry;

class Champlain::MemphisRenderer is Champlain::Renderer {
  has ChamplainMemphisRenderer $!cmr;

  submethod BUILD (:$memphis-renderer) {
    self.setChamplainMemphisRenderer($memphis-renderer) if $memphis-renderer;
  }

  method setChamplainMemphisRenderer (ChamplainMemphisRendererAncestry $_) {
    my $to-parent;

    $!cmr = do {
      when ChamplainMemphisRenderer {
        $to-parent = cast(ChamplainRenderer, $to-parent);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMemphisRenderer, $_);
      }
    }
    self.setChamplainRenderer($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMemphisRenderer
    is also<ChamplainMemphisRenderer>
  { $!cmr }

  method new (
    ChamplainMemphisRendererAncestry $memphis-renderer,
                                     :$ref             = True
  ) {
    return Nil unless $memphis-renderer;

    my $o = self.bless( :$memphis-renderer );
    $o.ref if $ref;
    $o;
  }

  method new_full (Int() $tile_size) is also<new-full> {
    my guint $t = $tile_size;

    my $memphis-renderer = champlain_memphis_renderer_new_full($!cmr, $t);

    $memphis-renderer ??  self.bless( :$memphis-renderer ) !! Nil;
  }

  method background_color is rw is also<background-color> {
    Proxy.new:
      FETCH => -> $                     { self.get_background_color },
      STORE => -> $, ClutterColor() \cc { self.set_background_color(cc) };
  }

  method get_background_color (:$raw = False) is also<get-background-color> {
    my $cc = champlain_memphis_renderer_get_background_color($!cmr);

    $cc ??
      ( $raw ?? $cc !! Clutter::Color.new($cc) )
      !!
      Nil;
  }

  method get_bounding_box is also<get-bounding-box> {
    champlain_memphis_renderer_get_bounding_box($!cmr);
  }

  method get_rule (Str() $id) is also<get-rule> {
    champlain_memphis_renderer_get_rule($!cmr, $id);
  }

  method get_rule_ids (:$glist = False, :$raw = False) is also<get-rule-ids> {

    returnGList(
      champlain_memphis_renderer_get_rule_ids($!cmr),
      $glist,
      $raw,
      ChamplainMemphisRule
    );

  }

  method get_tile_size is also<get-tile-size> {
    champlain_memphis_renderer_get_tile_size($!cmr);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_memphis_renderer_get_type,
      $n,
      $t
    );
  }

  method load_rules (Str() $rules_path) is also<load-rules> {
    champlain_memphis_renderer_load_rules($!cmr, $rules_path);
  }

  method remove_rule (Str() $id) is also<remove-rule> {
    champlain_memphis_renderer_remove_rule($!cmr, $id);
  }

  method set_background_color (ClutterColor() $color)
    is also<set-background-color>
  {
    champlain_memphis_renderer_set_background_color($!cmr, $color);
  }

  method set_rule (ChamplainMemphisRule() $rule) is also<set-rule> {
    champlain_memphis_renderer_set_rule($!cmr, $rule);
  }

  method set_tile_size (Int() $size) is also<set-tile-size> {
    my guint $s = $size;

    champlain_memphis_renderer_set_tile_size($!cmr, $s);
  }

}
