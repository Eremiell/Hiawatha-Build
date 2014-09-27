# Hiawatha Update Script

Short bash script to check latest version of Hiawatha and do the updating, if it's not already up to date.

## Technicalities

Written for Debian-like systems with Raspbian in mind. If you have dpkg, it should work.

Before first run, do `sudo apt-get install cmake libc6-dev libssl-dev dpkg-dev debhelper fakeroot libxml2-dev libxslt1-dev`.

Is meant to be run in root cron or at least with the root priviledges.

Keeps minimal traces of its activity (last compiled version number in a plaintext file and log). Everything else is cleaned on script exit.

## Notes

It doesn't check, what version you actually have installed, but rather what it did successfully install last time. If you already have latest version installed, you might want to manually set the `lastlatest` file or wait till you know that there's a newer one. Otherwise, it will recompile and reinstall that version, but will remember that for next time.

There's a simple log rotation implemented. After each run, it keeps only the latest 1000 lines of the log. That should be enough for more than 10 full runs.

For fast search in log, seek lines starting with `.` or `!`. The first ones represent successful exits, while the second ones denote unsuccessful exits.

## Thanks

This script is mostly automatized version of [this howto](https://www.hiawatha-webserver.org/forum/topic/1214). Huge thanks to it's author!

Even bigger thanks to the author of [Hiawatha](https://www.hiawatha-webserver.org/), Hugo Leisink.
