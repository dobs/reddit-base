Reddit Base
===========

A minimal reddit API client for Ruby.

Motivation
----------

Managing major versions of an API client can be tricky, especially when the
API us unversioned, inconsistent and outside of your control.

This client library aims to provide minimal support for the reddit API,
reducing the need for frequent breaking changes and to act as the backbone
for more other higher-level API clients.

Installation
------------

Via Rubygems:

    gem install reddit-base

Or in your Gemfile with Bundler:

    gem reddit-base

Basic Usage
-------------

Retrieving a particular endpoint:

    require 'reddit/base'

    client = Reddit::Base::Client.new(user: USERNAME, password: PASSWORD)
    client.get('/r/AskReddit')

The above will return a `Faraday::Response` instance with JSON data in the
`body` attribute.

What it Does
------------

  * Authentication.
  * Rate limiting.
  * Modhash handling (reddit's CSRF protection).
  * JSON coersion.
  * Forwarding..
  * Multipart POST.
  * Reddit error wrapping.

What it Doesn't
---------------

  * Parsing of Reddit "Things" and "Kinds."
  * Parsing of common attributes like dates and times.
  * HTML entity decoding (beware of "body" and "selftext").

Recommended Reading
-------------------

  * reddit API documentation: http://www.reddit.com/dev/api
  * reddit API wiki: https://github.com/reddit/reddit/wiki/API
  * reddit project on Github: https://github.com/reddit/reddit

Contributors
------------

  * Maintainer: [Daniel O'Brien](http://github.com/dobs)

This project is copyright 2014 by its contributors, refer to LICENSE file for
licensing information.
