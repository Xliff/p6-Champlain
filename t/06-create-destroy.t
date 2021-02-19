use v6.c;

use Champlain::Raw::Types;

use GLib::Timeout;
use Clutter::Actor;
use Clutter::Main;
use Clutter::Stage;
use Champlain::View;

my $stage;

sub create-actor {
  my $actor = Champlain::View.new.setup(
    size       => (800, 600),
    zoom-level => 12,
    location   => (45.466, -73.75)
  );
  $stage.add-child($actor);
  $actor;
}

sub MAIN {
  exit(1) unless Clutter::Main.init == CLUTTER_INIT_SUCCESS;

  my $actor;
  $stage = Clutter::Stage.new.setup(
    size => (800, 600)
  );
  $stage.destroy.tap(-> *@a { Clutter::Main.quit });
  $stage.show-actor;

  GLib::Timeout.add(100, -> *@a {
    CATCH { default { .message.say; .backtrace.concise.say } }

    if $actor.not {
      $actor = create-actor;
    } else {
      $actor.destroy;
      $actor = Nil;
    }
    1;
  });

  Clutter::Main.run;
}
