#
# Be sure to run `pod lib lint NRControls.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'NRControls'
s.version          = '1.0.0'
s.summary          = 'This class is used for using a common controls like alert, action sheet and imagepicker controller with proper completion Handlers.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
NRControls: This class is used for using a common controls like alert, action sheet and imagepicker controller with proper completion Handlers. It means when you open the image picker controller you dont worry about implementing the delegate of imagepickercontroller, instead you will get your selected image within the same line of code in completion handler. This library mainly contains the five methods which are for following purpose:
1) Imagepicker controller
2) AlertView
3) Action Sheet
4) AlertView with textfield (eg. you can use this in case of forgot password and in many more cases.)
5) Take or choose photo which use above methods and gives you the selected image within same line of code with the help of completion handler.
DESC

s.homepage         = 'https://github.com/naveenrana1309/NRControls'
#s.screenshots     = 'https://appetize.io/app/69n2n4vh17kj6g6dhk3jj9frmw'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'naveenrana1309' => 'naveenrana1309@gmail.com' }
s.source           = { :git => 'https://github.com/naveenrana1309/NRControls.git', :tag => s.version.to_s }

s.social_media_url = 'https://www.linkedin.com/in/naveen-rana-9a371a40'

s.ios.deployment_target = '8.0'

s.source_files = 'NRControls/Classes/**/*'

# s.resource_bundles = {
#   'NRControls' => ['NRControls/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'Alamofire', '~> 3.3'
s.dependency 'ReachabilitySwift', '~> 2.3'

end
