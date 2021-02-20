use v6.c;

use Method::Also;

use Champlain::Raw::Types;
use Champlain::Raw::License;

use GLib::Value;
use Clutter::Actor;

our subset ChamplainLicenseAncestry is export of Mu
  where ChamplainLicense | ClutterActorAncestry;

my @attributes = <
  alignment 
  extra-text  extra_text
>;

class Champlain::License is Clutter::Actor {
  has ChamplainLicense $!cl is implementor;

  submethod BUILD (:$license) {
    self.setChamplainLicense($license) if $license;
  }

  method setChamplainLicense(ChamplainLicenseAncestry $_) {
    my $to-parent;

    $!cl = do {
      when ChamplainLicense {
        $to-parent = cast(ClutterActor, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainLicense, $_);
      }
    }
    self.setClutterActor($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainLicense
    is also<ChamplainLicense>
  { $!cl }

  multi method new (ChamplainLicenseAncestry $license, :$ref = True) {
    return Nil unless $license;

    my $o = self.bless( :$license );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $license = champlain_license_new();

    $license ?? self.bless( :$license ) !! Nil;
  }
  
  method setup(*%data) {
    for %data.keys -> $_ is copy {
      when @attributes.any  {
        say "LAA: {$_}" if $DEBUG;
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

  # Type: PangoAlignment
   method alignment is rw  {
     my $gv = GLib::Value.new( GLib::Value.gtypeFromType(PangoAlignment) );
     Proxy.new(
       FETCH => sub ($) {
         $gv = GLib::Value.new(
           self.prop_get('alignment', $gv)
         );
         PangoAlignmentEnum( $gv.valueFromEnum(PangoAlignment) );
       },
       STORE => -> $, Int() $val is copy {
         $gv.valueFromEnum(PangoAlignment) = $val;
         self.prop_set('alignment', $gv);
       }
     );
   }

   # Type: gchar
   method extra-text is rw  is also<extra_text> {
     my $gv = GLib::Value.new( G_TYPE_STRING );
     Proxy.new(
       FETCH => sub ($) {
         $gv = GLib::Value.new(
           self.prop_get('extra-text', $gv)
         );
         $gv.string;
       },
       STORE => -> $, Str() $val is copy {
         $gv.string = $val;
         self.prop_set('extra-text', $gv);
       }
     );
   }

  method connect_view (ChamplainView() $view) is also<connect-view> {
    champlain_license_connect_view($!cl, $view);
  }

  method disconnect_view is also<disconnect-view> {
    champlain_license_disconnect_view($!cl);
  }

  method get_alignment is also<get-alignment> {
    PangoAlignmentEnum( champlain_license_get_alignment($!cl) );
  }

  method get_extra_text is also<get-extra-text> {
    champlain_license_get_extra_text($!cl);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_license_get_type,
      $n,
      $t
    );
  }

  method set_alignment (Int() $alignment) is also<set-alignment> {
    my PangoAlignment $a = $alignment;

    champlain_license_set_alignment($!cl, $alignment);
  }

  method set_extra_text (Str() $text) is also<set-extra-text> {
    champlain_license_set_extra_text($!cl, $text);
  }


}
