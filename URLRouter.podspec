
Pod::Spec.new do |s|

  s.name         = "URLRouter"
  s.version      = "0.0.1"
  s.summary      = "A lightweight swift URL manager based regular expressions."
  s.homepage     = "https://github.com/wanggang316/URLRouter"

  s.license      = "MIT"

  s.author             = { "gump" => "gummpwang@gmail.com" }
  s.social_media_url   = "http://twitter.com/wgang316"



  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/wanggang316/URLRouter.git", :tag => s.version }

  s.source_files  = "URLRouter/URLRouter/*.{h,m}"
  s.exclude_files = "URLRouter/URLRouter/*.h"


end
