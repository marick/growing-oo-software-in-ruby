module Locations
  def self.__DIR__(*args)  # Borrowed from Ramaze.
    filename = caller[0][/^(.*):/, 1]
    dir = File.expand_path(File.dirname(filename))
    ::File.expand_path(::File.join(dir, *args.map{|a| a.to_s}))
  end

  # All libraries must be inside third-party.
  def self.restrict_load_path_to_defaults
    require 'rbconfig'
    $LOAD_PATH.delete_if { | p | p =~ Regexp.new(RbConfig::CONFIG['sitedir']) }
    ENV['RUBYLIB'].split(':').each do | path |
      $:.delete(path)
    end if ENV.has_key?('RUBYLIB')
  end

  # Add on private library for gems that user might not have installed.
  require 'rubygems'
  ENV['GEM_PATH'] = File.join(__DIR__,'third-party', 'gem')
  Gem.clear_paths

  # Add the directory this file resides in to the load path, so you can run the
  # app from any other working directory
  $LOAD_PATH.unshift(__DIR__)

  # Everything should be loaded relative to app's root.
  $LOAD_PATH.delete('.')

  restrict_load_path_to_defaults
  $LOAD_PATH << __DIR__ + "/third-party/lib"
  $LOAD_PATH << __DIR__ + "/lib"
end


$sandboxed = true
