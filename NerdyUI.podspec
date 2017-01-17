Pod::Spec.new do |s|

  s.name         = "NerdyUI"
  s.version      = "0.0.2"
  s.summary      = "An easy way to create and layout UI components for iOS."

  s.description  = <<-DESC
  An easy way to create and layout UI components for iOS. Written in Objective-C.
                   DESC

  s.homepage     = "https://github.com/nerdycat/NerdyUI"
  s.license      = "MIT"
  s.author       = { "nerdycat" => "nerdymozart@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/nerdycat/NerdyUI.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.source_files  = "NerdyUI/NerdyUI.h"
  s.public_header_files = "NerdyUI/NerdyUI.h"

  s.subspec "Private" do |ss|
    ss.source_files = "NerdyUI/Private/*.{h,m}"
    ss.public_header_files = "NerdyUI/Private/*.h"
  end

  s.subspec "Public" do |ss|
    ss.source_files = "NerdyUI/Public/*.{h,m}"
    ss.public_header_files = "NerdyUI/Public/*.h"
    ss.dependency 'NerdyUI/Private'
  end

  s.subspec "Chainable" do |ss|
    ss.source_files = "NerdyUI/Chainable/*.{h,m}"
    ss.public_header_files = "NerdyUI/Chainable/*.h"
    ss.dependency 'NerdyUI/Private'
    ss.dependency 'NerdyUI/Public'
  end
  
end
