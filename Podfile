# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

source ‘https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'PeakPerformance' do
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    pod 'ActionSheetPicker-3.0'
    pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :tag => 'master'
    pod 'SideMenu'
    pod 'PDFGenerator', '~> 2.0.1'
    pod 'AMPopTip'
    pod 'Fabric'
    pod 'TwitterKit'
    pod 'TwitterCore'
    pod 'SZTextView'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
