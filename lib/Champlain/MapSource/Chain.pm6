use v6.c;

use Method::Also;
use NativeCall;

use Champlain::Raw::Types;

use Champlain::MapSource;

our subset ChamplainMapSourceChainAncestry is export of Mu
  where ChamplainMapSourceChain | ChamplainMapSourceAncestry;

class Champlain::MapSource::Chain is Champlain::MapSource {
  has ChamplainMapSourceChain $!cmsc is implementor;

  submethod BUILD (:$chain) {
    self.setChamplainMapSourceChain($chain) if $chain;
  }

  method setChamplainMapSourceChain (ChamplainMapSourceChainAncestry $_) {
    my $to-parent;

    $!cmsc = do {
      when ChamplainMapSourceChain {
        $to-parent = cast(ChamplainMapSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(ChamplainMapSourceChain, $_);
      }
    }
    self.setChamplainMapSource($to-parent);
  }

  method Champlain::Raw::Definitions::ChamplainMapSourceChain
    is also<ChamplainMapSourceChain>
  { $!cmsc }

  multi method new (ChamplainMapSourceChainAncestry $chain, :$ref = True) {
    return Nil unless $chain;

    my $o = self.bless( :$chain );
    $o.ref if $ref;
    $o
  }
  multi method new {
    my $chain = champlain_map_source_chain_new();

    $chain ?? self.bless( :$chain ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &champlain_map_source_chain_get_type,
      $n,
      $t
    );
  }

  method pop {
    champlain_map_source_chain_pop($!cmsc);
  }

  method push (ChamplainMapSource() $map_source) {
    champlain_map_source_chain_push($!cmsc, $map_source);
  }

}

### /usr/include/champlain-0.12/champlain/champlain-map-source-chain.h

sub champlain_map_source_chain_get_type ()
  returns GType
  is native(champlain)
  is export
{ * }

sub champlain_map_source_chain_new ()
  returns ChamplainMapSourceChain
  is native(champlain)
  is export
{ * }

sub champlain_map_source_chain_pop (ChamplainMapSourceChain $source_chain)
  is native(champlain)
  is export
{ * }

sub champlain_map_source_chain_push (
  ChamplainMapSourceChain $source_chain,
  ChamplainMapSource      $map_source
)
  is native(champlain)
  is export
{ * }
