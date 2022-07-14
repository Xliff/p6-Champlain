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

my @colors = (
  ${:cmyk($[0, 74, 73, 2]), :hex("f94144"), :hsb($[359, 74, 98]), :hsl($[359, 94, 62]), :lab($[56, 69, 41]), :name("Red Salsa"), :rgb($[249, 65, 68])},
  ${:cmyk($[0, 50, 83, 4]), :hex("f57b29"), :hsb($[24, 83, 96]), :hsl($[24, 91, 56]), :lab($[65, 42, 62]), :name("Pumpkin"), :rgb($[245, 123, 41])},
  ${:cmyk($[0, 43, 79, 2]), :hex("f98d34"), :hsb($[27, 79, 98]), :hsl($[27, 94, 59]), :lab($[69, 35, 62]), :name("Cadmium Orange"), :rgb($[249, 141, 52])},
  ${:cmyk($[0, 27, 69, 2]), :hex("f9b74e"), :hsb($[37, 69, 98]), :hsl($[37, 93, 64]), :lab($[79, 14, 61]), :name("Maximum Yellow Red"), :rgb($[249, 183, 78])},
  ${:cmyk($[24, 0, 43, 25]), :hex("90be6d"), :hsb($[94, 43, 75]), :hsl($[94, 38, 59]), :lab($[72, 18446744073709551586, 36]), :name("Pistachio"), :rgb($[144, 190, 109])},
  ${:cmyk($[57, 0, 15, 36]), :hex("46a48c"), :hsb($[165, 57, 64]), :hsl($[165, 40, 46]), :lab($[61, 18446744073709551582, 4]), :name("Zomp"), :rgb($[70, 164, 140])},
  ${:cmyk($[43, 8, 0, 44]), :hex("52838f"), :hsb($[192, 43, 56]), :hsl($[192, 27, 44]), :lab($[52, 18446744073709551603, 18446744073709551604]), :name("Steel Teal"), :rgb($[82, 131, 143])},
  ${:cmyk($[68, 22, 0, 38]), :hex("337b9d"), :hsb($[199, 68, 62]), :hsl($[199, 51, 41]), :lab($[49, 18446744073709551605, 18446744073709551591]), :name("CG Blue"), :rgb($[51, 123, 157])}
);

constant MARKER_SIZE = 10;
constant MARKER_END  = MARKER_SIZE / 2;

my @grads;

my $nc = @colors.elems;
for ^$nc {
  my @rcolors = @colors;
  @rcolors .= rotate($_) if $_;

  say "Colors { $_ }: { @rcolors.gist }";

  my $p = Cairo::Pattern::Gradient::Radial.create(
    MARKER_SIZE, MARKER_SIZE, 0,
    MARKER_SIZE, MARKER_SIZE, MARKER_SIZE *1.5
  );

  for @rcolors.kv -> $k, $v {
    say "K = $k / V = { $v.gist }";
    $p.add_color_stop_rgb( $k * @colors.elems ** -1, |$v<rgb>.map( */256 ) )
  }
  @grads.push: $p;
}


@grads.map( *.gist ).say;

sub draw-center ($canvas, $c, $width, $height, $ud, $r) {
  CATCH { default { .message.say; .backtrace.concise.say } }

  my $cr = Cairo::Context.new($c);
  with $cr {
    .operator = CAIRO_OPERATOR_CLEAR;
    .paint;
    .operator = CAIRO_OPERATOR_OVER;
    .rgb(0, 0, 0);

    .arc(MARKER_SIZE, MARKER_SIZE, MARKER_SIZE * 1.5, 0, 2 * π);
    .close_path;

    .rgba(0.1, 0.1, 0.9, 1);
    .fill
  }

  $r.r = 1;
}

my ($value, $sign, $echo) = (0, 1);
my $iteration = @colors.elems ** -1;
$*SCHEDULER.cue( in => 2, {
  GLib::Timeout.add(125, -> *@a {
    $value += $iteration * $sign;
    if $value >= 1 || $value < 0 {
      $value = 1 if $value > 1;
      $value = 0 if $value < 0;
      $sign *= -1;
    }
    $echo.invalidate;
    1;
  })
});

sub get-pattern {
  my Int() $i = $value * @colors.elems;
  $i .= pred if $i >= @colors.elems;
  $i = 0     if $i < 0;
  say "Value = $value / Index = $i";
  @grads[$i];
}

sub draw-circle ($canvas, $c, $width, $height, $ud, $r) {
  CONTROL {
    when CX::Warn {
      say .message;
      .resume;
    }
  }
  CATCH { default { .message.say; .backtrace.concise.say } }

  my $cr = Cairo::Context.new($c);
  with $cr {
    .operator = CAIRO_OPERATOR_CLEAR;
    .paint;
    .operator = CAIRO_OPERATOR_OVER;
    .rgb(0, 0, 0);

    .arc(MARKER_SIZE * 4, MARKER_SIZE * 4, 8 * MARKER_SIZE, 0, 2 * π);
    #.close_path;
    #.save;

    my $p = get-pattern;
    say "Pattern = { $p // '»undef«' } ({ $p ?? $p.WHERE !! '¿WTF?' }) - Value = { $value // '¿QT?' }";
    .pattern($p);
    .fill;

    #.restore;
    # .line_width = 2;
    # .rgba(0.1, 0.1, 0.7, 1);
    # .stroke;
  }

  $r.r = 1;
}

sub create-marker {
  my $marker = Champlain::Marker.new;
  my $canvas = Clutter::Canvas.new.setup(
    size => MARKER_SIZE xx 2
  );
  #$canvas.draw.tap(-> *@a { draw-center(|@a) });

  my $bg = Clutter::Actor.new.setup(
    size     => MARKER_SIZE xx 2,
    position => (MARKER_SIZE * -0.5) xx 2,
    content  => $canvas
  );
  $canvas.invalidate;
  # cw: MM-refactor will make this unnecessary
  $canvas.unref;
  $marker.add-child($bg);

  $echo = Clutter::Canvas.new.setup(
    size => (2 * MARKER_SIZE) xx 2
  );
  $echo.draw.tap(-> *@a { draw-circle(|@a) });
  my $bg2 = Clutter::Actor.new.setup(
    size        => (8 * MARKER_SIZE) xx 2,
    pivot-point => 0.5 xx 2,
    position    => (MARKER_SIZE * -4) xx 2,
    opacity     => 178,
    content     => $echo
  );
  $echo.invalidate;
  $marker.add-child($bg2);
  # cw: MM-refactor will make this unnecessary
  $echo.unref;

  # my $o-transition = Clutter::PropertyTransition.new('opacity').setup(
  #   duration     => 1000,
  #   repeat-count => -1,
  #   from         => 255,
  #   to           => 0
  # );
  # $bg2.easing-mode = CLUTTER_EASE_OUT_SINE;
  # $bg2.add-transition('animate-opacity', $o-transition);

  # my $sx-transition = Clutter::PropertyTransition.new('scale-x').setup(
  #   duration     => 1000,
  #   repeat-count => -1,
  #   from         => 0.5,
  #   to           => 2
  # );
  # $bg2.easing-mode = CLUTTER_EASE_OUT_SINE;
  # $bg2.add-transition('animate-scale-x', $sx-transition);

  # my $sy-transition = Clutter::PropertyTransition.new('scale-y').setup(
  #   duration     => 1000,
  #   repeat-count => -1,
  #   from         => 0.5,
  #   to           => 2
  # );
  # $bg2.easing-mode = CLUTTER_EASE_OUT_SINE;
  # $bg2.add-transition('animate-scale-y', $sy-transition);

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
