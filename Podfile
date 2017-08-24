platform :ios, "8.0"
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def all_pods
  use_frameworks!
  pod 'SnapKit', '~> 3.2'
  pod 'CardIO'
  pod 'Stripe'
  pod 'Alamofire'
  pod 'SwiftHEXColors'
end

target ‘Checkout’ do
    all_pods
end

target ‘CheckoutTests' do
    all_pods
end

target ‘CheckoutUITests' do
    all_pods
end
