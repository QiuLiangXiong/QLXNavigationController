Pod::Spec.new do |s|
s.name = 'QLXNavigationController'
s.version = '1.1.0'
s.license = 'MIT'
s.summary = '用法和 UINavigationController 完全一致 可以当做UINavigationController QLXNavigationController 解决了不同导航栏背景不一致带来的过度效果不佳问题。 支持push一个导航栏控制器.'
s.homepage = 'https://github.com/QiuLiangXiong/QLXNavigationController'
s.authors = { 'QiuLiangXiong' => '820686089@qq.com' }
s.source = { :git => 'https://github.com/QiuLiangXiong/QLXNavigationController.git', :tag => "1.1.0" }
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = 'QLXNavigationControllerDemo/QLXNavigationController/*.{h,m}'
end
