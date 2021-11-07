# This is the "is test-assertion" trait as defined in Rakudo
# 2020.10 and later.  It doesn't do anything else than mix in
# a method "is-test-assertion", whose *existence* is enough to
# mark a subroutine as a subroutine doing test assertions.
# Add this candidate to the :TEST export class, so it doesn't
# get exported by default.
multi sub trait_mod:<is>(Routine:D $r, :$test-assertion!) is export(:TEST) {
    $r.^mixin( role is-test-assertion {
        method is-test-assertion(--> True) { }
    }) if $test-assertion;
}

# Exporter logic loads whatever this system's Test module brings.
# If the application of the "test-assertion" trait to a subroutine
# works, this implies that this version of Test already has the
# trait, so we don't need to export anything.  Otherwise we're
# going to export what the "is export" trait put into the
# EXPORT::TEST namespace (which would be the local copy of
# the trait_mod).  Since we only need to do this at pre-compilation
# time, we save the value in a constant.
sub EXPORT() {
    use Test;

    my constant $nr-candidates = &trait_mod:<is>.candidates.grep( {
        .[0].type ~~ Routine && .[1].name eq q/$test-assertion/
          given .signature.params;
    } ).elems;

    BEGIN $nr-candidates
      ?? Map.new
      !! Map.new( EXPORT::TEST::.head )
}

=begin pod

=head1 NAME

provide 'is test-assertion' trait for older Rakus

=head1 SYNOPSIS

=begin code :lang<raku>

use Test;
use Test::Assertion;

sub foo-test() is test-assertion {  # will never be compile-time error
    subtest "we do many tests" => {
        flunk "failed this one";    # <-- points here if doesn't work
    }
}

foo-test();  # <-- points here if test-assertion *does* work

=end code

=head1 DESCRIPTION

Test::Assertion is a module that provides the C<is test-assertion> trait
for subroutines, which was introduced in Rakudo 2020.10, to older versions of
Raku.  This allows module authors to use the C<is test-assertion> trait in
a module without having to worry whether the version of Raku actually
supports that trait.

If a distribution does not use any external testing functionality, then
this module should probably be added as a dependency to the "test-depends"
section of the META information of a module, as it will (most likely) only
be needed during testing.

If this module is used by a distribution that is geared towards offering
additional testing facilities, then clearly this module must be listed in
the "depends" section.

Please note that this does B<not> actually implement the
C<is test-assertion> error reporting logic: it merely makes sure that the
use of the trait will not be a compile time error in the test-file where
it is being used.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Test-Assertion . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020, 2021 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
