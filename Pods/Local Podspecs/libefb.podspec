#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "libefb"
  s.version          = "0.2.0"
  s.summary          = "Essential functionality of all EFB(R) app."
  s.description      = <<-DESC
                       See README.
                       DESC
  s.homepage         = "http://192.168.243.230:8080/git/efb2/libefb.git"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "xuyang" => "xuy@adcc.com.cn" }
  s.source           = { :git => "http://192.168.243.230:8080/git/efb2/libefb.git"}

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '6.1'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.resources = ['Assets/**/*.png', 'Assets/**/*.css', 'Classes/**/*.xib', 'Assets/**/*.plist']

  s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
  s.dependency 'AFDownloadRequestOperation', '~> 2.0.1'
  s.dependency 'ViewDeck', '~> 2.2.11'
  # s.dependency 'JLRoutes', '~> 1.2'
  # s.dependency 'MD5Digest', '~> 0.1.0'
  s.dependency 'OpenUDID', '~> 1.0.0'
  s.dependency 'PixateFreestyle', '~> 2.1.3'
end
