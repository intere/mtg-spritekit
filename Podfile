# Uncomment the next line to define a global platform for your project



target 'CardGame' do
  platform :ios, '13.0'
  use_frameworks!
  inhibit_all_warnings!

  # Pods for CardGame
  pod 'MTGSDKSwift', :git => 'git@github.com:intere/mtg-sdk-swift.git', :branch => 'tvos'
  pod 'Kingfisher'
  pod 'Cartography', '~> 3.0'

  target 'CardGameTests' do
    inherit! :search_paths
  end

end


target 'tvCardGameMTG' do
  platform :tvos, '9.3'
  use_frameworks!

  # Pods for CardGame
  pod 'MTGSDKSwift', :git => 'git@github.com:intere/mtg-sdk-swift.git', :branch => 'tvos'
  pod 'Kingfisher'

  target 'tvCardGameMTGTests' do
    inherit! :search_paths
  end

end


# Post Installation Tasks
post_install do |installer|
  puts "Running Post-Installation Tasks..."

  swift42Pods = ['Cartography']

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # config.build_settings['ENABLE_BITCODE'] = 'NO' # Disables Bitcode for every Pod
      config.build_settings.delete('DEBUG_INFORMATION_FORMAT') # Enabling Debug Symbol Generation for every Pod
      config.build_settings['SWIFT_VERSION'] = '4.2' if swift42Pods.include? target.name
    end
  end

end

