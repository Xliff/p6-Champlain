use v6.c;

use Champlain::Raw::Types;

use GLib::Roles::StaticClass;

unit package Champlain::Enums;

class MapProjection {
  also does GLib::Roles::StaticClass;

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_map_projection_get_type,
      $n,
      $t
    );
  }

}

class SelectionMode {
  also does GLib::Roles::StaticClass;

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_selection_mode_get_type,
      $n,
      $t
    );
  }

}

class Unit {
  also does GLib::Roles::StaticClass;

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_unit_get_type,
      $n,
      $t
    );
  }

}

class State {
  also does GLib::Roles::StaticClass;

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_state_get_type,
      $n,
      $t
    );
  }
}

sub champlain_map_projection_get_type (void)
  returns GType
  is export
  is native(champlain)
{ * }

sub champlain_selection_mode_get_type (void)
  returns GType
  is export
  is native(champlain)
{ * }

sub champlain_unit_get_type (void)
  returns GType
  is export
  is native(champlain)
{ * }

sub champlain_state_get_type (void)
  returns GType
  is export
  is native(champlain)
{ * }
