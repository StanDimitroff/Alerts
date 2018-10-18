Pod::Spec.new do |s|
  s.name             = 'Alerts'
  s.version          = '1.0.2'
  s.summary          = 'Alerts & actions on top of UIAlertController'

  s.description      = <<-DESC
Create alerts & actions with many responders binded to every action.
All in a chainable manner. Both for iPhone and iPad.
                       DESC

  s.homepage         = 'https://github.com/StanDimitroff/Alerts'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'StanDimitroff' => 'standimitroff@gmail.com' }
  s.source           = { :git => 'https://github.com/StanDimitroff/Alerts.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/standimitroff'

  s.ios.deployment_target = '9.3'
  s.swift_version = '4.2'

  s.source_files = 'Alerts/Classes/**/*'

end
