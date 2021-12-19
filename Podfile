source 'https://github.com/CocoaPods/Specs.git'

def pod_poodle
  platform :ios, '9.0'
  pod 'Poodle',
  #  pod 'PoodleLibrary',
  :path => '../Poodle',
  #  :git => 'https://github.com/iOS-Developer-Sun/Poodle.git',
  :subspecs => [
    'PDLFileSystemViewController',
    'UIViewController+PDLNavigationBar',
  ]
end

target 'SNZCrashAnalyzer' do
  pod_poodle
end

target 'SchnauzerApplication' do
  pod_poodle
end
