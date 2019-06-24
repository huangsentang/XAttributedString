//
//  XAttributedString.swift
//  TESTXX
//
//  Created by 黄森堂 on 2019/5/6.
//  Copyright © 2019 huangsentang. All rights reserved.
//

import UIKit

//核心技术用到Swift5 插值新特性。编译器至少要swift5以上。XCode 10.2以上。
//示例
//let font24 = UIFont.systemFont(ofSize: 24)
//let username = "hst"
//let x:XAttributedString = """
//Hello \(username, .color(.red), .font(UIFont.systemFont(ofSize: 48))), isn't this \("cool", .color(.blue), .oblique, .font(font24))
//Go there to \("learn more about String Interpolation", .link("https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md"))!
//"""
//
//UILabel.attributedText = x.attributedString


struct XAttributedString {
    let attributedString: NSAttributedString
}

extension XAttributedString: ExpressibleByStringLiteral {
    
    init(stringLiteral: String) {
        self.attributedString = NSAttributedString(string: stringLiteral)
    }
}

extension XAttributedString: CustomStringConvertible {
    
    var description: String {
        return String(describing: self.attributedString)
    }
    
}
extension XAttributedString: ExpressibleByStringInterpolation {
    
    init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    struct StringInterpolation: StringInterpolationProtocol {
        var attributedString: NSMutableAttributedString
        
        init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }
        
        func appendLiteral(_ literal: String) {
            let astr = NSAttributedString(string: literal)
            self.attributedString.append(astr)
        }
        
        func appendInterpolation(_ string: String, attributes: [NSAttributedString.Key: Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            self.attributedString.append(astr)
        }
    }
}

extension XAttributedString {
    
    struct Style {
        
        let attributes: [NSAttributedString.Key: Any]
        
        static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font: font])
        }
        
        static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor: color])
        }
        
        static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor: color])
        }
        
        static func link(_ link: String) -> Style {
            return .link(URL(string: link)!)
        }
        
        static func link(_ link: URL) -> Style {
            return Style(attributes: [.link: link])
        }
        
        static let oblique = Style(attributes: [.obliqueness: 0.1])
        
        static func underline(_ color: UIColor, _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue
                ])
        }
        
        static func alignment(_ alignment: NSTextAlignment) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.alignment = alignment
            return Style(attributes: [.paragraphStyle: ps])
        }
    }
}

extension XAttributedString.StringInterpolation {
    
    func appendInterpolation(_ string: String, _ style: XAttributedString.Style) {
        let astr = NSAttributedString(string: string, attributes: style.attributes)
        self.attributedString.append(astr)
    }

    func appendInterpolation(_ string: String, _ style: XAttributedString.Style...) {
        

        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        
        let astr = NSAttributedString(string: string, attributes: attrs)
        self.attributedString.append(astr)
    }
}

extension XAttributedString.StringInterpolation {
    
    func appendInterpolation(image: UIImage, scale: CGFloat = 1.0) {
        let attachment = NSTextAttachment()
        attachment.image = image
        self.attributedString.append(NSAttributedString(attachment: attachment))
    }
}

extension XAttributedString.StringInterpolation {
    
    func appendInterpolation(_ string: XAttributedString, _ style: XAttributedString.Style...) {
        
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        
        self.attributedString.append(mas)
    }
}
