use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::Tile;

use GLib::Value;
use Clutter::Actor;

my @attributes = <
  content
  etag
  fade-in     fade_in
  size
  state
  x
  y
  zoom-level  zoom_level
>;

our subset ChamplainTileAncestry is export of Mu
  where ChamplainTile | ClutterActorAncestry;

class Champlain::Tile is Clutter::Actor {
  has ChamplainTile $!ct is implementor;

  submethod BUILD (:$tile) {
    self.setChamplainTile($tile) if $tile;
  }

  method setChamplainTile(ChamplainTileAncestry $_) {
    my $to-parent;

    $!ct = do {
      when ChamplainTile {
        $to-parent = cast(ClutterActor, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainTile, $_);
      }
    }
    self.setClutterActor($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainTile
    is also<ChamplainTile>
  { $!ct }

  multi method new (ChamplainTileAncestry $tile, :$ref = True) {
    return Nil unless $tile;

    my $o = self.bless( :$tile );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $tile = champlain_tile_new();

    $tile ?? self.bless( :$tile ) !! Nil;
  }

  method new_full (Int() $x, Int() $y, Int() $size, Int() $zoom_level)
    is also<new-full>
  {
    my guint ($xx, $yy, $s, $z) = ($x, $y, $size, $zoom_level);

    my $tile = champlain_tile_new_full($xx, $yy, $s, $z);
    $tile ?? self.bless( :$tile ) !! Nil;
  }

  method setup(*%data) {
    for %data.keys -> $_ is copy {
      when @attributes.any  {
        say "TAA: {$_}" if $DEBUG;
        self."$_"() = %data{$_};
        %data{$_}:delete;
      }

      # when @add-methods.any {
      #   my $proper-name = S:g/'-'/_/;
      #   say "CvA: {$_}" if $DEBUG;
      #   self."add_{ $proper-name }"( |%data{$_} );
      #   %data{$_}:delete;
      # }
      #
      # when @set-methods.any {
      #   my $proper-name = S:g/'-'/_/;
      #   say "CvSM: {$_}" if $DEBUG;
      #   self."set_{ $proper-name }"( |%data{$_} );
      #   %data{$_}:delete;
      # }

    }
    self.Clutter::Actor::setup(|%data) if %data.keys;
    self
  }

  # Type: ClutterActor - Transfer:none
  method content (:$raw = False) is rw  {
    my $gv = GLib::Value.new( Clutter::Actor.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('content', $gv)
        );

        propReturnObject(
          $gv.object,
          $raw,
          ClutterActor,
          Clutter::Actor
        );
      },
      STORE => -> $, ClutterActor() $val is copy {
        $gv.object = $val;
        self.prop_set('content', $gv);
      }
    );
  }

  # Type: gchar
  method etag is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('etag', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('etag', $gv);
      }
    );
  }

  # Type: gboolean
  method fade-in is rw  is also<fade_in> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('fade-in', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('fade-in', $gv);
      }
    );
  }

  # Type: guint
  method size is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('size', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('size', $gv);
      }
    );
  }

  # Type: ChamplainState
  method state is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(ChamplainState) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('state', $gv)
        );
        ChamplainStateEnum( $gv.valueFromType(ChamplainState) );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(ChamplainState) = $val;
        self.prop_set('state', $gv);
      }
    );
  }

  # Type: guint
  method x is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('x', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('x', $gv);
      }
    );
  }

  # Type: guint
  method y is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('y', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('y', $gv);
      }
    );
  }

  # Type: guint
  method zoom-level is rw  is also<zoom_level> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('zoom-level', $gv);
      }
    );
  }

  method display_content is also<display-content> {
    champlain_tile_display_content($!ct);
  }

  # Transfer: none
  method get_content (:$raw = False) is also<get-content> {
    my $a = champlain_tile_get_content($!ct);

    $a ??
      ( $raw ?? $a !! Clutter::Actor.new($a) )
      !!
      Nil;
  }

  method get_etag is also<get-etag> {
    champlain_tile_get_etag($!ct);
  }

  method get_fade_in is also<get-fade-in> {
    so champlain_tile_get_fade_in($!ct);
  }

  method get_modified_time is also<get-modified-time> {
    champlain_tile_get_modified_time($!ct);
  }

  method get_size is also<get-size> {
    champlain_tile_get_size($!ct);
  }

  method get_state is also<get-state> {
    ChamplainStateEnum( champlain_tile_get_state($!ct) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_tile_get_type,
      $n,
      $t
    );
  }

  method get_x is also<get-x> {
    champlain_tile_get_x($!ct);
  }

  method get_y is also<get-y> {
    champlain_tile_get_y($!ct);
  }

  method get_zoom_level is also<get-zoom-level> {
    champlain_tile_get_zoom_level($!ct);
  }

  method set_content (ClutterActor() $actor) is also<set-content> {
    champlain_tile_set_content($!ct, $actor);
  }

  method set_etag (Str() $etag) is also<set-etag> {
    champlain_tile_set_etag($!ct, $etag);
  }

  method set_fade_in (Int() $fade_in) is also<set-fade-in> {
    my gboolean $f = $fade_in.so.Int;

    champlain_tile_set_fade_in($!ct, $fade_in);
  }

  method set_modified_time (GTimeVal $time) is also<set-modified-time> {
    champlain_tile_set_modified_time($!ct, $time);
  }

  method set_size (Int() $size) is also<set-size> {
    my guint $s = $size;

    champlain_tile_set_size($!ct, $s);
  }

  method set_state (Int() $state) is also<set-state> {
    my ChamplainState $s = $state;

    champlain_tile_set_state($!ct, $s);
  }

  method set_x (Int() $x) is also<set-x> {
    my guint $xx = $x;

    champlain_tile_set_x($!ct, $xx);
  }

  method set_y (Int() $y) is also<set-y> {
    my guint $yy = $y;

    champlain_tile_set_y($!ct, $yy);
  }

  method set_zoom_level (Int() $zoom_level) is also<set-zoom-level> {
    my guint $z = $zoom_level;

    champlain_tile_set_zoom_level($!ct, $z);
  }

}
