Dir.chdir(File.dirname(__FILE__)) do
  Dir['util/*.rb'].each { | file | require file }
  Dir['preferences/*.rb'].each { | file | require file }
  Dir['translators/*.rb'].each { | file | require file }
  Dir['main-window/*.rb'].each { | file | require file }
  Dir['prefs-window/*.rb'].each { | file | require file }
end

