use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::NetworkTileSource;

use Champlain::TileSource;

our subset ChamplainNetworkTileSourceAncestry is export of Mu
  where ChamplainNetworkTileSource | ChamplainTileSourceAncestry;

class Champlain::NetworkTileSource is Champlain::TileSource {
  has ChamplainNetworkTileSource $!cnts is implementor;

  submethod BUILD (:$network-tile-source) {
    self.setChamplainNetworkTileSource($network-tile-source)
      if $network-tile-source;
  }

  method setChamplainNetworkTileSource(ChamplainNetworkTileSourceAncestry $_) {
    my $to-parent;

    $!cnts = do {
      when ChamplainNetworkTileSource {
        $to-parent = cast(ChamplainTileSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainNetworkTileSource, $_);
      }
    }
    self.setChamplainTileSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainNetworkTileSource
    is also<ChamplainNetworkTileSource>
  { $!cnts }

  method new_full (
    Str()               $id,
    Str()               $name,
    Str()               $license,
    Str()               $license_uri,
    Int()               $min_zoom,
    Int()               $max_zoom,
    Int()               $tile_size,
    Int()               $projection,
    Str()               $uri_format,
    ChamplainRenderer() $renderer
  )
    is also<new-full>
  {
    my ChamplainMapProjection $p = $projection;

    my guint ($mnz, $mxz, $ts) = ($min_zoom, $max_zoom, $tile_size);
    my $network-tile-source = champlain_network_tile_source_new_full(
      $id,
      $name,
      $license,
      $license_uri,
      $mnz,
      $mxz,
      $ts,
      $p,
      $uri_format,
      $renderer
    );

    $network-tile-source ?? self.bless( :$network-tile-source ) !! Nil;
  }

  # Type: gboolean
  method offline is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('offline', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('offline', $gv);
      }
    );
  }

  # Type: gchar
  method proxy-uri is rw  is also<proxy_uri> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('proxy-uri', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('proxy-uri', $gv);
      }
    );
  }

  # Type: gchar
  method uri-format is rw  is also<uri_format> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('uri-format', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'uri-format is a construct-only attribute'
      }
    );
  }

  method get_max_conns is also<get-max-conns> {
    champlain_network_tile_source_get_max_conns($!cnts);
  }

  method get_offline is also<get-offline> {
    champlain_network_tile_source_get_offline($!cnts);
  }

  method get_proxy_uri is also<get-proxy-uri> {
    champlain_network_tile_source_get_proxy_uri($!cnts);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_network_tile_source_get_type,
      $n,
      $t
    );
  }

  method get_uri_format is also<get-uri-format> {
    champlain_network_tile_source_get_uri_format($!cnts);
  }

  method set_max_conns (Int() $max_conns) is also<set-max-conns> {
    my gint $m = $max_conns;

    champlain_network_tile_source_set_max_conns($!cnts, $max_conns);
  }

  method set_offline (Int() $offline) is also<set-offline> {
    my gboolean $o = $offline.so.Int;

    champlain_network_tile_source_set_offline($!cnts, $o);
  }

  method set_proxy_uri (Str() $proxy_uri) is also<set-proxy-uri> {
    champlain_network_tile_source_set_proxy_uri($!cnts, $proxy_uri);
  }

  method set_uri_format (Str() $uri_format) is also<set-uri-format> {
    champlain_network_tile_source_set_uri_format($!cnts, $uri_format);
  }

  method set_user_agent (Str() $user_agent) is also<set-user-agent> {
    champlain_network_tile_source_set_user_agent($!cnts, $user_agent);
  }

}
