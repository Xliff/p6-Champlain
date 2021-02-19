use v6.c;

use Champlain::Raw::Types;

use Clutter::Color;
use Clutter::Main;
use Clutter::Stage;
use Champlain::Label;
use Champlain::Marker;
use Champlain::MarkerLayer;
use Champlain::PathLayer;
use Champlain::Point;
use Champlain::View;

my $iconDir = 'icon'.IO;
unless $iconDir.d {
  $iconDir = 't'.IO.add('icon');
  unless $iconDir.d {
    die 'Could not find icon/ directory!'
  }
}

sub create-marker-layer ($v) {
  my $path     = Champlain::PathLayer.new;
  my $layer    = Champlain::MarkerLayer.new-full(CHAMPLAIN_SELECTION_SINGLE);
  my $orange   = Clutter::Color.new(0xf3, 0x94, 0x07, 0xbb);

  my $marker1  = Champlain::Label.new-with-text(
    qq[Montréal\n<span size="xx-small">Québec</span>],
    'Serif 14'
  ).setup(
    use-markup => True,
    alignment  => PANGO_ALIGN_RIGHT,
    color      => $orange,
    location   => (45.528178, -73.563788)
  );

  my $marker2  = Champlain::Label.new-from-file(
    $iconDir.add('emblem-generic.png').absolute
  ).setup(
    text       => 'New York',
    location   => (40.77, -73.98)
  );

  my $marker3  = Champlain::Label.new-from-file(
    $iconDir.add('emblem-important.png').absolute
  ).setup(
    location   => (47.130885, -70.764141)
  );

  my $marker4  = Champlain::Point.new.setup(
    location   => (45.130885, -65.764141)
  );

  my $marker5  = Champlain::Label.new-from-file(
    $iconDir.add('emblem-favorite.png').absolute
  ).setup(
    location   => (45.41484, -71.918907)
  );

  for $marker1, $marker2, $marker3, $marker4, $marker5 {
    $layer.add-marker($_);
    .show-actor;
    $path.add-node($_);
  }
  $layer.set-all-markers-draggable;
  ($layer, $path);
}

sub MAIN {
  exit(1) unless Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  my $stage = Clutter::Stage.new.setup(
    size => (800, 600),
  );
  $stage.destroy.tap(-> *@a { Clutter::Main.quit });

  my $view = Champlain::View.new.setup(
    size       => (800, 600),
    location   => (45.528178, -73.563788),
    zoom-level => 8
  );
  $stage.add-child($view);
  $view.add-layer($_) for create-marker-layer($view);

  $stage.show-actor;
  Clutter::Main.run;
}
