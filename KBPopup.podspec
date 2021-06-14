Pod::Spec.new do |spec|
  spec.name         = "KBPopup"
  spec.version      = "1.0"
  spec.summary      = "iOS带箭头的起泡弹窗"
  spec.description  = <<-DESC
                      iOS带箭头的起泡弹窗，使用于需要在页面内弹窗的场景
                   DESC

  spec.homepage      = "https://github.com/kuibu-team/KBPopup.git"
  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.author        = { "DancewithPeng" => "dancewithpeng@gmail.com" }
  spec.platform      = :ios, "10.0"
  spec.swift_version = '5.0'
  spec.source        = { :git => "https://github.com/kuibu-team/KBPopup.git", :tag => "#{spec.version}" }  
  spec.source_files  = "KBPopup/Sources", "KBPopup/Sources/**/*.{swift}"

  spec.dependency 'KBDecorationView', '~> 1.5.0'

end
