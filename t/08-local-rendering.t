use v6.c;

use GTK::Raw::Types;
use Champlain::Raw::Types;

use Champlain::MapSource::Chain;
use Champlain::MapSource::Factory;
use Champlain::ImageRenderer;
use Champlain::MemphisRenderer;
use Champlain::MemoryCache;
use GDK::RGBA;
use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::CellRendererText;
use GTK::ChamplainEmbed;
use GTK::ColorButton;
use GTK::ComboBox;
use GTK::Frame;
use GTK::Grid;
use GTK::Image;
use GTK::ListStore;
use GTK::SpinButton;
use GTK::ScrolledWindow;
use GTK::TreeStore;
use GTK::TreeView;
use GTK::Label;
use GTK::Window;
use GTK::Clutter::Main;

enum ModelColumns <COL_ID COL_NAME>;

my ($memphis-box, $memphis-net-box, $memphis-local-box);

my @maps  = <schaffhausen.osm  las_palmas.osm>;
my @rules = <default-rules.xml high-contrast.xml>;

sub clamp ($val, Range $range) is rw {
  my ($min, $max) = $range.minmax;

  return $min unless $val >= $min;
  return $max unless $val <= $max;
  return $val;
}

sub color-gdk-to-clutter ($gdk-color, $clutter-color?) {
  $clutter-color."$_"() = clamp( $gdk-color."$_"() * 255, 0..255 )
    for <red green blue alpha>;
  $clutter-color;
}

sub color-clutter-to-gdk ($clutter-color, $gdk-color?) {
  $gdk-color."$_"() = $clutter-color."$_"() / 255.0
    for <red green blue alpha>;
  $gdk-color;
}

my ($tile-source, $bg-button, $rules-tree-view, $map-data-state-img);

sub load-network-map-data ($source, $view) {
  use Champlain::BoundingBox;

  my $bbox = ChamplainBoundingBox.new;
  $source.notify('state').tap(-> *@a {
    if $source.state == CHAMPLAIN_STATE_LOADING {
      $map-data-state-img.set-from-icon-name('edit-find');
      say 'NET DATA SOURCE STATE: loading';
    } else {
      $map-data-state-img.clear;
      say 'NET DATA SOURCE STATE: done';
    }

    my ($lat, $lon) = $view.getLocation;
    given $bbox {
      ( .left,   .right ) = ( $lon - 0.008, $lon + 0.008 );
      ( .bottom, .top   ) = ( $lat - 0.008, $lat + 0.008 );
    }
    $source.load-map-data($bbox);
  });
}

sub load-rules-into-gui ($v) {
  my $renderer    = Champlain::MemphisRenderer.new(
                      $tile-source.renderer(:raw)
                    );
  my @ids         = $renderer.get-rule-ids;
  $bg-button.rgba = color-clutter-to-gdk($renderer.background-color);

  my $store = $rules-tree-view.get-model;
  $store.clear;

  for @ids {
    my $iter = $store.append;
    $store.set($iter, 0, $_);
  }
}

my ($current-rule, $polycolor,  $polyminz,   $polymaxz,
    $linecolor,    $linesize,   $lineminz,   $linemaxz,
    $bordercolor,  $bordersize, $borderminz, $bordermaxz,
    $textcolor,    $textsize,   $textminz,   $textmaxz);


