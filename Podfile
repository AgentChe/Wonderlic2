platform :ios, ‘16.6’
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Wonderlic2' do
  pod 'lottie-ios'
  pod 'Kingfisher'
  
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'Alamofire'
  
  pod 'SwiftyStoreKit'

  pod 'OtterScaleiOS', :git => "https://github.com/AgentChe/OtterScaleiOS.git"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.6'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
