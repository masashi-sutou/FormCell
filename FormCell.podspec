Pod::Spec.new do |s|
  s.name                  = "FormCell"
  s.version               = "1.2.2"
  s.summary               = "FormCell is customized UITableViewCell for entry form."
  s.homepage              = "https://github.com/masashi-sutou/FormCell"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.source                = { :git => "https://github.com/masashi-sutou/FormCell.git",  :tag => s.version }
  s.source_files          = "FormCell", "FormCell/**/*.{swift}"
  s.requires_arc          = true
  s.platform              = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.ios.frameworks        = ['UIKit', 'Foundation']
  s.author                = { "masashi-sutou" => "sutou.masasi@gmail.com" }
end
