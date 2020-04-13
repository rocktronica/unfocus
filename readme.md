# Unfocus

A tool to help cut down on time spent on Twitter, reading the news, etc.

## To use

1. Edit `sites.txt` with the sites you would like to spend less time on
1. Run `sudo unfocus.sh`

## How it works

A popular trick to prevent visiting a website is to convince your computer that its domain resolves to localhost. This can be done by manually editing the /etc/hosts file:

    127.0.0.1    site-you-do-not-want-to-visit.com

The problem is that, if you ever want a little taste of what you're missing, you have to manually edit again to unblock and remember to edit _again_ when you're ready to re-block...

Anyway, this tool tries to do that for you.

### Is that okay?

Your computer's hosts file is sensitive and write-protected. That's why you need to `sudo` to run this script. That's also why a backup is made and saved to a local `backups` folder on each run -- you can manually revert if something should go wrong.

## TODO

* Warn if it's already running somewhere else
* Fail loudly if hosts file can't be edited
* Enable variable "minutes to wait"
* Cull backups after N files

## License

MIT License

Copyright (c) 2020

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
