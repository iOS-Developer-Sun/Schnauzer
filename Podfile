source 'https://github.com/CocoaPods/Specs.git'

def pod_poodle
  platform :ios, '9.0'
  pod 'PoodleLibrary',
  :subspecs => [
    'PDLFileSystemViewController',
    'UIViewController+PDLNavigationBar',
    'PDLNonThreadSafeObserver',
    'NSObject+PDLAssociation',
  ]
end

target 'SNZCrashAnalyzer' do
  pod_poodle
end

target 'SNZNonThreadSafeAnalyzer' do
  pod_poodle
end

target 'SchnauzerApplication' do
  pod_poodle
end
