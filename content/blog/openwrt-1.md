+++
title = "Adventures in OpenWRT: Hosting a blog on your router"
date = "2019-04-08T12:38:14-04:00"
description = "A guide on hosting a small website on your home router"
part = "1"
endPart = "N"
tags = ["openwrt"]
+++

I originally wrote a guide for using [OpenWRT](https://openwrt.org/) to host a blog on an ASUS AC-87u, but the instructions
are a little out of date and need a bit of a refresh.  This newer guide should hopefully be simpler.

Overview
---

To start, I'm hosting this blog on a Linksys [WRT3200ACM](https://wikidevi.com/wiki/Linksys_WRT3200ACM) in my own
apartment on a nightly build of OpenWRT.  I'm no longer using extroot as I was before, as my SSD unfortunately died
on me.  I'm unsure what caused its early demise, though I have a feeling that it wasn't getting sufficient cooling
in the enclosure it was in.  Instead, I'm using just a plain 8GB USB drive to host the site content, as it changes 
much more frequently than the rest of the system.

Before, I was using [Grav](https://getgrav.org/) as the CMS for the site and using a minimal PHP install on the router
to drive the site through [NGINX](https://www.nginx.com/).  I've now switched over to static site generation using
[Hugo](https://gohugo.io/) instead, still using NGINX as the web server.

The site's HTTPS certs are issued from [Let's Encrypt](https://letsencrypt.org/), which is also automated through
a daemon, [ACME.sh](https://github.com/Neilpang/acme.sh), that is running on the router.

NGINX replaces [uHTTPd](https://openwrt.org/docs/guide-user/services/webserver/http.uhttpd) in this setup for
convenience, as it is now able to serve the OpenWRT configuration interface [LuCI](https://openwrt.org/docs/techref/luci)
as well as any other sites that are made accessible through the router.

[Fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page) can be used to ban malicious users, and is recommended
if you have a public facing SSH.  It can also be used to scan NGINX logs for password authentication failures,
in case you have LuCI running publicly.  Alternatively, if you use [Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html)
instead of OpenSSH, you can use [bearDropper](https://github.com/robzr/bearDropper) instead for this purpose.
Both approaches will be covered.

If you don't have a static IP address, consider using a domain name provider that supports [Dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS).
This guide will cover how to set up a DDNS daemon on your router to automate this process.

Once you set things up, there's very little maintenance that needs to be done, aside from your standard OpenWRT
upgrades.
