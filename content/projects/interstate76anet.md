+++
title = "Interstate '76/Nitro pack netcode patches"
description = "Patches to allow you to play Multiplayer Interstate'76/Nitro Pack once again"
draft = false
+++

This page was brought over from my old [cs.uwindsor.ca/~peelar](https://cs.uwindsor.ca/~peelar) home page.
The information presented here is still accurate, however, if you want to try these patches,
I encourage you to download one of the patch bundles from [interstate76.com](http://interstate76.com)
instead of dragging and dropping the files here into your installation, as you will get a few other
goodies as well that way.

# Introduction
These Interstate 76/Nitro Pack game modifications allow you to once again
play games over the internet with other people, without requiring
your machine to be directly connected to the net.  Yes, that's right,
you can now play Interstate and possibly other ANet2-based Activision
games behind a NAT!  The only caveat is that your NAT needs to support UPnP.

There are two separate patches for Nitro and Interstate 76 respectively.

# [Nitro Pack Patch](https://peelar.myweb.cs.uwindsor.ca/winets2_v3.zip)

This patch was a modification of the ANet source code released by Dan Kegel to add UPnP support to the game, thus
eliminating the need to manually forward ports to play Nitro.  The UPnP support is provided via the
open-source [miniupnpc](https://github.com/miniupnp/miniupnp) library.  I believe this patch
could also be used to provide UPnP benefits to other anet2-based games, too (looking at you, Battlezone).

You do need to use an anet2 server to play if you use this patch, however.  Fortunately, there are many
available, including the recommended battlezone1.net server.  To play, just select "battlezone1.net"
from the server list when you host or join a game, and you'll be able to see other games once again.

## Installation
Just extract the files into the game directory, replacing anet2.dll and winets2.dll.

## [Source Code](https://peelar.myweb.cs.uwindsor.ca/anet-0.10-upnp.zip)

I've mirrored my modifications to WINETS2 here as per the GPL licence.  Only winets2 was modified, and to
build it you'll need Microsoft Visual C++ 6.0 or 5.0.  To build miniupnpc, I used TDM-GCC 4.8.1.
To link miniupnpc into winets2, I simply copied the compiled implib over to a place MSVC's linker would reach,
and added it to the list of libraries to link in the winets.mak NMAKE file.

To solve
the problem of structure packing being different in generated code for both compilers, I forced both compilers to
treat the structures as tightly packed with appropriate compiler pragmas (#pragma ms_struct was not available on my 
build of of TDM-GCC).

# [Interstate 76 (non-Nitro) Patch](https://peelar.myweb.cs.uwindsor.ca/WINET.DLL)

Standard I76 can't play network games over IP over the internet, due to
the game making assumptions about IP addresses that are invalid when
Network Address Translation is happening (which is basically all of the 
time these days).  This is the beta version of the patch, which
should address this problem.  It is currently largely untested, however
in 1v1 matchups it has worked without problem.  It should, in theory,
allow clients to play behind NATs.  This version removes the restriction
of the preliminary version, namely "one client per external IP address"
due to a new representation of IP addresses in the DLL (6 bytes instead
of 4, to accomodate the 2 byte port number).  There are still problems
if there are clients that exist on the host's own network, however
those will be addressed with a modified ANet matchmaking server, which
is yet to be written.  Otherwise, it seems to be working fine.  Just
make sure there are no clients on the host's network, and port 21157
is forwarded to the host.

## Installation

To install, just drop this in the "DLL" folder of your Interstate 76 folder.
Only Vanilla I76 has been tested (below 1.083).  I have received word that
the Gold edition also works, but I have not tried this.  Nitro version is
guaranteed to not work for the time being (working on this).
Also, forward port 21157 on your router to your computer, if you are the host.
Clients need not do this.
To connect to an internet game, just enter the host's
external IP address in the "Join Game/Internet" screen, and you'll see
it listed. Enjoy!

## Documentation and Code

Unfortunately, as I did not have any real source code from Interstate 76
to begin with (aside from the sources of a much later and incompatible
version of ANet found at [Dan Kegel's website](http://kegel.com/anet)),
the most I can release are my notes and debugging files.  They are provided below:

* [WINET.DLL udd file](https://peelar.myweb.cs.uwindsor.ca/Winet.udd)
* [ANETDLL.DLL udd file](https://peelar.myweb.cs.uwindsor.ca/anetdll.udd)
* [Notes on data structures used in both (contains some documentation of game operation too)](https://peelar.myweb.cs.uwindsor.ca/blerh.txt")

The UDD files are intended to be used with OllyDbg Version 2.01 alpha 4.
Drag these files to your OllyDbg installation folder before opening
the WINET.DLL available for download on this page or the ANETDLL.DLL
included with your game installation.  These UDD files contain
many comments about the code, and provide descriptive names for
functions found in the assembly, as well as descriptions of function
arguments.

# Credits
 * Myself - Reverse-engineering, Coding, Testing
 * Rob Roddy - Consultation, Staying up until 3am regularly to help me test

# Acknowledgements

* Oleh Yuschuk - For developing and releasing OllyDbg for free
* Dan Kegel - For convincing Activision to allow him to open source
    ActiveNet, developing ActiveNet, and continuing to support the project 
    even today.  Interstate 76 uses a much earlier version, but these 
    sources were still helpful in reverse engineering ANet and WINET.DLL

# Afterword

Did you find anything on this page especially useful or helpful?  Did
anything fail horribly or miserably?  In either case, please let me
know!  I'd be glad to hear from you.
			
