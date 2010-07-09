Wi: Web + Widgets + iPhone
==========================

Wi is an open-source set of widgets for iPhone and iPad web apps with native look & feel.

We're building it as a rendering target for the [Mockko designer](http://www.mockko.com/), but Wi is meant for all kinds of web applications.


Design Decisions
----------------

1. Independent widgets.

2. Not using any JavaScript library.

3. CSS3 instead of images where possible.

4. Visual designer-friendly.


Widgets
-------

(TBD.)


Building
--------

Prerequisites:

* rake
* ruby-haml
* less.js
* coffeescript [trunk]
* nodejs [< 0.1.97]
* ruby-fssm (for 'rake watch')

Run `rake` to build once or `rake watch` to build continuously. See `rake -T` for more tasks.
