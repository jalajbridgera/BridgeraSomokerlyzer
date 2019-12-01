
Pod::Spec.new do |s|
  s.name         = "RNBridgeraSmokerlyzer"
  s.version      = "1.0.0"
  s.summary      = "RNBridgeraSmokerlyzer"
  s.description  = <<-DESC
                  RNBridgeraSmokerlyzer
                   DESC
  s.homepage     = "https://github.com/jalajbridgera/BridgeraSomokerlyzer.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jalajbridgera/BridgeraSomokerlyzer.git", :tag => "master" }
  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  