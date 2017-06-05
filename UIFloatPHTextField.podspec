Pod::Spec.new do |s|
  s.name             = 'UIFloatPHTextField'
  s.version          = '0.5.0'
  s.summary          = 'Create a label from placeholder in UITextField and easy use for dropdown in UITextField'
  s.description      = <<-DESC
                        UIFloatPHTextField is simple ui for create placeholder replace label and base class for dropdown.
                       DESC
  s.homepage         = 'https://github.com/sawijaya/UIFloatPHTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sawijaya' => 'wijaya.salim05@gmail.com' }
  s.source           = { :git => 'https://github.com/sawijaya/UIFloatPHTextField.git', :tag => s.version }
  # s.resource_bundles = {
  #   s.name => ['UIFloatPHTextField/Resources/Images/*.png']
  # }
  s.resources = ['UIFloatPHTextField/Resources/Images/*.png']
  s.ios.deployment_target = '8.0'
  s.source_files = ['UIFloatPHTextField/UIDropdownTextField.swift','UIFloatPHTextField/UIFloatPHTextfield.swift',
                    'UIFloatPHTextField/Fetch.swift','UIFloatPHTextField/UIImage+UIFloatPHTextField.swift','UIFloatPHTextField/UIImageView+UIFloatPHTextField.swift',
                    'UIFloatPHTextField/Item.swift','UIFloatPHTextField/DataConvertible.swift']
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end