use v6.c;

use NativeCall;

use GTK::Raw::Definitions;
use Champlain::Raw::Types;

use GTK::Widget;
use Champlain::View;

use GLib::Roles::Object;

our subset GtkChamplainEmbedAncestry is export of Mu
  where GtkChamplainEmbed | GtkWidgetAncestry;

class GTK::ChamplainEmbed {
  also does GLib::Roles::Object;

  has GtkChamplainEmbed $!gce;

  submethod BUILD (:$embed) {
    self.setGtkChamplainEmbed($embed) if $embed;
  }

  method setGtkChamplainEmbed(GtkChamplainEmbedAncestry $_) {
    my $to-parent;

    $!gce = do {
      when GtkChamplainEmbed {
        $to-parent = cast(GtkWidget, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GtkChamplainEmbed, $_);
      }
    }
    self.setWidget($to-parent);
  }

  method Champlain::Raw::Definitions::GtkChamplainEmbed
  { $!gce }


  method new {
    my $embed = gtk_champlain_embed_new();

    $embed ?? self.bless( :$embed ) !! Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gtk_champlain_embed_get_type,
      $n,
      $t
    );
  }

  method get_view (:$raw = False) {
    my $v = gtk_champlain_embed_get_view($!gce);

    $v ??
      ( $raw ?? $v !! Champlain::View.new($v) )
      !!
      Nil;
  }
}

sub gtk_champlain_embed_get_type ()
  returns GType
  is export
  is native(champlain-gtk)
{ * }

sub gtk_champlain_embed_new ()
  returns GtkChamplainEmbed
  is export
  is native(champlain-gtk)
 { * }

sub gtk_champlain_embed_get_view (GtkChamplainEmbed $embed)
  returns ChamplainView
  is export
  is native(champlain-gtk)
{ * }
