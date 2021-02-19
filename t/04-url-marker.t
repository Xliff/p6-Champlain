use v6.c;

use Champlain::Raw::Types;

use COGL::Raw::Enums;
use SOUP::Raw::Subs;

use GDK::Pixbuf::Loader;
use SOUP::Session;
use Clutter::Image;
use Clutter::Main;
use Clutter::Stage;
use Champlain::Label;
use Champlain::MarkerLayer;
use Champlain::View;

use Champlain::Roles::Location;

sub new-pixbuf-from-message ($message) {
  my $mime-type      = $message.response-headers.get-one('Content-Type');
  my $loader         = GDK::Pixbuf::Loader.new-with-mime-type($mime-type);
  my $pixbuf-is-open = $loader.so;
  my $pixbuf;

  unless $ERROR {
    $loader.write(
      $message.response-body.data,
      $message.response-body.length
    );

    unless $ERROR {
      $loader.close;
      $pixbuf-is-open = False;

      unless $ERROR {
        $pixbuf = $loader.get_pixbuf;
        $pixbuf.ref if $pixbuf;
      }
    }
  }

  $loader.close if $pixbuf-is-open;
  $loader.unref if $loader;
  $pixbuf;
}

sub new-texture-from-pixbuf ($pixbuf) {
  (my $content = Clutter::Image.new).set-data(
    $pixbuf.pixels,
    $pixbuf.has-alpha ?? COGL_PIXEL_FORMAT_RGBA_8888
                      !! COGL_PIXEL_FORMAT_RGB_888,
    $pixbuf.width,
    $pixbuf.height,
    $pixbuf.rowstride
  );
  my ($w, $h) = $content.get_preferred_size;

  my $texture = Clutter::Actor.new;
  $texture.set-size($w, $h);
  $texture.content = $content;

  $content.invalidate;

  # cw: MM-refactor of API will eventually make this unnecessary.
  $content.unref;

  $texture;
}

sub onImageDownloaded ($session, $message, $data) {
  CATCH {
    when CX::Warn { .message.say }
    default       { .message.say; .backtrace.concise.say }
  }

  my ($pixbuf, $texture, $marker);

  if $data {
    my $url = ~$message.uri;
    if statusIsSuccessful($message.status-code) {
      $pixbuf  = new-pixbuf-from-message($message);

      if $ERROR.not {
        $texture = new-texture-from-pixbuf($pixbuf);

        if $ERROR.not {
          $marker = Champlain::Label.new-with-image($texture);
          $marker.set_location($data<latitude>, $data<longitude>);
          $data<layer>.add-marker($marker);
        } else {
          say "Failed to convert { $url } into a texture: { $ERROR.message }";
        }
      } else {
        say "Failed to convert { $url } into an image: { $ERROR.message }";
      }
    } else {
      say "Download of { $url } failed with error code {
           $message.status-code }";
    }
  }

  $data<layer>.unref if $data;
  $pixbuf.unref if $pixbuf;
  $texture.destroy if $texture;
}

sub create-marker-from-url ($layer, $session, $lat, $long, $url) {
  my %data;
  %data<layer latitude longitude> = ($layer.ref, $lat, $long);

  my $message = SOUP::Message.new('GET', $url);
  $session.queue-message($message, -> *@a {
    onImageDownloaded($session, $message, %data)
  });
}

sub MAIN {
  exit(1) unless Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  my $stage = Clutter::Stage.new.setup(
    size => (800, 600)
  );
  $stage.destroy.tap({ Clutter::Main.quit });

  my $view = Champlain::View.new.setup(
    size => (800, 600)
  );
  $stage.add-child($view);

  my $layer   = Champlain::MarkerLayer.new-full(CHAMPLAIN_SELECTION_SINGLE);
  $view.add-layer($layer);

  my $session = SOUP::Session.new;
  create-marker-from-url($layer, $session, |$_)
    for (48.218611, 17.146397, 'https://gitlab.gnome.org/GNOME/libchamplain/raw/master/demos/icons/emblem-favorite.png'),
        (48.21066,  16.31476,  'https://gitlab.gnome.org/GNOME/libchamplain/raw/master/demos/icons/emblem-generic.png'),
        (48.14838,  17.10791,  'https://gitlab.gnome.org/GNOME/libchamplain/raw/master/demos/icons/emblem-important.png');

  ( .zoom-level, .kinetic-mode ) = (10, True) given $view;
  $view.center-on(48.22, 16.8);
  $stage.show-actor;
  Clutter::Main.run;
  $session.unref;
}
