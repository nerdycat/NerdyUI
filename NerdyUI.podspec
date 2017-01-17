Pod::Spec.new do |s|

  s.name         = "NerdyUI"
  s.version      = "0.0.1"
  s.summary      = "An easy way to create and layout UI components for iOS."

  s.description  = <<-DESC
  An easy way to create and layout UI components for iOS. Written in Objective-C.
                   DESC

  s.homepage     = "https://github.com/nerdycat/NerdyUI"
  s.license      = "MIT"
  s.author       = { "nerdycat" => "nerdymozart@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/nerdycat/NerdyUI.git", :tag => "#{s.version}" }
  s.source_files  = "NerdyUI/*"
  
  s.requires_arc = true

end
