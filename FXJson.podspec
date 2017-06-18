Pod::Spec.new do |s|
  s.name         = "FXJson"
  s.version      = "1.0.5"
  s.summary      = "Json解析框架"

  s.homepage     = "https://github.com/zqw87699/FXJson"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = {"zhangdazong" => "929013100@qq.com"}

  s.source       = { :git => "https://github.com/zqw87699/FXJson.git", :tag => "#{s.version}"}

  s.platform     = :ios, "7.0"

  s.source_files  = "Classes/*.{h,m}"

  s.public_header_files = "Classes/*.h"

  s.frameworks = "Foundation", "UIKit"

  s.module_name = 'FXJson' 

  s.requires_arc = true

end