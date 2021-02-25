use v6.c;

use lib <t .>;

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

use Markers;

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
  $view.add-layer($_) for create-marker-layer[];

  $stage.show-actor;
  Clutter::Main.run;
}
