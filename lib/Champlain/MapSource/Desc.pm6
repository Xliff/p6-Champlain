use v6.c;

use Champlain::Raw::Types;
use Champlain::Raw::MapSource::Desc;

use GLib::Roles::Object;

our subset ChamplainMapSourceDescAncestry is export of Mu
  where ChamplainMapSourceDesc | GObject;

class Champlain::MapSource::Desc {
  also does GLib::Roles::Object;

  has ChamplainMapSourceDesc $!cmsd;

  submethod BUILD (:$desc) {
    self.setChamplainMapSourceDesc($desc) if $desc;
  }

  method setChamplainMapSourceDesc (ChamplainMapSourceDescAncestry $_) {
    my $to-parent;

    $!cmsd = do {
      when ChamplainMapSourceDesc {
        $to-parent = cast(GObject, $to-parent);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMapSourceDesc, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMapSourceDesc
  { $!cmsd }

  method new (ChamplainMapSourceDescAncestry $desc, :$ref = True) {
    return Nil unless $desc;

    my $o = self.bless( :$desc );
    $o.ref if $ref;
    $o;
  }

  method new_full (
    Str()    $id,
    Str()    $name,
    Str()    $license,
    Str()    $license_uri,
    Int()    $min_zoom,
    Int()    $max_zoom,
    Int()    $tile_size,
    Int()    $projection,
    Str()    $uri_format,
             &constructor,
    gpointer $data        = gpointer
  ) {
    my guint ($mnz, $mxz, $t)    = ($min_zoom, $max_zoom, $tile_size);
    my ChamplainMapProjection $p = $projection;

    my $desc = champlain_map_source_desc_new_full(
      $id,
      $name,
      $license,
      $license_uri,
      $mnz,
      $mxz,
      $t,
      $p,
      $uri_format,
      $constructor,
      $data
    );

    $desc ?? self.bless( :$desc ) !! Nil;
  }

  # Type: gpointer (Callable)
  method constructor is rw  {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('constructor', $gv)
        );

        $gv.pointer;
      },
      STORE => -> $,  $val is copy {
        warn 'constructor is a construct-only attribute'
      }
    );
  }

  # Type: gpointer
  method data is rw  {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('data', $gv)
        );

        $gv.pointer;
      },
      STORE => -> $, $val is copy {
        warn 'data is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method id is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('id', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'id is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method license is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('license', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'license is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method license-uri is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('license-uri', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'license-uri is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method max-zoom-level is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'max-zoom-level is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method min-zoom-level is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-zoom-level', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'min-zoom-level is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method name is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'name is a construct-only attribute'
      }
    );
  }

  # Type: ChamplainMapProjection
  method projection is rw  {
    my $gv = GLib::Value.new( Champlain::Enums::MapProjection.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('projection', $gv)
        );
        #$gv.TYPE
      },
      STORE => -> $, $val is copy {
        warn 'projection is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method tile-size is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tile-size', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'tile-size is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method uri-format is rw  {
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

  method get_constructor {
    # cw:  XXX -To be rendered into a usable Callable
    champlain_map_source_desc_get_constructor($!cmsd);
  }

  method get_data {
    champlain_map_source_desc_get_data($!cmsd);
  }

  method get_id {
    champlain_map_source_desc_get_id($!cmsd);
  }

  method get_license {
    champlain_map_source_desc_get_license($!cmsd);
  }

  method get_license_uri {
    champlain_map_source_desc_get_license_uri($!cmsd);
  }

  method get_max_zoom_level {
    champlain_map_source_desc_get_max_zoom_level($!cmsd);
  }

  method get_min_zoom_level {
    champlain_map_source_desc_get_min_zoom_level($!cmsd);
  }

  method get_name {
    champlain_map_source_desc_get_name($!cmsd);
  }

  method get_projection {
    ChamplainMapProjectionEnum(
      champlain_map_source_desc_get_projection($!cmsd)
    );
  }

  method get_tile_size {
    champlain_map_source_desc_get_tile_size($!cmsd);
  }

  method get_type {
    state ($n, $t)

    unstable_get_type(
      self.^name,
      &champlain_map_source_desc_get_type,
      $n,
      $t
    );
  }

  method get_uri_format {
    champlain_map_source_desc_get_uri_format($!cmsd);
  }

}
