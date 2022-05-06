source 'https://github.com/CocoaPods/Specs.git'

def pod_poodle
  platform :ios, '9.0'
  pod 'PoodleLibrary',
  :git => 'https://github.com/iOS-Developer-Sun/Poodle',
  :commit => '2b217620aaa64eae0b69f361479aef3d12cf2df8',
  :subspecs => [
    'PDLToolKit_iOS'
  ]
end

target 'SNZCrashAnalyzer' do
  pod_poodle
end

target 'SNZNonThreadSafeAnalyzer' do
  pod_poodle
end

target 'SchnauzerToolKit' do
  pod_poodle
end

target 'SchnauzerApplication' do
  pod_poodle
end
