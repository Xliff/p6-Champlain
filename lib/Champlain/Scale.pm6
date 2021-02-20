use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::Scale;

use GLib::Value;
use Clutter::Actor;

our subset ChamplainScaleAncestry is export of Mu
  where ChamplainScale | ClutterActorAncestry;

my @attributes = <
  max-width  max_width
  unit
>;

class Champlain::Scale is Clutter::Actor {
  has ChamplainScale $!cs is implementor;

  submethod BUILD (:$scale) {
    self.setChamplainScale($scale) if $scale;
  }

  method setChamplainScale(ChamplainScaleAncestry $_) {
    my $to-parent;

    $!cs = do {
      when ChamplainScale {
        $to-parent = cast(ClutterActor, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainScale, $_);
      }
    }
    self.setClutterActor($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainScale
    is also<ChamplainScale>
  { $!cs }

  multi method new (ChamplainScaleAncestry $scale, :$ref = True) {
    return Nil unless $scale;

    my $o = self.bless( :$scale );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $scale = champlain_scale_new();
    
    $scale ?? self.bless( :$scale ) !! Nil;
  }
  
  method setup(*%data) {
    for %data.keys -> $_ is copy {
      when @attributes.any  {
        say "SAA: {$_}" if $DEBUG;
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
  
  # Type: guint
  method max-width is rw  is also<max_width> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-width', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('max-width', $gv);
      }
    );
  }

  # Type: ChamplainUnit
  method unit is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(ChamplainUnit) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('unit', $gv)
        );
        
        ChamplainUnitEnum( $gv.valueFromType(ChamplainUnit) );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(ChamplainUnit) = $val;
        self.prop_set('unit', $gv);
      }
    );
  }

  method connect_view (ChamplainScale() $scale) is also<connect-view> {
    champlain_scale_connect_view($!cs, $scale);
  }

  method disconnect_view is also<disconnect-view> {
    champlain_scale_disconnect_view($!cs);
  }

  method get_max_width is also<get-max-width> {
    champlain_scale_get_max_width($!cs);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    
    unstable_get_type(
      self.^name,
      &champlain_scale_get_type,
      $n,
      $t
    );
  }

  method get_unit is also<get-unit> {
    ChamplainUnitEnum( champlain_scale_get_unit($!cs) )
  }

  method set_max_width (Int() $value) is also<set-max-width> {
    my guint $v = $value;
    
    champlain_scale_set_max_width($!cs, $v);
  }

  method set_unit (Int() $unit) is also<set-unit> {
    my ChamplainUnit $u = $unit;
    
    champlain_scale_set_unit($!cs, $u);
  }

}
