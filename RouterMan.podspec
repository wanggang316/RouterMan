
Pod::Spec.new do |s|

  s.name         = "RouterMan"
  s.version      = "1.0"
  s.summary      = "A lightweight, extensible Swift URL Router."
  s.homepage     = "https://github.com/wanggang316/RouterMan"

  s.license      = "MIT"

  s.author             = { "gump" => "gummpwang@gmail.com" }
  s.social_media_url   = "https://twitter.com/wgang316"



  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/wanggang316/RouterMan.git", :tag => s.version }

  s.source_files  = "RouterMan/RouterMan/*.swift"


end
