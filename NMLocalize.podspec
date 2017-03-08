Pod::Spec.new do |s|
  s.name             = 'NMLocalize'
  s.version          = '0.0.5'
  s.summary          = 'Shortcut for NSLocalizedString'
  s.description      = <<-DESC
Easily translate your app with 'L' functions
                       DESC

  s.homepage         = 'https://github.com/NicolasMahe/NMLocalize'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nicolas Mahé' => 'nicolas@mahe.me' }
  s.source           = { :git => 'https://github.com/NicolasMahe/NMLocalize.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'NMLocalize/**/*.swift'
end