sub onRuleApply ($w, $renderer) {
  given (my $rule = $current-rule) {
    my $color = $polycolor.rgba;

    when $rule.polygon {
      (.color-red, .color-green, .color-blue) =
        ($color.red, $color.green, $color.blue) »*» 255 given $rule.polygon;
      (.z-min, .z-max) = ($polyminz, $polymaxz)».value;
    }

    when $rule.line {
      (.color-red, .color-green, .color-blue) =
        ($color.red, $color.green, $color.blue) »*» 255 given $rule.line;
      (.size, .z-min, .z-max) =($linesize, $lineminz, $linemaxz)».value
        given $rule.line;
    }

    when $rule.border {
      (.color-red, .color-green, .color-blue) =
        ($color.red, $color.green, $color.blue) »*» 255 given $rule.border;
      (.size, .z-min, .z-max) = ($linesize, $lineminz, $linemaxz)».value
        given $rule.border;
    }

    when $rule.text {
      (.color-red, .color-green, .color-blue) =
        ($color.red, $color.green, $color.blue) »*» 255 given $rule.text;
      (.size, .z-min, .z-max) = ($linesize, $lineminz, $linemaxz)».value
        given $rule.text;
    }
  }

  $renderer.rule = $rule;
  reload-tiles;
}

sub gtk-memphis-prop-new ($t, $a) {
  my ($hbox, $gcolor) = (GTK::Box.new-hbox, GdkRGBA.new);

  ($gcolor.red, $gcolor.green, $gcolor.blue) =
    ($a.color_red, $a.color_green, $a.color_blue) »/» 255.0;

  my $cb = GTK::ColorButton.new-with-rgba($gcolor);
  $hbox.pack-start($cb);

  my $sb1;
  if $t {
    $sb1 = GTK::SpinButton.new-with-range(0, 20, 0.1);
    $sb1.value = $a.size;
    $hbox.pack-start($sb1);
  }

  my $sb2 = GTK::SpinButton.new-with-range(12, 18, 1);
  $sb2.value = $a.z-min;
  $hbox.pack-start($sb2);

  my $sb3 = GTK::SpinButton.new-with-range(12, 18, 1);
  $sb2.value = $a.z-max;
  $hbox.pack-start($sb3);

  given $t {
    when 0 {
      ($polycolor, $polyminz, $polymaxz) = ($cb, $sb2, $sb3);
    }

    when 1 {
      ($linecolor, $linesize, $lineminz, $linemaxz) = ($cb, $sb1, $sb2, $sb3);
    }

    when 2 {
      ($bordercolor, $bordersize, $borderminz, $bordermaxz)
        = ($cb, $sb1, $sb2, $sb3);
    }

    default {
      ($textcolor, $textsize, $textminz, $textmaxz) = ($cb, $sb1, $sb2, $sb3);
    }
  }

  $hbox;
}

my ($window, $rule-edit-window);
sub create-rule-edit-window ($rule, $id, $renderer) {
  $current-rule = $rule;

  given ( $rule-edit-window = GTK::Window.new(GTK_WINDOW_TOPLEVEL) ) {
    ( .border-width, .title, .position ) =
      (10, $id, GTK_WIN_POS_CENTER_ON_PARENT);
    .set-transparent-for($window);
    .destroy.tap(-> *@a {
      $rule-edit-window.destroy;
      ($current-rule, $rule-edit-window) = Nil xx 2;
    });
  }

  ( .column-spacing, .row-spacing ) = 8 xx 2 given (my $grid = GTK::Grid.new);
  (my $label = GTK::Label.new).markup =
    "<b>{ ($rule.type // 'unknown').split('_').tail.lc.tc } Properties</b>";
  $grid.attach($label, 0, 0, 2, 1);

  for <polygon line border.text>.kv {
    my $rule-name = .[1];
    with $rule."{ $rule-name }"() {
      $grid.attach( GTK::Label.new($rule-name.tc ~ ':'),  0, 1 + .[0], 1, 1 );
      $grid.attach( gtk-memphis-prop-new(0, $_),          1, 1 + .[0], 1, 1 );
    }
  }

  my ($vbox, $close-button) = (GTK::Box.new-vbox, GTK::Button.new);
  my $close-image = GTK::Image.new-from-icon-name('zoom-in', GTK_ICON_SIZE_BUTTON);
  ( .image = $close-image, .label) = ($close-image, 'Close');
  $vbox.pack-start($close-button);
  $close-button.clicked.tap(-> *@a {
    $rule-edit-window.destroy;
    ($current-rule, $rule-edit-window) = Nil xx 2;
  });

  my $apply-button = GTK::Button.new;
  my $apply-image = GTK::Image.new-from-icon-name('zoom-in', GTK_ICON_SIZE_BUTTON);
  ( .image = $apply-image, .label) = ($apply-image, '_Apply');
  $vbox.pack-start($apply-button);
  $apply-button.clicked.tap(-> *@a { onRuleApply(@a[0], $renderer) });

  my $mainbox = GTK::Box.new-vbox;
  $mainbox.pack-start($_) for $grid, $vbox;
  $rule-edit-window.add($mainbox);
  $rule-edit-window.show-all;
}

