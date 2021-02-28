use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::MapSource::Factory;

use GLib::GList;
use Champlain::MapSource;
use Champlain::MapSource::Desc;

use GLib::Roles::Object;

our subset ChamplainMapSourceFactoryAncestry is export of Mu
  where ChamplainMapSourceFactory | GObject;

class Champlain::MapSource::Factory {
  also does GLib::Roles::Object;

  has ChamplainMapSourceFactory $!cmsf is implementor;

  submethod BUILD (:$factory) {
    self.setChamplainMapSourceFactory($factory) if $factory;
  }

  method setChamplainMapSourceFactory (ChamplainMapSourceFactoryAncestry $_) {
    my $to-parent;

    $!cmsf = do {
      when ChamplainMapSourceFactory {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMapSourceFactory, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMapSourceFactory
    is also<ChamplainMapSourceFactory>
  { $!cmsf }

  method new (ChamplainMapSourceFactoryAncestry $factory, :$ref = True) {
    return Nil unless $factory;

    my $o = self.bless( :$factory );
    $o.ref if $ref;
    $o;
  }

  # Is originally: dup_default
  method new_default (Champlain::MapSource::Factory:U: :$raw = False)
    is also<
      new-default
      dup-default
      dup_default
    >
  {
    my $factory = champlain_map_source_factory_dup_default();

    $factory ?? self.bless( :$factory ) !! Nil;
  }

  method create (Str() $id, :$raw = False) {
    my $ms = champlain_map_source_factory_create($!cmsf, $id);

    # Transfer: none
    $ms ??
      ( $raw ?? $ms !! Champlain::MapSource.new($ms) )
      !!
      Nil
  }

  method create_cached_source (Str() $id, :$raw = False)
    is also<create-cached-source>
  {
    my $ms = champlain_map_source_factory_create_cached_source($!cmsf, $id);

    # Transfer: none
    $ms ??
      ( $raw ?? $ms !! Champlain::MapSource.new($ms) )
      !!
      Nil
  }

  method create_error_source (Int() $tile_size, :$raw = False)
    is also<create-error-source>
  {
    my guint $t  = $tile_size;
    my       $ms = champlain_map_source_factory_create_error_source($!cmsf, $t);

    # Transfer: none
    $ms ??
      ( $raw ?? $ms !! Champlain::MapSource.new($ms) )
      !!
      Nil

  }

  method create_memcached_source (Str() $id, :$raw = False)
    is also<create-memcached-source>
  {
    my $ms = champlain_map_source_factory_create_memcached_source($!cmsf, $id);

    # Transfer: none
    $ms ??
      ( $raw ?? $ms !! Champlain::MapSource.new($ms) )
      !!
      Nil
  }

  method get_registered (:$glist = False, :$raw = False)
    is also<get-registered>
  {
    # cw: GSList is binary compatible with GList, so we use the GList
    #     type
    returnGList(
      champlain_map_source_factory_get_registered($!cmsf),
      $glist,
      $raw,
      ChamplainMapSourceDesc,
      Champlain::MapSource::Desc
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_map_source_factory_get_type,
      $n,
      $t
    );
  }

  method register (
    Champlain::MapSource::Factory:U:
    ChamplainMapSourceDesc() $desc
  ) {
    champlain_map_source_factory_register($!cmsf, $desc);
  }

}
