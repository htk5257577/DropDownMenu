Pod::Spec.new do |s|
  s.name         = "DropDownMenu"
  s.version      = "0.0.1"
  s.summary      = "A DropDownMenu"
  s.description  = %{
    A DropDownMenu in iOS
  }

  s.homepage     = "https://github.com/htk5257577/DropDownMenu"
  s.license      = "MIT "
  s.author       = { "htk5257577" => "280071019@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/htk5257577/DropDownMenu.git", :tag => "#{s.version}" }

  s.source_files  = "Class", "DropDownMenu/Class/*.{h,m}"
  s.frameworks   = 'Foundation', 'UIKit'
end
