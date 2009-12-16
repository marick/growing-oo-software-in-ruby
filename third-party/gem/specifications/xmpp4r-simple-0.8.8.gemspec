# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{xmpp4r-simple}
  s.version = "0.8.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Blaine Cook"]
  s.date = %q{2008-07-30}
  s.description = %q{Jabber::Simple takes the strong foundation laid by xmpp4r and hides the relatively high complexity of maintaining a simple instant messenger bot in Ruby.}
  s.email = %q{romeda@gmail.com}
  s.extra_rdoc_files = ["README", "COPYING"]
  s.files = ["test/test_xmpp4r_simple.rb", "lib/xmpp4r-simple.rb", "README", "COPYING", "CHANGELOG"]
  s.has_rdoc = true
  s.homepage = %q{http://xmpp4r-simple.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{xmpp4r-simple}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simplified Jabber client library.}
  s.test_files = ["test/test_xmpp4r_simple.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xmpp4r>, [">= 0.3.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<xmpp4r>, [">= 0.3.2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<xmpp4r>, [">= 0.3.2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
