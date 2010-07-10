Wi: Web + Widgets + iPhone
==========================

Wi is an open-source set of widgets for iPhone and iPad web apps with native look & feel.

We're building it as a rendering target for the [Mockko designer](http://www.mockko.com/), but Wi is meant for all kinds of web applications.


Design Goals
------------

1. Independent widgets: each piece of Wi should be usable on its own without dependencies.

2. Not using any JavaScript library: although I've been using jQuery for all my projects for a long time, it would not really add too much to merit its use in this framework.

3. CSS3 instead of images where possible.

4. Copyright-clean: all images were hand-drawn in Photoshop.

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
