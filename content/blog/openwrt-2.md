+++
title = "Adventures in OpenWRT"
subtitle = "Hosting a Blog on your router"
date = "2019-04-09T15:18:20-04:00"
description = "Introduction"
part = "2"
endPart = "N"
tags = ["openwrt"]
+++

[Last time](/blog/openwrt-1/), I gave an overview of what is required to host your blog on your home router.
Today, we'll discuss the basics of OpenWRT and some minimal packages to install to get started.

# Introduction

## OpenWRT

[OpenWRT](https://openwrt.org/) is a Linux-based OS that targets embedded devices.
It's based on [buildroot](https://buildroot.org/) and can be thought of as a buildroot tailored for network hardware.
OpenWRT offers stable releases as well as development builds.  Before getting started, check to make sure your
hardware is supported before continuing.  Consult the [Table of Hardware](https://openwrt.org/toh/start) before trying
anything on your router.  Also consult any relevant OpenWRT wiki pages, and if needed, the forums.

You'll likely want to use USB storage for your site.  This guide assumes you have one.  If you don't, then hopefully you have
enough flash storage available to store your site.

## Obtaining OpenWRT

OK, so you've checked thoroughly and you're certain your router is supported.  Great!
OpenWRT comes in both *Stable* and *Development* varieties.  The stable version isn't updated often, but is much
more thoroughly tested than the development versions.  If you want stability with minimal messing around, go ahead
and use the stable version.  Otherwise, go with the development version.

Now you'll need to either download a firmware image, assemble one, or build one from source.

### Prebuilt images

The most convenient option for starting out is to download a prebuilt firmware image for your device.  Later, you can use `opkg`
to install any missing packages from your base install.  This makes the most sense for users that use OpenWRT stable.
For users that use development versions, this can become inconvenient later when upgrades are needed.
In any case, using these prebuilt images means that when you upgrade the firmware eventually, any packages installed via `opkg` are
lost and must be manually reinstalled.

The [OpenWRT Snapshot Archive](https://openwrt.org/downloads) is sorted based on chipset and vendor.  Use the
information you found in the Table of Hardware earlier to guide you to the correct download for your hardware.
If you get this wrong, in the best case the firmware will be rejected, and in the worst case you'll brick your hardware,
so take some time to get this right.

### Assembling your own image

You can opt to assemble your own firmware image if the base install won't cut it for you.  Indeed,
if you have a device with very limited flash memory available, you will likely have to go this route.
This option is also more convenient for firmware upgrades as well, as you can save your `.config` used to generate
the image and re-use it later.  This makes firmware upgrades a lot simpler in the long run.  It's also a lot faster
than building OpenWRT from source, since assembling just takes pre-built binaries and assembles them into a final image
for you.

Consult the [OpenWRT Image Builder](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)
documentation to get started with this.  It's not so different from the prebuilt approach, though it does involve
a few extra steps.

### Building your own image

This is my preferred approach.  The entire OpenWRT distribution is compiled from scratch according to your
specifications.  The `.config` approach from the Image Builder is used again here, except instead of assembling
pre-built binaries into a firmware image, the image is actually built from scratch.  This allows you to inject your own
compiler optimizations in if desired or make tweaks to existing software.  For example, in my setup, I use most of the
[GentooLTO](https://github.com/InBetweenNames/gentooLTO) optimizations as I can configure OpenWRT to use [GCC 8.3.0](https://gcc.gnu.org/)
along with other recent tools for its toolchain.

To get started with this, consult the [Build System Documentation](https://openwrt.org/docs/guide-developer/build-system/start) for OpenWRT.

Most users shouldn't need to build from scratch.

---

In the end, which approach you choose will depend on what your goals are.  I recommend choosing either the assembling or
building approach if you want to save yourself some time in the long run.

# Firmware Setup

## Needed packages

No matter which approach you choose, you'll need to ensure you have the right packages selected such that you can host
your blog on your device.  If assembling or building your image, make sure you include `nginx` and all of its modules, `luci` for nginx (with ssl),
the USB kernel modules for external storage, the `acme` tool for Let's Encrypt, UPnP support,
and the F2FS kernel modules for your USB storage.  You may want to enable SQM as well.  Uncheck `uHTTPd` since it's no longer needed with NGINX.

If you are using a prebuilt image, then you will need to manually install these through `opkg`.  You'll need to disable uHTTPd and enable NGINX manually.

## Installing OpenWRT

Consult the [OpenWRT Installation Guide](https://openwrt.org/docs/guide-quick-start/factory_installation) to install
your new image onto your device.  Make sure you read any wiki pages relevant to your device and follow any instructions
carefully.

# Conclusion

If you've done everything correctly, you should now be able to log into your router via its web interface and use `ssh` to get a shell
on it.  Follow all standard OpenWRT procedures, including setting a new root password and authenticating yourself with your ISP if necessary.
Next time, we'll go over NGINX configuration for your site.
