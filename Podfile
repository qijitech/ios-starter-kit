# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

# Uncomment this line if you're using Swift
use_frameworks!

inhibit_all_warnings!

workspace 'ios-starter-kit'

xcodeproj 'src/StarterKit'
target 'StarterKit' do
pod 'Overcoat', :subspecs => ['PromiseKit', 'CoreData']
pod 'TGRDataSource'
pod 'libextobjc'
pod 'AFNetworking'
pod 'Mantle', '~> 2.0'
pod 'Masonry', '~> 0.6.4'
pod 'UITableView+FDTemplateLayoutCell', '~> 1.4.beta'
pod 'DZNEmptyDataSet', '~> 1.7.3'
pod 'HexColors', '~> 3.0.0'
pod 'Toast', '~> 3.0'
pod 'UzysAnimatedGifLoadMore', '~> 0.9.2'
pod 'UzysAnimatedGifPullToRefresh', '~> 0.9.7'
pod 'FLEX', '~> 2.2.0'
end

target 'Examples', :exclusive => true do
xcodeproj 'Examples/Examples'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ARCHS'] = 'armv7 armv7s arm64'
            config.build_settings['VALID_ARCHS'] = 'armv6 armv7 armv7s arm64'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end