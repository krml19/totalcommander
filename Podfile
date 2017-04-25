# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'TotalCommander' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TotalCommander
  pod 'Localize-Swift', '~> 1.7'
  pod 'FileKit', '~> 4.0'
  pod 'SwiftyBeaver'
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  pod 'RxGesture'
  
  target 'TotalCommanderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TotalCommanderUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
