
Pod::Spec.new do |s|

  s.name             = "Rippl"
  s.version          = "0.0.2"
  s.summary          = "UI element showing a growing circle, reminiscent of a ripple in a pond."

  s.description      = <<-DESC
                       A Rippl is a simple UIView sublcass which draws an ellipse
                       (most probably a circle) within its frame and has 2 built-in
                       animations. You can call an "impact ripple" to create an
                       additional growing ellipse behind the original one, or you
                       can call a "gain" animation that grows the original view
                       according to the value of the gain.
                       DESC

  s.homepage         = "https://github.com/jeanetienne/rippl"
  s.screenshots      = "https://raw.githubusercontent.com/jeanetienne/rippl/master/impact.gif", "https://raw.githubusercontent.com/jeanetienne/rippl/master/gain.gif"

  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Jean-Étienne" => "cocoapods@jeanetienne.net" }
  s.social_media_url = "http://twitter.com/jeanetienne"

  s.platform         = :ios, "8.0"

  s.source           = { :git => "https://github.com/jeanetienne/rippl.git", :tag => "#{s.version}" }
  s.source_files     = "Rippl/Views/Rippl.swift"

end
