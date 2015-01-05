Pod::Spec.new do |s|
  s.name         = "ProtocolBuffersSwift"
  s.version      = "1.2"
  s.summary      = "Protocol Buffers for Swift"
  s.homepage     = "http://protobuf.io#swift"
  s.license      = "Apache 2.0"
  s.documentation_url = "https://github.com/alexeyxo/protobuf-swift"
  s.license      = { :type => 'Apache License, Version 2.0', :text =>
    <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    Copyright 2008 Google Inc.

    LICENSE
  }

  # s.xcconfig = { 'PRODUCT_NAME' => 'ProtocolBuffers', 'PRODUCT_MODULE_NAME' => 'ProtocolBuffers' }

  s.author       = { "Alexey Khokhlov" => "alexeyxo@gmail.com" }

  s.authors      = { "Alexey Khokhlov" => "alexeyxo@gmail.com" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source       = { :git => "https://github.com/alexeyxo/protobuf-swift.git", :tag => "v1.2", :branch => 'pods' }
  s.source_files = 'src/ProtocolBuffers/runtime-pb-swift/*.{h,swift}'
  s.requires_arc = true
  s.frameworks   = 'Foundation'
end
