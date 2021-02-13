use v6.c;

use Clutter::Actor;
use Clutter::Color;
use Clutter::Main;
use Clutter::Stage;
use Clutter::Text;
use Champlain::Coordinate;
use Champlain::PathLayer;
use Champlain::View;

constant PADDING = 10;

sub make-button ($text) {
  given (my $button = Clutter::Actor.new) {
    my $button-bg = Clutter::Actor.new.setup(
      background-color => $CLUTTER_COLOR_White,
      opacity          => 0xcc
    );

    my $button-text = Clutter::Text.new-full(
      'Sans 10',
      $text,
      $CLUTTER_COLOR_Black
    );

    my ($w, $h) = $button-text.get-size;
    $button-bg.setup(
      size     => ($w + PADDING * 2, $h + PADDING * 2),
      position => 0 xx 2,
    );
    $button-text.set-position(PADDING, PADDING);
    .add-child($button-bg);
    .add-child($button-text);
  }

  $button;
}


sub append-point($layer, $lon, $lat) {
  my $c = Champlain::Coordinate.new_full($lon, $lat);

  $layer.add-node($c);
}

sub MAIN {
  exit(1) unless Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  my $stage = Clutter::Stage.new.setup(
    size => (800, 600),
  );
  $stage.destroy.tap({ Clutter::Main.quit });

  my $view = Champlain::View.new.setup(
    size =>(800, 600)
  );
  $stage.add-child($view);

  my $buttons = Clutter::Actor.new.setup(
    position => PADDING xx 2
  );

  my $total-width = 0;
  my $zi-button = make-button('Zoom In');
  $zi-button.reactive = True;
  $total-width += $zi-button.get-size[0] + PADDING;
  $zi-button.button-release-event.tap(-> *@a {
    $view.zoom_in;
    @a.tail.r = 1;
  });

  my $zo-button = make-button('Zoom Out');
  $zo-button.reactive = True;
  $zo-button.set-position($total-width, 0);
  $zo-button.button-release-event.tap(-> *@a {
    $view.zoom_out;
    @a.tail.r = 1;
  });

  $buttons.add-child($_) for $zi-button, $zo-button;
  $stage.add-child($buttons);

  my $layer1 = Champlain::PathLayer.new;
  $layer1.&append-point( |$_ ) for (45.4104, -73.2846),
                                   (45.4178, -73.2239),
                                   (45.4176, -73.2181),
                                   (45.4151, -73.2126),
                                   (45.4016, -73.1926),
                                   (45.3994, -73.1877),
                                   (45.4000, -73.1815),
                                   (45.4151, -73.1218);

  $layer1.stroke-width = 4;
  $layer1.set-dash(6, 2);

  my $layer2 = Champlain::PathLayer.new;
  $layer2.&append-point( |$_ ) for (45.1386, -73.9196),
                                   (45.1229, -73.8991),
                                   (45.0946, -73.9531),
                                   (45.1085, -73.9714),
                                   (45.1104, -73.9761);

  (.closed, .fill, .visible) = True xx 3 given $layer2;
  $view.add_layer($_) for $layer1, $layer2;
  (.zoom-level, .kinetic-mode) = (8, True) given $view;
  $view.center_on(45.466, -73.75);
  $stage.show-actor;

  Clutter::Main.run;
}