my ($map-index, $rules-index) = 0 xx 2;
my ($memory-cache, $champlain-view);

sub reload-tiles {
  $memory-cache.clean if $memory-cache;
  $champlain-view.reload-tiles;
}

sub onMapSourceChanged ($widget, $view) {
  return unless (my $iter = $widget.get-active-iter);

  my $id       = (my $model = $widget.model).get($iter, COL_ID);
  my $factory  = Champlain::MapSource::Factory.new-default();
  my $source   = $factory.create($id);
  my $renderer = Champlain::MemphisRenderer.new( $source.renderer(:raw) );

  if $source {
    my $rules-path = 'memphis'.IO.add( @rules[$rules-index] );
    my $map-path   = 'memphis'.IO.add(  @maps[$rules-index] );

    if $id eq 'memphis-local' {
      $renderer.load-rules($rules-path);
      $source.load-map-data($map-path);
      $memphis-box.hide;
      .no-show-all = False for $memphis-box, $memphis-local-box;
      $memphis-net-box.no-show-all = True;
      $memphis-box.show-all;
    } elsif 'memphis-network' {
      $renderer.load-rules($rules-path);
      load-network-map-data($source, $view);
      .no-show-all = False for $memphis-box, $memphis-net-box;
      $memphis-local-box.no-show-all = True;
      $memphis-box.show-all;
    } else {
      .hide, .no-show-all = True given $memphis-box;
    }
    $tile-source = $source;

    my $source-chain = Champlain::MapSource::Chain.new;
    my $tile-size    = $tile-source.tile-size;
    my $src1         = $factory.create_error_source($tile-size);
    $source-chain.push($src1);

    # Uncomment to see the rendered map combind with the normal map
    # if $id eq <memphis-local memphis-network>.any {
    #   my $src2 = $factory.create(CHAMPLAIN_MAP_SOURCE_OSM_MAPNIK);
    #   $source-chain.push($src2);
    # }
    $source-chain.push($tile-source);

    my $image-renderer = Champlain::ImageRenderer.new;
    $memory-cache      = Champlain::MemoryCache.new-full(100, $image-renderer);
    $source-chain.push($memory-cache);
    $view.map-source   = $source-chain;

    load-rules-into-gui($view) if $id eq 'memphis';
  }

  # cw: Will not be necessary after MM-refactor
  $factory.unref;
}

sub build-source-combo-box ($box) {
  my $store   = GTK::TreeStore.new(G_TYPE_STRING, G_TYPE_STRING);
  my $factory = Champlain::MapSource::Factory.new-default;

  for $factory.get-registered[] {
    my ($id, $name) = (.id, .name);
    my $parent      = $store.append;
    $store.set($parent,
      COL_ID   => $id,
      COL_NAME => $name
    );
  }
  $box.model = $store;

  my $cell = GTK::CellRendererText.new;
  $box.layout_pack_start($cell);
  $box.set_attribute($cell, 'text', COL_NAME);
}

sub build-data-combo-box ($box) {
  my $store  = GTK::TreeStore.new(G_TYPE_STRING, G_TYPE_INT);
  my $parent = $store.append;

  $store.set($parent,
    COL_ID   => @maps[0],
    COL_NAME => 0
  );

  $store.set($parent,
    COL_ID   => @maps[1],
    COL_NAME => 1
  );
  $box.model = $store;

  my $cell = GTK::CellRendererText.new;
  $box.layout_pack_start($cell);
  $box.set_attribute($cell, 'text', 0);
}

