# XAttributedString
NSAttributedString Wrap

//核心技术用到Swift5 插值新特性。编译器至少要swift5以上。XCode 10.2以上。
//示例
let font24 = UIFont.systemFont(ofSize: 24)
let username = "hst"
let x:XAttributedString = """
Hello \(username, .color(.red), .font(UIFont.systemFont(ofSize: 48))), isn't this \("cool", .color(.blue), .oblique, .font(font24))
Go there to \("learn more about String Interpolation", .link("https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md"))!
"""

UILabel.attributedText = x.attributedString
