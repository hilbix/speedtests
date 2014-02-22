speedtests
==========

Some small tests about execution speed.

Usage
-----

```
make
```

Warning: This pulls submodules, compiles all binaries and runs all test scripts.

Tests
=====

A short list of all tests present here


prepend-script.ksh
------------------

This script checks timings for the typical one-liners which prepend some string to some output in a shell script.
See http://serverfault.com/questions/72744/command-to-prepend-string-to-each-line

The `Makefile` uses `shcomp` from `ksh` to speed this script up.  But it runs in any bourne shell type.
If you want to see how slow `bash` is compared to this, then run it directly.

Results:

- If you do not have a special purpose statically linked binary for the task, stick with something like
  `awk -v T="[TEST]" '{ print v " " $0 }'`
  It is easy to understand, easy to use, flexible and performs very well.

- If you happen to compile your ksh script anyway, then prhaps do it directly in your `ksh`.
  It still is a factor slower than `awk`, but is less `fork` intensive, which is interesting.
  But if you do not compile your script - which is the normal case - stick with `awk`!

- Next comes `sed 's/^/[TEST] /'n` which is less flexible than the `awk` script, and a bit slower.

- `perl -ne 'print "[TEST] $_"'` is nearly as fast as `sed` but takes a bit more time.
  `perl` is a lot more powerful than `sed`, though, but most time the power of `awk` is enough for all needs.

- `python` in the uncompiled form is very slow.
  Compiled `python` was not tested as it is usually not used in the given scenario.

- The `shell` variant `while read line; do echo "[TEST] $line"; done` is the slowest variant if the shell script is not compiled.
  Only use this if there are only a few lines or you have less than 1 line per second in average.
