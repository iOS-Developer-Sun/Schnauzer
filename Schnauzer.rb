SOURCE_FILES = '*.{h,hpp,c,cc,cpp,m,mm,s,S,o}'.freeze
HEADER_FILES = '*.{h,hpp}'.freeze
LIRBARY_FILES = 'lib*.a'.freeze
OSX_VERSION = '10.10'.freeze
IOS_VERSION = '9.0'.freeze

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
    s.osx.deployment_target = OSX_VERSION
    s.ios.deployment_target = IOS_VERSION
end

def SchnauzerSubspec(s, name, platform)
    ss = s.subspec name do |ss|
        source_files = '**/' + SOURCE_FILES
        header_files = '**/' + HEADER_FILES
        librariy_files = '**/' + LIRBARY_FILES
        base = s.base

        ss.osx.deployment_target = platform[:osx] if platform.key?(:osx)
        ss.ios.deployment_target = platform[:ios] if platform.key?(:ios)
        ss.frameworks = 'Foundation'
        if s.is_library
            ss.source_files = base + name + '/' + header_files
            ss.vendored_library = base + name + '/' + librariy_files
        else
            ss.source_files = base + name + '/' + source_files
        end
        yield(ss) if block_given?
    end
end


def SchnauzerSpec(name, poodle_pod_name, path: nil, is_library: false, default_subspec: nil)
    Pod::Spec.new do |s|
        path = name if path == nil

        class << s
            attr_accessor :base, :is_library
        end
        s.base = path + '/'
        s.is_library = is_library

        s.name = name
        s.default_subspec = default_subspec

        pod_name = name

        SchnauzerCommonConfigurate(s)

        platform_osx = { :osx => OSX_VERSION }
        platform_ios = { :ios => IOS_VERSION }
        platform_universal = { :osx => OSX_VERSION, :ios => IOS_VERSION }

        SchnauzerSubspec(s, 'SNZCrashAnalyzer', platform_universal) do |ss|
            ss.dependency poodle_pod_name + '/PDLFileSystemViewController'
            ss.dependency poodle_pod_name + '/UIViewController+PDLNavigationBar'
        end

        SchnauzerSubspec(s, 'SNZNonThreadSafeAnalyzer', platform_universal) do |ss|
            ss.dependency poodle_pod_name + '/PDLNonThreadSafeObserver'
            ss.dependency poodle_pod_name + '/NSObject+PDLAssociation'
        end
    end
end
