def SchnauzerCommonConfigurate(s)
    s.version = "0.0.1"
    s.summary = "Lots of fun."
    s.description = <<-DESC
    Schnauzer, really lots of fun.
    DESC
    s.homepage = "https://github.com/iOS-Developer-Sun/Schnauzer"
    s.license = "MIT"
    s.author = { "Schnauzer" => "250764090@qq.com" }
    s.source = { :git => "https://github.com/iOS-Developer-Sun/Schnauzer.git", :tag => "#{s.version}" }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

def SchnauzerSubspec(s, name, platform)
    support_osx = platform.key?(:osx)
    support_ios = platform.key?(:ios)
    hash = s.snz_hash
    is_library = hash[:is_library]
    is_macos = hash[:is_macos]
    source_files = hash[:source_files]
    header_files = hash[:header_files]
    library_files = hash[:library_files]

    if is_library
        return if (!support_osx && is_macos) || (!support_ios && !is_macos)
    end

    ss = s.subspec name do |ss|
        base = s.snz_hash[:base]

        ss.frameworks = 'Foundation'
        if is_library
            ss.source_files = base + name + '/' + '**/' + header_files
            if is_macos
                ss.osx.deployment_target = platform[:osx]
                ss.vendored_library = base + name + '/macos/' + library_files
            else
                ss.ios.deployment_target = platform[:ios]
                ss.vendored_library = base + name + '/ios/' + library_files
            end
        else
            ss.osx.deployment_target = platform[:osx] if support_osx
            ss.ios.deployment_target = platform[:ios] if support_ios
            ss.source_files = base + name + '/' + '**/' + source_files
        end
        yield(ss) if block_given?
    end
end


def SchnauzerSpec(name, poodle_pod_name, path: nil, is_library: false, is_macos: false, default_subspec: nil)
    Pod::Spec.new do |s|
        path = name if path == nil
        base = path + '/'

        # constants
        source_files = '*.{h,hpp,c,cc,cpp,m,mm,s,S,o}'.freeze
        header_files = '*.{h,hpp}'.freeze
        library_files = '*.a'.freeze
        osx_version = '10.10'.freeze
        ios_version = '9.0'.freeze

        # extra storage
        class << s
            attr_accessor :snz_hash
        end
        s.snz_hash = {
            :base => base,
            :is_library => is_library,
            :is_macos => is_macos,
            :source_files => source_files,
            :header_files => header_files,
            :library_files => library_files,
        }

        s.name = name
        s.default_subspec = default_subspec
        s.osx.deployment_target = osx_version
        s.ios.deployment_target = ios_version

        SchnauzerCommonConfigurate(s)

        # varirables for subspec
        pod_name = name
        platform_osx = { :osx => osx_version }
        platform_ios = { :ios => ios_version }
        platform_universal = { :osx => osx_version, :ios => ios_version }

        SchnauzerSubspec(s, 'SNZCrashAnalyzer', platform_ios) do |ss|
            ss.dependency poodle_pod_name + '/PDLFileSystemViewController'
            ss.dependency poodle_pod_name + '/UIViewController+PDLNavigationBar'
        end

        SchnauzerSubspec(s, 'SNZNonThreadSafeAnalyzer', platform_universal) do |ss|
            ss.dependency poodle_pod_name + '/PDLNonThreadSafeObserver'
            ss.dependency poodle_pod_name + '/NSObject+PDLAssociation'
        end
    end
end
