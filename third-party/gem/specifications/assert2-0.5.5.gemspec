# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{assert2}
  s.version = "0.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phlip"]
  s.date = %q{2009-06-20}
  s.email = %q{phlip2005@gmail.com}
  s.files = ["lib/assert2", "lib/assert2/xhtml.rb~", "lib/assert2/rjs.rb", "lib/assert2/flunk.rb", "lib/assert2/rubynode_reflector.rb~", "lib/assert2/xpath.rb~", "lib/assert2/rubynode_reflector.rb", "lib/assert2/xpath.rb", "lib/assert2/ripper_reflector.rb", "lib/assert2/ripdoc.html.erb", "lib/assert2/ripdoc.rb", "lib/assert2/xhtml.rb", "lib/assert2.rb"]
  s.homepage = %q{http://assert2.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{assert2}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An assertion that reflects its block, with all intermediate values}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
