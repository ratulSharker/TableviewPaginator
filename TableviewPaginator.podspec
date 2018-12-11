#
# Be sure to run `pod lib lint TableviewPaginator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TableviewPaginator'
  s.version          = '0.3.2'
  s.summary          = 'Paginating UITableview, Made easy.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "This pod help to paginate a UITableView. It provide a class named TableviewPaginator, which maintain all the nitty gritty offset calculation and maintain the showing the load more cell. All you need to implement some delegate and call some of method to let the class know all the state of the tableview. Few drop in solution exists but they all lack the feature is like providing custom load more cell, besides they work with UITableViewController or UITableView. None of them are generic solution. Thats why this pod comes in handy."

  s.homepage         = 'https://github.com/ratulSharker/TableviewPaginator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Ratul sharker" => "sharker.ratul.08@gmail.com" }
  s.source           = { :git => 'https://github.com/ratulSharker/TableviewPaginator.git', :tag => '0.3.2' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TableviewPaginator/Classes/**/*'
  s.swift_version = '4.2'
  
  # s.resource_bundles = {
  #   'TableviewPaginator' => ['TableviewPaginator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
