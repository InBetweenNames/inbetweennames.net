+++
title = "GentooLTO Survey Results"
date = "2019-04-29T21:05:54-04:00"
description = "Results for the GentooLTO Usage Survey"
+++

The [GentooLTO](https://github.com/InBetweenNames/gentooLTO) Project has concluded its first survey of users.
The results are in the [news file](https://github.com/InBetweenNames/gentooLTO/blob/master/metadata/news/2019-04-17-results/2019-04-17-results.en.txt).

A thorough introduction to GentooLTO can be found [here](https://github.com/InBetweenNames/gentooLTO/blob/master/README.md).
Briefly, GentooLTO is a project that chooses highly aggressive compiler optimization defaults for building Gentoo
systems, which itself is a source-based Linux distro.  In particular, the project enables [Link Time Optimization](https://en.wikipedia.org/wiki/Interprocedural_optimization)
by default, which only a few distros are starting to use, including [Clear Linux](https://clearlinux.org/) and [OpenMandriva](https://www.openmandriva.org/).

Historically, the advice has been to use `-O2` on your C or C++ compiler and forget about it.  Misinformation, such as `-O3` being harmful,
or generally worse performing than `-O2`, has become accepted as being truth without sufficient validation.  In reality,
the only reason `-O3` should ever break your code is if your code itself is broken (that is, invokes [Undefined
Behaviour](https://en.wikipedia.org/wiki/Undefined_behavior)).  This is far, far more common than anyone wants to admit.
`-O2` is designed to play nice with code that breaks the rules.  As for the performance part: if `-O3` is ever slower
than `-O2`, that's a compiler bug, full stop.  One of the goals of GentooLTO is to find these bugs.

One aspect of using `-O2` that is really unfortunate, though, is that you lose out on Link Time Optimization.  This means that
the optimizer has only limited ability to optimize across different source code files in practice (otherwise known as
[Translation Units](https://en.wikipedia.org/wiki/Translation_unit_(programming))).  This is because the optimizer runs
only during the compilation stage.  When LTO is in play, the optimizer runs at the linking stage as well, so it has a chance to see the compiler IR across
all objects that are being linked to form the binary.  This means that the optimizer can make smarter choices, as it has
information it simply didn't previously.  It is possible to inline functions across static library boundaries, for
example.  Pretty neat!  As a nice bonus, the generated binaries are usually smaller too. 

The significance of this news item is that 27% of Portage is confirmed building using Link Time Optimizations.  Nice!  I suspect that the actual percentage 
of Gentoo packages that can be built using LTO is much higher -- but we won't know for sure until we try them.  The vast
majority of users were using the highly aggressive GentooLTO defaults as well, which is great to see.

I'll be conducting another survey at some point again to see where we're at.  In the meantime, the priority with
GentooLTO will be to try out other aggressive optimizations by default, including a `-ffast-math` configuration (or nearly so).
As always, if you try out GentooLTO and run into issues, don't hesitate to email or file a bug in the issue tracker.

