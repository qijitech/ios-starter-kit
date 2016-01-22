# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

# Uncomment this line if you're using Swift
use_frameworks!

inhibit_all_warnings!

workspace 'StarterKit'

target 'Examples', :exclusive => true do
  pod "StarterKit", :path => "."
end

xcodeproj 'Examples/Examples.xcodeproj'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ARCHS'] = 'armv7 armv7s arm64'
            config.build_settings['VALID_ARCHS'] = 'armv6 armv7 armv7s arm64'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end