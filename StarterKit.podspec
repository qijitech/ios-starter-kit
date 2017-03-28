#
# Be sure to run `pod lib lint StarterKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "StarterKit"
  s.version          = "0.2.5"
  s.summary          = "ios starter kit."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  qiji tech ios starter kit
                       DESC

  s.homepage         = "https://github.com/qijitech/ios-starter-kit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "杨玉刚" => "smartydroid@gmail.com" }
  s.source           = { :git => "https://github.com/qijitech/ios-starter-kit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/yangyugang'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'StarterKit/Classes/**/*'

  s.resource_bundles = {
   'StarterKit' => ['StarterKit/Assets/**/*.{png,gif}']
  }

  s.public_header_files = 'StarterKit/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'MobileCoreServices', 'SystemConfiguration'

  s.dependency 'Overcoat', '~> 4.0.0-beta.2'
  s.dependency 'Overcoat+CoreData', '~> 4.0.0-beta.2'
  s.dependency 'Overcoat+PromiseKit', '~> 4.0.0-beta.2'
  s.dependency 'libextobjc'
  s.dependency 'Mantle', '~> 2.1.0'
  s.dependency 'Masonry', '~> 0.6.4'
  s.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.5.beta'
  s.dependency 'DZNEmptyDataSet', '~> 1.7.3'
  s.dependency 'HexColors', '~> 3.0.0'
  s.dependency 'AnimatedGIFImageSerialization', '~> 0.2.0'
  s.dependency 'MBProgressHUD'
  s.dependency 'FLEX'
  s.dependency 'MMPlaceHolder'
  s.dependency 'SDWebImage', '~>3.7'
  s.dependency 'DGActivityIndicatorView'
  s.dependency 'MaterialControls', '~> 1.2.2'

end
