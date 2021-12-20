def SchnauzerCommonConfigurate(s)
    s.version = "0.0.1"
    s.summary = "Lots of fun."
    s.description = <<-DESC
    Schnauzer
    DESC
    s.homepage = "https://github.com/iOS-Developer-Sun/Schnauzer"
    s.license = "MIT"
    s.author = { "Schnauzer" => "250764090@qq.com" }
    s.source = { :git => "https://github.com/iOS-Developer-Sun/Schnauzer", :tag => "#{s.version}" }

#    s.platform     = { :ios => "9.0", :osx => "10.10" }
#    s.platform     = :ios, "9.0"
#    s.static_framework = true
end

def SchnauzerSpec(name, poodle_pod_name, path: nil, is_library: false, default_subspec: nil)
    pod_name = name
#    poodle_pod_repo = 'https://github.com/iOS-Developer-Sun/Poodle'
    Pod::Spec.new do |s|
        s.name = pod_name

        SchnauzerCommonConfigurate(s)

        source_files = '**/*.{h,hpp,c,cc,cpp,m,mm,s,S,o}'
        header_files = '**/*.{h,hpp}'
        librariy_files = '**/*.{a}'

        if path == nil
            path = name
        end

        if is_library
            source_files = header_files
        end

        if default_subspec
            s.default_subspec = default_subspec
        end

        base = path + '/'

        platform_osx = :osx, "10.10"
        platform_ios = :ios, "9.0"
        platform_universal = { :osx => "10.10", :ios => "9.0" }

        s.ios.deployment_target  = '9.0'
        s.osx.deployment_target  = '10.10'

        s.subspec 'SNZCrashAnalyzer' do |ss|
            ss.platform = platform_universal
            ss.osx.deployment_target  = '10.10'
            ss.ios.deployment_target  = '9.0'
            ss.source_files = base + 'SNZCrashAnalyzer/' + source_files
            ss.vendored_library = base + 'SNZCrashAnalyzer/' + librariy_files
            ss.dependency poodle_pod_name + '/PDLFileSystemViewController'
            ss.dependency poodle_pod_name + '/UIViewController+PDLNavigationBar'
        end

        s.subspec 'SNZNonThreadSafeAnalyzer' do |ss|
            ss.platform = platform_universal
            ss.osx.deployment_target  = '10.10'
            ss.ios.deployment_target  = '9.0'
            ss.source_files = base + 'SNZNonThreadSafeAnalyzer/' + source_files
            ss.vendored_library = base + 'SNZNonThreadSafeAnalyzer/' + librariy_files
            ss.dependency poodle_pod_name + '/PDLNonThreadSafeObserver'
            ss.dependency poodle_pod_name + '/NSObject+PDLAssociation'
        end

    end
end
