# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'BTSPocket' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

# * * * Pods for BTSPocket * * *
# - - - Networking - - - 
  pod 'Alamofire', '~> 5.2'

# - - - Database - - - 
  pod 'RealmSwift'

# - - - Messages Indicators - - -
  pod 'PKHUD'
  pod 'SwiftMessages'
  
# - - - Image cache 'Kingfisher'
  pod 'Kingfisher', '~> 6.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
