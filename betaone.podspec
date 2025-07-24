Pod::Spec.new do |s|
  s.name             = 'betaone'
  s.version          = '0.1.0'
  s.summary          = 'A short description of betaone.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/58142461/betaone'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '58142461' => 'jaisehrawat11@gmail.com' }
  s.source           = { :git => 'https://github.com/58142461/betaone.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'betaone/Classes/**/*'
  
  # s.resource_bundles = {
  #   'betaone' => ['betaone/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
