#
# Be sure to run `pod lib lint LESliderController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LESliderController"
  s.version          = "0.2.0"
  s.summary          = "Another container controller."

  s.homepage         = "https://github.com/lucasecf/LESliderController"
  s.license          = 'MIT'
  s.author           = { "Lucas Eduardo" => "lucasecf@gmail.com" }
  s.source           = { :git => "https://github.com/lucasecf/LESliderController.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LESliderController' => ['Pod/Assets/*.png']
  }

end
