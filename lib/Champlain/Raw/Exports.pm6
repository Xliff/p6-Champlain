use v6.c;

unit package Champlain::Raw::Exports;

our @champlain-exports is export;

BEGIN {
  @champlain-exports = <
    Champlain::Raw::Definitions
  >;
}
