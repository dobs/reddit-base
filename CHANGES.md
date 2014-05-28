Changes
=======

## Version 0.7.1

  * Minor:
    * Changed option format from `**options` to `options = {}` in Client's delete/get/post/put methods. This should improve compatibility with older versions of ruby.

## Version 0.7.0

  * Major:
    * Now returning `Faraday::Response` instances rather than custom Mash objects. **This is a breaking change** and would have been done in a point release if we were up to 1.0.
    