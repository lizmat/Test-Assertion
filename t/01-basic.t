use Test;

my constant $nr-candidates-before = &trait_mod:<is>.candidates.grep( {
    .[0].type ~~ Routine && .[1].name eq q/$test-assertion/
      given .signature.params
} ).elems;

use Test::Assertion;

my constant $nr-candidates-after = &trait_mod:<is>.candidates.grep( {
    .[0].type ~~ Routine && .[1].name eq q/$test-assertion/
      given .signature.params;
} ).elems;

BEGIN { say "$nr-candidates-before - $nr-candidates-after"; die }

plan 2;

sub foo() is test-assertion { }
pass "sub with test-assertion compiled ok";

ok ($nr-candidates-before == 0 | 1) && $nr-candidates-after == 1,
  "we did not add an unneeded 'is test-assertion' candidate";

# vim: expandtab shiftwidth=4
