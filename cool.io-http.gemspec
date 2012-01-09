# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cool.io-http"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2012-01-09"
  s.description = "Simpler HTTP for [cool.io][]\n\n[cool.io]: https://github.com/tarcieri/cool.io"
  s.email = ["godfat (XD) godfat.org"]
  s.files = [
  ".gitignore",
  ".gitmodules",
  "CHANGES.md",
  "LICENSE",
  "README.md",
  "Rakefile",
  "TODO.md",
  "cool.io-http.gemspec",
  "lib/cool.io-http.rb",
  "lib/cool.io-http/version.rb",
  "lib/cool.io/http.rb",
  "lib/cool.io/http/payload.rb",
  "lib/cool.io/http/ssl.rb",
  "lib/cool.io/http_fiber.rb",
  "task/.git",
  "task/.gitignore",
  "task/gemgem.rb",
  "test/test_http.rb"]
  s.homepage = "https://github.com/godfat/cool.io-http"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "Simpler HTTP for [cool.io][]"
  s.test_files = ["test/test_http.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cool.io>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
    else
      s.add_dependency(%q<cool.io>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
    end
  else
    s.add_dependency(%q<cool.io>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
  end
end
