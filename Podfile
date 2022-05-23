source 'https://github.com/CocoaPods/Specs.git'

def pod_poodle
  platform :ios, '9.0'
  pod 'PoodleLibrary',
  :git => 'https://github.com/iOS-Developer-Sun/Poodle',
  :commit => 'b116527396e3d0f2f765fb25480f9c34803c3ff5',
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
