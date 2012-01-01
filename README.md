# cool.io-http

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/cool.io-http)
* [rubygems](https://rubygems.org/gems/cool.io-http)
* [rdoc](http://rdoc.info/github/godfat/cool.io-http)

## DESCRIPTION:

Simpler HTTP for [cool.io][]

[cool.io]: https://github.com/tarcieri/cool.io

## REQUIREMENTS:

* cool.io
* mime-types

## INSTALLATION:

    gem install cool.io-http

## SYNOPSIS:

    require 'cool.io/http'

    Coolio::Http.request(:url => 'http://example.com'){ |response, headers|
      puts "Response: #{response}"
      puts
      puts " Headers: #{headers}"
    }

    Coolio::Loop.default.run

## CONTRIBUTORS:

* Lin Jen-Shin (@godfat)

## LICENSE:

Apache License 2.0

Copyright (c) 2011, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
