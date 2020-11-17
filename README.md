NAME
====

provide 'is test-assertion' trait for older Rakus

SYNOPSIS
========

```raku
use Test;
use Test::Assertion;

sub foo-test() is test-assertion {  # will never be compile-time error
    subtest "we do many tests" => {
        flunk "failed this one";    # <-- points here if doesn't work
    }
}

foo-test();  # <-- points here if test-assertion *does* work
```

DESCRIPTION
===========

Test::Assertion is a module that provides the `is test-assertion` trait for subroutines, which was introduced in Rakudo 2020.10, to older versions of Raku. This allows module authors to use the `is test-assertion` trait in a module without having to worry whether the version of Raku actually supports that trait.

Module authors should add this module to the "test_depends" section of the META information of a module, as it will (most likely) only be needed during testing.

Please note that this does **not** actually implement the `is test-assertion` error reporting logic: it merely makes sure that the use of the trait will not be a compile time error in the test-file where it is being used.

AUTHOR
======

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/Test-Assertion . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

