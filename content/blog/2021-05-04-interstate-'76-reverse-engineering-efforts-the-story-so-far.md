+++
title = "Interstate '76 Reverse Engineering"
subtitle = "The Story So far"
date = "2021-05-05"
tags = ["i76"]
+++

I played a lot of videogames when I was growing up -- one of them, I've found myself coming back to time and time again:

![](https://ptgmedia.pearsoncmg.com/images/art_rollings_gameidea/elementLinks/gameidea_01.gif)

The game is called [Interstate '76](https://en.wikipedia.org/wiki/Interstate_%2776).  Set in an alternate-history version
if 1976 where vigilantes and "creepers" duke it out in souped up muscle cars with guns, rockets, and all kinds of other
gadgets.  On game consoles, the closest analogue would have been the Twisted Metal series, but Interstate was far less dark
and had somewhat deep simulation mechanics involved: you could customize your car quite thoroughly and these customizations
had big effects on how you'd drive it.  You could change the armour allocation, types of tires, brakes, munitions, etc.
This is partly owing to the engine it's built on,
a modified version of the [Mechwarrior 2](https://en.wikipedia.org/wiki/Mechwarrior_2) engine.

I'm still unsure if that engine actually has a name or not.  I believe the last title that used this engine was [Battlezone](https://en.wikipedia.org/wiki/Battlezone_(1998_video_game))
in 1998.  After that, it appears Activision stopped using it in new projects.  Understandable, given it's age at that point
and the many layers of kludge that had undoubtedly accumulated over the years: the engine went from being initially
software rendered in DOS, to supporting Glide and Direct3D on Windows 95 in the early days of accelerated consumer graphics.
Adding in a Hardware Abstraction Layer would prove to be incredibly difficult by that point into the engine, I'm sure.

It's kind of funny -- since I've now finished my PhD, I've got a little more time on my hands, and, yet again, my eyes have been drawn towards
the Interstate. I've got a bit of a history in reverse engineering this game, and I have a fun project planned: writing a native
Vulkan renderer for the game.  But before I delve into doing that, being an academic, I feel a duty to summarize
what the current state of affairs is in this space.  So, this post is an attempt to chronicle the various reverse engineering efforts that have gone into this game (and consequently,
game engine).  If I've missed anybody please let me know, because they absolutely deserve to be mentioned here.

# Online Play Woes

Back when I started High School (2004 or so), I went to go play I'76 once again and found that I could no longer play online.
We had just gotten high speed internet relatively recently and our network configuration was a bit different than it was before:
the modem was plugged into our router instead of being being plugged directly into a PC (as was the case with our dial-up configuration).
This meant we had Network Address Translation (NAT) and the notion of an internal and external IP address.  As it turns out, Interstate 76
(and it's version of the the underlying [ANet](http://www.kegel.com/anet/) networking library it used) was unable to cope with being
played behind a NAT in multiplayer.  I participated back then on the [Interstate 76 Forums](http://forums.interstate76.com/) with the handle "BOFH" attempting
to fix the problem and found out it was a problem for not just me, but everybody.  People were plugging their PCs directly into their
modems just to play online again, or setting DMZs on their router in the hopes it would work.  I promised I'd be back with a real fix, once
I'd learned enough about programming to do it.  I'm sure people read the post and thought *"Yeah OK, sure pal"*, and moved on.

About seven years later, I came back.  I was in my third year of my undergraduate at that point at the University of Windsor (late 2011),
and, I realized, I now had all the tools and knowledge needed to fix it.  It was probably unwise to take on that project in the
middle of a busy semester, but whatever, I did it anyway. My friend Rob Roddy and I worked tirelessly over the weekends trying out different
things and testing things out.  The result was the creation of [the Interstate '76/Nitro pack patches](https://inbetweennames.net/projects/interstate76anet/).

First, we got it working for the base Interstate '76 game, then, after confirmation
 from Lightfoot over at [interstate76.com](http://interstate76.com), we set about fixing it for the Nitro pack expansion as well.
Unfortunately, I wasn't really able to do it until early 2014, but we did get it done.  Ironic, given how much easier
 the Nitro solution was.

This was a big deal: people could once again play online after nearly a decade of it being impractically hard to do so.
I believe there are still regular events that are scheduled around the game to this very day.  Furthermore, our fix applied to other ANet-dependent games as well,
such as Battlezone.

## Base Interstate 76 solution

The fix for the base I'76 game was a lot more involved with Nitro because we didn't have any source code to work with.
Instead, we had to resort to many hours in [Ollydbg](http://www.ollydbg.de/version2.html) at the time to carefully reverse engineer and figure out what
was happening.  It used an earlier version of the ANet library used in later Activision games (and, consequently, the
Nitro pack expansion), and it was not API compatible with ANet2.  So, needless to say, we were largely on our own.

The TL;DR version of what we did was that we figured out how to extend addresses in the UDP backend of ANet to 6 bytes from 4, since
it was largely a run-time typed library and was expected to work in environments with larger addresses.  We used these extra
2 bytes to store the port number that the session was taking place on, because NAT had the opportunity to change it.
We also set in sentinel addresses so that our own code would intercept and "fill in" the correct addresses as needed,
transparent to the game itself.

Unfortunately, this version of ANet is too old to use with the Activision Game Servers, but you can still play with a direct
connection at least.

## Nitro Pack solution

For Nitro, the way forward was much easier.  With the source of ANet2 available, all we had to do was use UPnP at the time
of the session to forward the correct ports across the NAT.  Addresses were already 6 bytes, and it seems this version of
ANet was aware of having possibly more than one address per host, so there wasn't really anything else to do.  Since it's ANet2,
you can connect to Activision Game Servers as well to get game lists, which is always nice.  The default one at [interstate76.com](http://interstate76.com)
is already selected if you use one of the patch collections that have been put together over the years (see the [Downloads](http://interstate76.com/download/))
section of that site.

# Resolution, Frame Limiting, Bug fixes and Audio

As it turns out, I'76 is really dependent on it's framerate for the physics simulations to work properly and other parts of game logic (like AI).

Sometime in 2014, a group reached out to me on [Facebook](https://www.facebook.com/groups/1406760576207563) asking about other improvements
for the game.  It turns out there was an entire other community playing this game in isolation that I didn't know about!  We worked on some
stuff, including getting the game working in widescreen mode with higher resolutions, and the frame rate limiter.  I built in a binary trampoline
to limit the framerate to 30 FPS, but it seems this wasn't optimal: some parts of the game still weren't working quite right.  We tried 24 FPS which was an improvement,
and later, [UCyborg](http://forums.interstate76.com/viewtopic.php?f=8&t=1508&sid=cf6cfef62276d98b53e64ef837196e26) discovered that 20 was about as high as you could go before negative effects started to set in.  They picked up the torch and added a number of much needed improvements to Nitro, detailed at that link.  They are summarized as follows (quoted directly):

> Common:
>
>    * Fixed some, worked-around other memory management bugs, which improves stability; mission 12 -> 13 transition works in I76, also no more need for EmulateHeap shim (the only semi-useful thing from Windows 95 compatibility mode), which doesn't actually fix anything.
>    * Fixed game freezing when clicking menu option if hardware sound acceleration is available.
>    * Fixed certain startup crashes/errors when initing graphics with 3D accelerated renderers enabled (Glide/D3D).
>    * Skipped some unnecessary CPU checking code containing privileged instructions (crashes at startup if privileged instruction exceptions aren't ignored by the OS).
>    * Corrected memory checking code to avoid error about insufficient memory when system has more than 2 GB of RAM.
>    * Fixed an issue with laggy physics simulation that occurs when the system has been running for several days.
>    * Fixed an issue with music playback not restarting during gameplay after the track has finished playing (another issue that occurs when the system has been running for extended periods of time).
>    * After the music track has finished playing during gameplay, the mission specific track will play again now instead of always the 1st music track.
>    * Rearview mirror refreshes every frame now.
>    * Includes Shane's netcode patch for compatibility with NAT, Nitro Pack version also forwards port on router when hosting the game (if UPnP is supported).
>    * Fixed registry handle leaks.
>    * Added frame rate limiter which defaults to limiting the game to run at 20 FPS to workaround bugs that occur at higher frame-rates.
>    * GDI windowed mode now works on Windows NT systems.
>    * Embedded manifest in executables:
>        * Marked as high-DPI aware.
>        * Requests version 6.00 of Common Controls Library to enable visual styles in those occassional message boxes.
>    * Executables have been flagged as compatible with DEP (Data Execution Prevention).
>
>Nitro Pack specific:
>
>    * Clicking Scenarios in main menu will no longer stop music playback.

They also noted that you can use [A3D-Live!](http://www.worknd.ru/) to some audio problems in newer versions of Windows.  A3D was such a cool technology.
I'm glad we're getting that back now with the positional sound APIs being discussed in games once gain.

Independently, as noted on the [PC Gaming Wiki article](https://www.pcgamingwiki.com/wiki/Interstate_%2776#Patches), [immi](https://github.com/immi101/i76fix) in 2017
also wrote a patch to do framerate limiting.

# Car Mods

How could we forget the original [Hack '76](http://forums.interstate76.com/viewtopic.php?f=1&t=1472&sid=cf6cfef62276d98b53e64ef837196e26) program?!
I spent so many hours when I was a kid playing around with this.  You could fly UFOs, drive armadillos, dragsters, etc, all kinds of stuff
not included in the base game.  I originally got it from a site called *Hoppo's House of Hax* back in the day -- so glad to see it still kicking around.
I may have to fire this up again myself.

# Data Formats, inner workings, and the mission file state machine

[That Tony](http://hackingonspace.blogspot.com/) did some extensive reverse engineering of the I'76 data formats between 2016 and 2017.
I highly encourage you to give their blog a read -- they cover things from the model formats used to the terrain formats and even
the state machine used to program mission-specific logic in I'76.  They even went as far as to create some prototype code in the [Urho3D](https://urho3d.github.io/)
engine to import I'76 assets.  It seems they may have intended to move I'76 over to a new engine -- a cool idea!

# Future work and other stuff

Some physics related issues are still present in Nitro that weren't present in the original game.  Namely, the bug where you can ram something
to get back full health.  I suspect that's an overflow bug somewhere, but who knows until someone dives in.

## Unreleased Gold edition

One day, a copy of a beta version of Interstate 76 fell off a truck and found its way into my hands.
This version, named interally *Interstate 76 Gold Edition*, was different than the Gold edition of I'76 that appeared on
store shelves and as a patch for download off the Activision site.  It appears to have added the notion of a proper
Hardware Abstraction Layer for delegating more to 3D accelerator cards.  I'd like to pick this apart a bit more
and see if there's anything here that might be useful to make an "upgrade" patch for Nitro.

## Battlezone source code

Apparently the source code for the Mechwarrior 2 engine still exists and is under the custody of Ken Miller over
at [Battlezone1.org](http://battlezone1.org/).  I hope one day it can be released open source proper so that
we could look at doing easier updates for Interstate!  Since the intellectual property keeps trading owners though,
I doubt it will be though -- so we continue onwards.

## MechVM

[MechVM](http://www.mechvm.org/) is a project that aims to polish Mechwarrior 2 with much-needed bugfixes and provide a reimplementation of the "Shell" that works nicely on modern systems.
The Shell of the Mechwarrior 2 engine is the component that displays menus, videos, and interactive elements outside of the simulation.
I believe a stated goal of the project is to eventually reimplement the entire engine this way.  The source code *is* available for some releases as well.
There might be something here that could be used to do the same for I'76.

## Conclusions

Well, I think that about sums up where things are at right now.  I have another post planned shortly with a new discovery about
Interstate '76: it's own implementation of the famous [fast reciprocal square root](https://en.wikipedia.org/wiki/Fast_inverse_square_root)
function that actually is similar to what Quake 3 had in 1999.  And, of course, I plan to keep posting about my progress on getting
that Vulkan renderer working :)

It is pretty fun to cruise through I'76 fan sites today -- so many little remnants of the 90's "wild west" WWW are still present that
never fail to put a warm feeling in my heart.  At this point, I'm pretty much convinced that although you might leave the Interstate
for a while, it never really leaves you.  

Thanks for reading!