# Uncomment the next line to define a global platform for your project

platform :ios, '10.0'

target 'SwiftSummary' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
     use_frameworks! :linkage => :static
#    use_modular_headers!
    inhibit_all_warnings!

    # Pods for SwiftSummary
    pod 'SensorsAnalyticsSDK', '2.1.5', :subspecs => ['DISABLE_UIWEBVIEW']
    pod 'IQKeyboardManagerSwift', '6.5.6'
    pod 'Charts'
    pod 'RxSwift', '5.1.1'
    pod 'RxCocoa', '5.1.1'
    pod 'ReactiveCocoa', '11.0.0'
    pod 'ReactiveSwift', '6.3.0'
    pod 'Alamofire', '5.2.2'
    pod 'Kingfisher', '5.15.0'
    pod 'SSZipArchive', '2.2.3'
    pod 'SVProgressHUD', '2.2.5'
    pod 'RealmSwift', '5.3.3'
    pod 'MJRefresh', '3.4.3'
    pod 'Hero', '1.5.0'
    pod 'SnapKit', '5.0.1'
    pod 'CryptoSwift', '1.2.0'
    pod 'CocoaLumberjack/Swift', '3.6.2'
    pod 'MagazineLayout', '1.6.1'
    pod 'HandyJSON', '5.0.3-beta'
    pod 'YYText', '1.0.7'
    pod 'KeychainAccess', '4.2.0'
    pod 'SwiftyJSON', '5.0.0'

    pod 'KTVHTTPCache', '2.0.1'
    pod 'TZImagePickerController', '3.4.2'

    pod 'ZFPlayer', '4.0.1'
    pod 'ZFPlayer/ControlView', '4.0.1'
    pod 'ZFPlayer/AVPlayer', '4.0.1'
    pod 'ZFPlayer/ijkplayer', '4.0.1'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
                config.build_settings['ARCHS'] = 'arm64'
            end
        end
    end
end
