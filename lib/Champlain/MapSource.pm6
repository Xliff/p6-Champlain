use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::MapSource;

use Champlain::Renderer;

use GLib::Roles::Object;

our subset ChamplainMapSourceAncestry is export of Mu
  where ChamplainMapSource | GObject;

class Champlain::MapSource {
  also does GLib::Roles::Object;

  has ChamplainMapSource $!cms is implementor;

  submethod BUILD (:$map-source) {
    self.setChamplainMapSource($map-source) if $map-source;
  }

  method setChamplainMapSource (ChamplainMapSourceAncestry $_) {
    my $to-parent;

    $!cms = do {
      when ChamplainMapSource {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMapSource, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMapSource
    is also<ChamplainMapSource>
  { $!cms }

  multi method new (ChamplainMapSourceAncestry $map-source, :$ref = True) {
    return Nil unless $map-source;

    my $o = self.bless( :$map-source );
    $o.ref if $ref;
    $o
  }

  # Type: ChamplainMapSource
  method next-source (:$raw = False) is rw  is also<next_source> {
    my $gv = GLib::Value.new( Champlain::MapSource.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('next-source', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ChamplainMapSource,
          Champlain::MapSource
        );
      },
      STORE => -> $, ChamplainMapSource() $val is copy {
        $gv.object = $val;
        self.prop_set('next-source', $gv);
      }
    );
  }

  # Type: ChamplainRenderer
  method renderer (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Champlain::Renderer.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('renderer', $gv)
        );

        my $o = $gv.object;
        say "C::R.renderer = $o";

        propReturnObject(
          $o,
          $raw,
          ChamplainRenderer,
          Champlain::Renderer
        )
      },
      STORE => -> $, ChamplainRenderer() $val is copy {
        $gv.object = $val;
        self.prop_set('renderer', $gv);
      }
    );
  }

  method fill_tile (ChamplainTile() $tile) is also<fill-tile> {
    champlain_map_source_fill_tile($!cms, $tile);
  }

  method get_column_count (Int() $zoom_level) is also<get-column-count> {
    my guint $z = $zoom_level;

    champlain_map_source_get_column_count($!cms, $z);
  }

  method get_id is also<get-id> {
    champlain_map_source_get_id($!cms);
  }

  method get_latitude (Int() $zoom_level, Num() $y) is also<get-latitude> {
    my guint   $z  = $zoom_level;
    my gdouble $yy = $y;

    champlain_map_source_get_latitude($!cms, $z, $y);
  }

  method get_license is also<get-license> {
    champlain_map_source_get_license($!cms);
  }

  method get_license_uri is also<get-license-uri> {
    champlain_map_source_get_license_uri($!cms);
  }

  method get_longitude (Int() $zoom_level, Num() $x) is also<get-longitude> {
    my guint   $z  = $zoom_level;
    my gdouble $xx = $x;

    champlain_map_source_get_longitude($!cms, $z, $xx);
  }

  method get_max_zoom_level is also<get-max-zoom-level> {
    champlain_map_source_get_max_zoom_level($!cms);
  }

  method get_meters_per_pixel (
    Int() $zoom_level,
    Num() $latitude,
    Num() $longitude
  )
    is also<get-meters-per-pixel>
  {
    my guint   $z            = $zoom_level;
    my gdouble ($lat, $long) = ($latitude, $longitude);

    champlain_map_source_get_meters_per_pixel($!cms, $z, $lat, $long);
  }

  method get_min_zoom_level is also<get-min-zoom-level> {
    champlain_map_source_get_min_zoom_level($!cms);
  }

  method get_name is also<get-name> {
    champlain_map_source_get_name($!cms);
  }

  # Transfer: none
  method get_next_source (:$raw = False) is also<get-next-source> {
    my $ms = champlain_map_source_get_next_source($!cms);

    $ms ??
      ( $raw ?? $ms !! Champlain::MapSource.new($ms) )
      !!
      Nil;
  }

  method get_projection is also<get-projection> {
    champlain_map_source_get_projection($!cms);
  }

  # Transfer: none
  method get_renderer (:$raw = False) is also<get-renderer> {
    my $r = champlain_map_source_get_renderer($!cms);

    $r ??
      ( $raw ?? $r !! Champlain::Renderer.new($r) )
      !!
      Nil;
  }

  method get_row_count (Int() $zoom_level) is also<get-row-count> {
    my guint $z = $zoom_level;

    champlain_map_source_get_row_count($!cms, $z);
  }

  method get_tile_size is also<get-tile-size> {
    champlain_map_source_get_tile_size($!cms);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_map_source_get_type,
      $n,
      $t
    );
  }

  method get_x (Int() $zoom_level, Num() $longitude) is also<get-x> {
    my guint   $z = $zoom_level;
    my gdouble $l = $longitude;

    champlain_map_source_get_x($!cms, $z, $l);
  }

  method get_y (Int() $zoom_level, Num() $latitude) is also<get-y> {
    my guint   $z = $zoom_level;
    my gdouble $l = $latitude;

    champlain_map_source_get_y($!cms, $z, $l);
  }

  method set_next_source (ChamplainMapSource() $next_source)
    is also<set-next-source>
  {
    champlain_map_source_set_next_source($!cms, $next_source);
  }

  method set_renderer (ChamplainRenderer() $renderer) is also<set-renderer> {
    champlain_map_source_set_renderer($!cms, $renderer);
  }

}
