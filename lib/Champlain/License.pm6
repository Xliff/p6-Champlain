use v6.c;

use Champlain::Raw::Types;
use Champlain::Raw::License;

use GLib::Value;
use Clutter::Actor;

our subset ChamplainLicenseAncestry is export of Mu
  where ChamplainLicense | ClutterActorAncestry;

class Champlain::License is Clutter::Actor {
  has ChamplainLicense $!cl;

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

  # Type: PangoAlignment
   method alignment is rw  {
     my $gv = GLib::Value.new( GLib::Value.typeFromEnum(PangoAlignment) );
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
   method extra-text is rw  {
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

  method connect_view (ChamplainView() $view) {
    champlain_license_connect_view($!cl, $view);
  }

  method disconnect_view {
    champlain_license_disconnect_view($!cl);
  }

  method get_alignment {
    PangoAlignmentEnum( champlain_license_get_alignment($!cl) );
  }

  method get_extra_text {
    champlain_license_get_extra_text($!cl);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_license_get_type,
      $n,
      $t
    );
  }

  method set_alignment (Int() $alignment) {
    my PangoAlignment $a = $alignment;

    champlain_license_set_alignment($!cl, $alignment);
  }

  method set_extra_text (Str() $text) {
    champlain_license_set_extra_text($!cl, $text);
  }


}
