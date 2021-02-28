use v6.c;

use Clutter::Raw::Structs;
use GTK::Raw::Types;
use Champlain::Raw::Types;

use Champlain::MapSource::Factory;
use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::ComboBox;
use GTK::CellRendererText;
use GTK::Frame;
use GTK::Image;
use GTK::SpinButton;
use GTK::ToggleButton;
use GTK::TreeIter;
use GTK::TreeStore;
use GTK::ChamplainEmbed;
use GTK::Clutter::Main;
use GTK::Window;
use Champlain::Coordinate;
use Champlain::Scale;
use Champlain::View;

use lib <t .>;

use Markers;

enum ModelColumns <COL_ID COL_NAME>;

sub build-combo-box ($box) {
  my $store   = GTK::TreeStore.new(G_TYPE_STRING, G_TYPE_STRING);
  my $factory = Champlain::MapSource::Factory.new-default;

  for $factory.get-registered[] {
    my $parent = $store.append;

    say "{ .id // 'NIL-id' } => { .name // 'NIL-name' }";

    $store.set(
      $parent,
      COL_ID   => .id,
      COL_NAME => .name
    );
  }

  $box.model = $store;
  my $cell = GTK::CellRendererText.new;
  $box.layout_pack_start($cell);
  $box.set_attribute($cell, 'text', COL_NAME);
}

sub append-point ($l, $lon, $lat) {
  $l.add-node( Champlain::Coordinate.new-full($lon, $lat) );
}

sub MAIN {
  exit(1) unless GTK::Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  ( .title, .border-width ) = ('libcamplain Gtk+ demo', 10)
    given (my $window = GTK::Window.new);
  $window.destroy-signal.tap(-> *@a { GTK::Application.quit });

  my $vbox   = GTK::Box.new-vbox(10);
  my $widget = GTK::ChamplainEmbed.new;
  my $view   = $widget.get-view.setup(
    location => (45.466, -73.75)
  );
  ( .kinetic-mode, .zoom-level ) = (True, 5) given $view;
  $widget.set-size-request(640, 481);

  $view.reactive = True;
  $view.button-release-event.tap(-> *@a {
    CATCH { default { .message.say; .backtrace.concise.say } }
    # cw: This redundancy must be remedied!
    my $e = cast(ClutterButtonEvent, @a[1]);
    my @loc = $view.positionToLocation( $e.x, $e.y );
    say sprintf("Mouse clicked at: %f, %f", |@loc);
    @a.tail.r = 1;
  });
  $view.set-data('window', $window);

  my $scale = Champlain::Scale.new.setup(
    expand   => True,
    x-align  => CLUTTER_ACTOR_ALIGN_START,
    y-align  => CLUTTER_ACTOR_ALIGN_END
  );
  $view.add-child($scale);
  $scale.connect-view($view);

  my $license-actor = $view.get-license-actor;
  $license-actor.extra-text =
    "Don't eat cereals with orange juice\nIt tastes bad";

  $view.add-layer($_) for (
    my ($marker-layer, $marker-path) = create-marker-layer
  );

  my $highway10 = Champlain::PathLayer.new;
  append-point($highway10, |$_) for (45.4095, -73.3197),
                                    (45.4104, -73.2846),
                                    (45.4178, -73.2239),
                                    (45.4176, -73.2181),
                                    (45.4151, -73.2126),
                                    (45.4016, -73.1926),
                                    (45.3994, -73.1877),
                                    (45.4000, -73.1815),
                                    (45.4151, -73.1218);
  $view.add-layer($highway10);

  my $bbox = GTK::Box.new-hbox(10);
  my $zi-image = GTK::Image.new-from-icon-name('zoom-in', GTK_ICON_SIZE_BUTTON);
  my $zi-button = GTK::Button.new;
  ( .image, .label ) = ($zi-image, 'Zoom In') given $zi-button;
  $zi-button.clicked.tap(-> *@a { $view.zoom-in });

  my $zo-image = GTK::Image.new-from-icon-name(
    'zoom-out',
    GTK_ICON_SIZE_BUTTON
  );
  my $zo-button = GTK::Button.new;
  ( .image, .label ) = ($zo-image, 'Zoom Out') given $zo-button;
  $zo-button.clicked.tap(-> *@a { $view.zoom-out });

  .active = True
    given ( my $m-button = GTK::ToggleButton.new-with-label('Markers') );
  $m-button.toggled.tap(-> *@a {
    ($marker-path.visible, $highway10.visible) = $m-button.active xx 2;
    $m-button.active ?? $marker-layer.animate-in-all-markers
                     !! $marker-layer.animate-out-all-markers
  });

  .active = False given
    ( my $w-button = GTK::ToggleButton.new-with-label('Toggle Wrap') );
  $w-button.toggled.tap(-> *@a { $view.horizontal-wrap .= not });

  .active = True, build-combo-box($_) given (my $c-button = GTK::ComboBox.new);
  $c-button.changed.tap(-> *@a {
    if $c-button.get-active-iter -> $iter {
      my $id = $c-button.model.get($iter, COL_ID);

      say "New Source: $id";

      $view.map-source =
        Champlain::MapSource::Factory.new-default.create-cached-source($id);
    }
  });

  my $zl-spin = GTK::SpinButton.new-with-range(0, 20, 1);
  $zl-spin.value = $view.zoom-level;
  $zl-spin.changed.tap(-> *@a {
    $view.zoom-level = $zl-spin.value.Int
  });
  $view.notify('zoom-level').tap(-> *@a {
    $zl-spin.value = $view.zoom-level;
  });

  $bbox.add($_) for $zi-button, $zo-button, $m-button, $w-button, $c-button,
                    $zl-spin;

  my $viewport = GTK::Frame.new;
  $viewport.add($widget);
  $vbox.add($_) for $bbox, $viewport;
  $window.add($vbox);

  $window.show-all;

  GTK::Application.main;
}
