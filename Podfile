source 'https://github.com/smartydroid/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!

inhibit_all_warnings!

workspace 'StarterKit'

target 'Examples' do
  pod 'StarterKit', :path => '.'
  pod 'BFPaperButton'
    # pod 'AFNetworkActivityLogger', :git => 'https://github.com/AFNetworking/AFNetworkActivityLogger.git', :branch => '3_0_0'
end

xcodeproj 'Examples/Examples.xcodeproj'

post_install do |installer|
    rca_path = File.join __dir__, 'Pods', 'MTLManagedObjectAdapter'
    ['EXTRuntimeExtensions', 'EXTScope', 'metamacros'].each do |header|
        `grep -rl '"#{header}\\.h"' #{rca_path} | xargs sed -i '' 's/"#{header}\\.h"/<Mantle\\/#{header}.h>/g'`
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['ARCHS'] = 'armv7 armv7s arm64'
            config.build_settings['VALID_ARCHS'] = 'armv6 armv7 armv7s arm64'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
