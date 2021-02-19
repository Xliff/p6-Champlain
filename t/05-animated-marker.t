use v6.c;

use Cairo;

use Champlain::Raw::Types;

use GLib::Timeout;
use Clutter::Actor;
use Clutter::Canvas;
use Clutter::Main;
use Clutter::PropertyTransition;
use Clutter::Stage;
use Clutter::Threads;
use Champlain::MarkerLayer;
use Champlain::Marker;
use Champlain::View;

constant MARKER_SIZE = 10;
sub draw-center ($canvas, $c, $width, $height, $ud, $r) {
  CATCH { default { .message.say; .backtrace.concise.say } }

  my $cr = Cairo::Context.new($c);
  with $cr {
    .operator = CAIRO_OPERATOR_CLEAR;
    .paint;
    .operator = CAIRO_OPERATOR_OVER;
    .rgb(0, 0, 0);

    .arc(MARKER_SIZE / 2, MARKER_SIZE / 2, MARKER_SIZE / 2, 0, 2 * π);
    .close_path;

    .rgba(0.1, 0.1, 0.9, 1);
    .fill
  }

  $r.r = 1;
}

sub draw-circle ($canvas, $c, $width, $height, $ud, $r) {
  CATCH { default { .message.say; .backtrace.concise.say } }

  my $cr = Cairo::Context.new($c);
  with $cr {
    .operator = CAIRO_OPERATOR_CLEAR;
    .paint;
    .operator = CAIRO_OPERATOR_OVER;
    .rgb(0, 0, 0);

    .arc(MARKER_SIZE, MARKER_SIZE, 0.9 * MARKER_SIZE, 0, 2 * π);
    .close_path;

    .line_width = 2;
    .rgba(0.1, 0.1, 0.7, 1);
    .stroke
  }

  $r.r = 1;
}

sub create-marker {
  my $marker = Champlain::Marker.new;
  my $canvas = Clutter::Canvas.new.setup(
    size => MARKER_SIZE xx 2
  );
  $canvas.draw.tap(-> *@a { draw-center(|@a) });

  my $bg = Clutter::Actor.new.setup(
    size     => MARKER_SIZE xx 2,
    position => (MARKER_SIZE * -0.5) xx 2,
    content  => $canvas
  );
  $canvas.invalidate;
  # cw: MM-refactor will make this unnecessary
  $canvas.unref;
  $marker.add-child($bg);

  my $echo = Clutter::Canvas.new.setup(
    size => (2 * MARKER_SIZE) xx 2
  );
  $echo.draw.tap(-> *@a { draw-circle(|@a) });
  my $bg2 = Clutter::Actor.new.setup(
    size        => (2 * MARKER_SIZE) xx 2,
    pivot-point => 0.5 xx 2,
    position    => -MARKER_SIZE xx 2,
    opacity     => 0xff,
    content     => $echo
  );
  $echo.invalidate;
  $marker.add-child($bg2);
  # cw: MM-refactor will make this unnecessary
  $echo.unref;

  my $o-transition = Clutter::PropertyTransition.new('opacity').setup(
    duration     => 1000,
    repeat-count => -1,
    from         => 255,
    to           => 0
  );
  $bg2.easing-mode = CLUTTER_EASE_OUT_SINE;
  $bg2.add-transition('animate-opacity', $o-transition);

  my $sx-transition = Clutter::PropertyTransition.new('scale-x').setup(
    duration     => 1000,
    repeat-count => -1,
    from         => 0.5,
    to           => 2
  );
  $bg2.easing-mode = CLUTTER_EASE_OUT_SINE;
  $bg2.add-transition('animate-scale-x', $sx-transition);

  my $sy-transition = Clutter::PropertyTransition.new('scale-y').setup(
    duration     => 1000,
    repeat-count => -1,
    from         => 0.5,
    to           => 2
  );
  $bg2.easing-mode = CLUTTER_EASE_OUT_SINE;
  $bg2.add-transition('animate-scale-y', $sy-transition);

  $marker;
}

my ($lat, $lon) = (45.466, -73.755);

sub gps-callback ($v, $m) {
  CATCH { default { .message.say; .backtrace.concise.say } }

  ($lat, $lon) = ($lat, $lon) »+» 0.005;
  $v.center-on($lat, $lon);
  $m.set_location($lat, $lon);

  1
}

sub MAIN {
  exit(1) unless Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  my $stage = Clutter::Stage.new.setup(
    size => (800, 600),
  );
  $stage.destroy.tap(-> *@a { Clutter::Main.quit });

  ( .zoom-level, .kinetic-mode ) = (12, True) given (
    my $view = Champlain::View.new.setup(
      size => (800, 600),
    );
  );
  $view.center-on($lat, $lon);
  $stage.add-child($view);

  my $layer = Champlain::MarkerLayer.new-full(CHAMPLAIN_SELECTION_SINGLE);
  $layer.show-actor;
  $view.add-layer($layer);

  my $marker = create-marker;
  $layer.add-marker($marker);

  GLib::Timeout.add(1000, -> *@a { gps-callback($view, $marker) });
  $stage.show-actor;

  Clutter::Main.run;
}
