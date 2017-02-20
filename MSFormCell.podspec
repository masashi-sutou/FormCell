Pod::Spec.new do |s|
  s.name                  = "MSFormCell"
  s.version               = "1.0.3"
  s.summary               = "MSFormCell is customized UITableViewCell for entry form."
  s.homepage              = "https://github.com/masashi-sutou/MSFormCell"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.source                = { :git => "https://github.com/masashi-sutou/MSFormCell.git",  :tag => s.version }
  s.source_files          = "MSFormCell", "MSFormCell/**/*.{swift}"
  s.requires_arc          = true
  s.platform              = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = ['UIKit', 'Foundation']
  s.author                = { "masashi-sutou" => "sutou.masasi@gmail.com" }
end
