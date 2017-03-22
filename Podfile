# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'DTMHeatmapSwift3' do
	pod 'DTMHeatmap'
	pod 'SwiftyJSON'

	post_install do |installer|
	  installer.pods_project.targets.each do |target|
	    target.build_configurations.each do |config|
	      config.build_settings['SWIFT_VERSION'] = '3.0'
	    end
	  end
		require 'fileutils'
		FileUtils.cp_r('Pods/Target Support Files/Pods-DTMHeatmapSwift3/Pods-DTMHeatmapSwift3-acknowledgements.plist', 'Settings.bundle/Acknowledgements.plist', :remove_destination => true)
	end

end
