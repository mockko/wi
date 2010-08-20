CSS/JS widgets for gorgeous, native-quality iPhone web apps
===========================================================

CSS/JavaScript widgets for iPhone/iPad web applications:

* Wi.Backgrounds: solid (block, white), striped, alert, action sheet, header (more coming soon)

* Wi.Slider: iPhone slider

Planned:

* Wi.Buttons: many styles of sexy buttons for you to pick from

* Wi.Bars: navigation bar, toolbar, tab bar, custom bars — in grey, black opaque, black translucent and tinted styles

* Wi.TabBar: iPhone-like tab bar

Native quality. No dependencies. Hardware-accelerated animations. Commercial-friendly open-source MIT license. All artwork created in Photoshop specifically for Wi.

This library was created as part of the work on Mockko iPhone Designer (http://www.mockko.com/).


Install
-------

There are 3 variants available currently: `iphone` (to serve to i-devices), `desktop` (to serve when your iPhone app is accessed from a desktop browser) and `mockko` (used by Mockko designer on the desktop, employs images instead of CSS gradients for better scaling behaviour).

Visit [downloads](http://github.com/mockko/wi/downloads), download one of the recent releases, unpack it, drop `wi.iphone.css`, `wi.iphone.js` and `images` subfolder into your app.

Minified and stripped-down versions will be provided soon.


License
-------

MIT license: basically, you can do whatever you want with the code and artwork. See LICENSE for details.


Authors
-------

* Andrey Tarantsov (andreyvit@gmail.com) — CSS/JS coding
* Mikhail Gusarov (dottedmag@dottedmag.net) — might get involved some time later
* Maria Pudova (notmybrain@gmail.com) — artwork


Contact
-------

[@wi_css](http://twitter.com/wi_css/) on Twitter, or e-mail [mockko@mockko.com](mockko@mockko.com).


Hacking
-------

Prerequisites:

* rake
* less.js
* coffeescript [trunk]
* nodejs [>= 0.1.99]
* ruby-fssm (for 'rake watch')
* ruby-haml (for demo)

Run `rake` to build once or `rake watch` to build continuously. See `rake -T` for more tasks.