sub build-rules-combo-box ($box) {
  my $store  = GTK::TreeStore.new(G_TYPE_STRING);

  for @rules[^2] {
    my $parent = $store.append;
    $store.set( $parent, |( 0 => $_ ) );
  }

  $box.model = $store;

  my $cell = GTK::CellRendererText.new;
  $box.layout_pack_start($cell);
  $box.set_attribute($cell, 'text', 0);
}

sub MAIN {
  exit(1) unless GTK::Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  given ($window = GTK::Window.new) {
    ( .border-width, .title ) = (10, 'libchamplain Gtk+ demo (Raku)' );
    .destroy-signal.tap(-> *@a { GTK::Application.quit });
  }

  my $hbox;
  ($hbox, $memphis-net-box, $memphis-local-box) = GTK::Box.new-hbox(10) xx 3;
  my $menubox;
  ($menubox, $memphis-box) = GTK::Box.new-vbox(10) xx 2;
  .no-show-all = True for ($memphis-box, $memphis-net-box, $memphis-local-box);

  my $widget      = GTK::ChamplainEmbed.new;
  $widget.set-size-request(640, 480);
  $champlain-view = $widget.view;
  ( .kinetic-mode, .zoom-level ) = (True, 9) given $champlain-view;

  # First line of buttons
  my $bbox  = GTK::Box.new-hbox(10);
  my $zi-image = GTK::Image.new-from-icon-name('zoom-in', GTK_ICON_SIZE_BUTTON);
  my $zi-button = GTK::Button.new;
  ( .image, .label ) = ($zi-image, 'Zoom In') given $zi-button;
  $zi-button.clicked.tap(-> *@a { $champlain-view.zoom-in });

  my $zo-image = GTK::Image.new-from-icon-name(
    'zoom-out',
    GTK_ICON_SIZE_BUTTON
  );
  my $zo-button = GTK::Button.new;
  ( .image, .label ) = ($zo-image, 'Zoom Out') given $zo-button;
  $zo-button.clicked.tap(-> *@a { $champlain-view.zoom-out });

  my $zl-spin = GTK::SpinButton.new-with-range(0, 20, 1);
  $zl-spin.value = $champlain-view.zoom-level;
  $zl-spin.changed.tap(-> *@a {
    $champlain-view.zoom-level = $zl-spin.value.Int
  });
  $champlain-view.notify('zoom-level').tap(-> *@a {
    $zl-spin.value = $champlain-view.zoom-level;
  });

  $bbox.add($_) for $zi-button, $zo-button, $zl-spin;
  $menubox.pack-start($bbox);

  given (my $s-combo = GTK::ComboBox.new) {
    build-source-combo-box($_);
    .active = 0;
    .changed.tap(-> *@a { onMapSourceChanged($s-combo, $champlain-view) });
  }
  $menubox.pack-start($s-combo);

  # Memphis options
  my $ro-label = GTK::Label.new;
  $ro-label.markup = '<b>Memphis Rendering Options</b>';
  $memphis-box.pack-start($ro-label);

  # Local Source Panel
  given (my $lsp-box = GTK::ComboBox.new) {
    build-data-combo-box($_);
    .active = 0;
    .changed.tap(-> *@a {
      return unless (my $iter = $lsp-box.get-active-iter);
      my $index = .get($iter, 1) given (my $model = $lsp-box.get-model);
      $map-index = $index;

      if $tile-source.id eq 'memphis-local' {
        $tile-source.load-map-data( 'memphis'.IO.add( @maps[$map-index] ) );
        reload-tiles;
      }
    });
    $memphis-local-box.pack-start($lsp-box);
  }

  given ( my $zfs-button = GTK::Button.new ) {
    my $zfs-image  = GTK::Image.new-from-icon-name(
      'zoom-fit-best',
      GTK_ICON_SIZE_BUTTON
    );
    .image = $zfs-image;
    .clicked.tap(-> *@a {
      my $bbox           = $tile-source.renderer.bounding-box;
      $widget.center-on( |$bbox.center );
      $widget.zoom-level = 15;
    });
    $memphis-local-box.pack-start($zfs-button);
  }
  $memphis-box.pack-start($memphis-local-box);

  # Network Source Panel
  given ( my $nsp-button = GTK::Button.new-with-label('Request OSM Data') ) {
    .clicked.tap(-> *@a {
      say "Map Location: ({ $champlain-view.getLocation.join(', ') })";
      load-network-map-data($tile-source, $widget)
        if $tile-source.id eq 'memphis-network';
    });
  }
  $map-data-state-img = GTK::Image.new;
  $memphis-net-box.pack-start($_) for $nsp-button, $map-data-state-img;
  $memphis-box.pack-start($memphis-net-box);

  # Rules chooser
  given (my $r-button = GTK::ComboBox.new) {
    build-rules-combo-box($_);
    .active = 0;
    .changed.tap(-> *@a {
      return unless (my $iter = $r-button.get-active-iter);

      my $model = $r-button.model;
      my $file  = $model.get($iter, 0);
      if $tile-source.id eq 'memphis' {
        $tile-source.renderer.load-rules( 'memphis'.IO.add($file) );
        load-rules-into-gui($widget);
        reload-tiles;
      Raw
    });
  }
  $memphis-box.pack-start($r-button);

  # BG Chooser
  my $bg-bbox = GTK::Box.new-hbox(10);
  my $bg-label = GTK::Label.new;
  given $bg-label {
    .markup = 'Background Color';
    $bg-bbox.pack-start($_);
  }
  given (my $bg-button = GTK::ColorButton.new) {
    .title = 'Background';
    .clicked.tap(-> *@a {
      if $tile-source.id eq 'memphis' {
        $tile-source.renderer.background-color = color-gdk-to-clutter(
          $bg-button.rgba
        );
        reload-tiles;
      }
    });
    $bg-bbox.pack-start($_);
  }
  $memphis-box.pack-start($bg-bbox);

  # Rules list
  my ($r-label, $r-bbox) = ( GTK::Label.new('Rules'), GTK::Box.new-hbox(10) );
  $r-bbox.pack-start($r-label);
  $memphis-box.pack-start($r-bbox);

  my $r-store  = GTK::ListStore.new(G_TYPE_STRING);

  $rules-tree-view =
  ( my $t-view     = GTK::TreeView.new-with-model($r-store) );
  $r-store.unref;

  my $r-render = GTK::CellRendererText.new;
  my $column   = GTK::TreeViewColumn.new-with-attributes(
    $r-render,
    |( text => 0 )
  );
  given $t-view {
    .append-column($column), .headers-visible = False, .get-selection;
    .row-activated.tap(-> *@a {
      return Nil unless $rule-edit-window;

      my $selection = $t-view.get-selection;
      if $selection.get-selected -> ($model, $iter) {
        my $renderer = $tile-source.renderer;
        my $id       = $model.get-value($iter, 0);
        if $renderer.get-rule($id) -> $r {
          create-rule-edit-window($r, $id, $renderer);
        }
      }
    });
  }

  .setAutomaticPolicy given (my $scrolled = GTK::ScrolledWindow.new);
  $scrolled.add($t-view);
  $memphis-box.pack-start($scrolled, True, True);
  $menubox.pack-start($memphis-box);

  # Viewport
  my $viewport = GTK::Frame.new;
  $viewport.add($widget);
  $hbox.pack-end($menubox);
  $hbox.add($viewport);

  # Insert into main window
  $window.add($hbox);
  $window.show-all;
  $champlain-view.center-on(28.134876, -15.43814);

  GTK::Application.main;
}
