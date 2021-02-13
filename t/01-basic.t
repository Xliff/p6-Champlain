use v6.c;

use Clutter::Main;
use Clutter::Stage;
use Champlain::View;

sub MAIN {
  exit(1) unless Clutter::Main.init;

  my $stage = Clutter::Stage.new;
  $stage.destroy.tap({ Clutter::Main.quit });

  my $view = Champlain::View.new.setup(
    size => (800, 600)
  );
  $stage.add-child($view);
  $stage.show-actor;

  Clutter::Main.run;
}
