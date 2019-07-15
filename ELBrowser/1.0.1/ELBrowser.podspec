#
# Be sure to run `pod lib lint ELBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ELBrowser'
  s.version          = '1.0.1'
  s.summary          = '图片浏览器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LifeForLove/ELBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LifeForLove' => 'getElementByYou@163.com' }
  s.source           = { :git => 'https://github.com/LifeForLove/ELBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ELBrowser/Classes/**/*'
  
  s.resource_bundles = {
   'ELBrowser' => ['ELBrowser/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'SDWebImage' ,'~> 4.0'
    s.dependency 'SDWebImage/GIF'
    s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/Headers/Private/ELBrowser/',
        'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
    
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }
end
